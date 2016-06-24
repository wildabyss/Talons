%% Function used for calculating control hinge moment
% Returns the hinge moment coefficient derivatives with respect to AoA and
% control deflection using ESDU method
% Inputs:
% two_servos: if true, then hinge moment is half of the total value

function HM = fnCalcHingeMoments(formatted_part_data, control_name, two_servos, ...
    AoA, deflection, CLa, V, rho, Re, proj_dir)

    % determine beginning and end of control surface
    found = 0;
    i0 = 1;
    i1 = 1;
    for i=1:formatted_part_data.nums
        if isfield(formatted_part_data.(sprintf('s%i',i)), control_name)
            if found == 0
                found = 1;
                i0 = i;
            else
                i1 = i;
            end
        end
    end

    % calculate geometric information of the surface
    b = fnCalcWingSpan(formatted_part_data);
    S = fnCalcPlanformArea(formatted_part_data);
    AR = fnCalcAspectRatio(b, S);
    MAC = fnCalcMAC(formatted_part_data);
    spanInd = fnSurfaceSpanwiseIndex(formatted_part_data);
    if spanInd==3
        % if it's a vertical fin, the end plate effect causes the apparent AR
        % to increase by 2
        AR = AR*2;
    end

    % spanwise beginning of control
    sw0 = formatted_part_data.(sprintf('s%i',i0)).section(spanInd);
    % spanwise end of control
    sw1 = formatted_part_data.(sprintf('s%i',i1)).section(spanInd);     
    % chordwise beginning of control
    cw0 = formatted_part_data.(sprintf('s%i',i0)).section(1) + ...
        formatted_part_data.(sprintf('s%i',i0)).section(4)*...
        formatted_part_data.(sprintf('s%i',i0)).(control_name);
    % chordwise end of control
    cw1 = formatted_part_data.(sprintf('s%i',i1)).section(1) + ...
        formatted_part_data.(sprintf('s%i',i1)).section(4)*...
        formatted_part_data.(sprintf('s%i',i1)).(control_name);
    % sweep at hinge
    swp_hng = atand((cw1-cw0)/(sw1-sw0));
    
    % calculate geometric information of the control surface
    c_ctrl0 = formatted_part_data.(sprintf('s%i',i0)).section(4) - ...
        formatted_part_data.(sprintf('s%i',i0)).section(4)*...
        formatted_part_data.(sprintf('s%i',i0)).(control_name);
    c_ctrl1 = formatted_part_data.(sprintf('s%i',i1)).section(4) - ...
        formatted_part_data.(sprintf('s%i',i1)).section(4)*...
        formatted_part_data.(sprintf('s%i',i1)).(control_name);
    c_ctrl = (c_ctrl0+c_ctrl1)/2;   % avg chord of the control surface
    S_ctrl = c_ctrl*(sw1-sw0);      % area of the control surface
    if two_servos==0
        S_ctrl = S_ctrl*2;
    end
    
    % distance of control surfrace from root over half span
    etai = (sw0 - formatted_part_data.s1.section(spanInd))/(b/2);

    % sweep of wing at 1/4 chord
    sw0 = formatted_part_data.s1.section(spanInd);
    sw1 = formatted_part_data.(sprintf('s%i',formatted_part_data.nums)).section(spanInd);
    cw0 = formatted_part_data.s1.section(1) + 0.25*formatted_part_data.s1.section(4);
    cw1 = formatted_part_data.(sprintf('s%i',formatted_part_data.nums)).section(1) + ...
        0.25*formatted_part_data.(sprintf('s%i',formatted_part_data.nums)).section(4);
    swp25 = atand((cw1-cw0)/(sw1-sw0));
    
    % sweep of wing at 1/2 chord
    cw0 = formatted_part_data.s1.section(1) + 0.5*formatted_part_data.s1.section(4);
    cw1 = formatted_part_data.(sprintf('s%i',formatted_part_data.nums)).section(1) + ...
        0.5*formatted_part_data.(sprintf('s%i',formatted_part_data.nums)).section(4);
    swp50 = atand((cw1-cw0)/(sw1-sw0));
    
    % tau = airfoil trailing edge angle
    % toc = airfoil thickness to chord ratio
    if isfield(formatted_part_data.(sprintf('s%i',i0)), 'file')
        afile = [proj_dir formatted_part_data.(sprintf('s%i',i0)).file];
        
        toc = fnAirfoilThicknessChord(afile);
        
        [u l] = fnAirfoilHeight(1, 0.95, afile);
        t_95 = u-l;
        [u l] = fnAirfoilHeight(1, 0.99, afile);
        t_99 = u-l;
        tau = atand((t_95-t_99)/0.08)*2;
    else
        tau = 0;
        toc = 0;
    end

    % control chord aft of hinge line to airfoil chord ratio
    cfoc = 1-(formatted_part_data.(sprintf('s%i',i0)).(control_name) + ...
        formatted_part_data.(sprintf('s%i',i1)).(control_name))/2;

    F_B = 1;    % plain control
    mach = 0;   % incompressible
    beta = sqrt(1-mach.^2);
    xtoc = 0.25;    % boundary layer transition ratio assume at 1/4 c
    
    % airfoil data
    [a1_0,a2_0,b1_0,b2_0,G1,G2,G3] = fnAirfoilESDU(F_B, swp_hng, beta, AR,...
        swp25, tau, toc, Re, cfoc, xtoc, etai, swp50);

    % now we calculate the actual moment
    % b1 = dChm/dalpha
    % b2_prime = dChm/dcn
    b1 = b1_0/a1_0*CLa*cosd(swp_hng) + G1 + G2; 
    b2 = (b2_0 - a2_0/a1_0*b1_0)*cosd(swp_hng)/sqrt(beta^2 + (tand(swp25))^2)...
         + a2_0/a1_0*(b1 + G3);  % streamwise
    b2_prime = b2*cosd(swp_hng); % hingewise

    % renormalize it to Cref and Sref
    HM = 1/2*rho*V^2*(b1*AoA + b2_prime*deflection)*c_ctrl*S_ctrl;

end