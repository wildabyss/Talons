% Calculates aeroelastic loading, divergence airspeed
% The torsional stiffnesses are obtained relying on the thin wall shear
% flow theory. See paper in Documentation for more reading on the subject.

function [Vdiv] = fnCalcAeroelastics(central_span, outer_span, root_chord, tip_chord, sweep)

a0_central = clParameters.central_airfoil_a0;
a0_outer = clParameters.outer_airfoil_a0;
central_airfoil_ac = clParameters.central_airfoil_ac;
outer_airfoil_ac = clParameters.outer_airfoil_ac;
central_airfoil = clParameters.central_airfoil;
outer_airfoil = clParameters.outer_airfoil;

slanted_forward_spar_x_chord_ratio = clParameters.slanted_forward_spar_x_chord_ratio;
central_spar_root_chord_ratio = clParameters.central_spar_root_chord_ratio;
l_interpol = clParameters.mid_interpolation_length;

t_shearweb_depron = clParameters.shear_web_thickness_depron;
t_sheeting = clParameters.dbox_sheeting_thickness;
t_cf_stab = clParameters.cf_stab_thickness;
flange_thickness = clParameters.flange_thickness;

G_balsa = clParameters.balsa_shear_modulus;
G_cf = clParameters.cf_shear_modulus;
G_depron = clParameters.depron_shear_modulus;
E_cf = clParameters.cf_elastic_modulus;
E_depron = clParameters.depron_elastic_modulus;

% spanwise discretization
Nspan_central = 10; Nspan_mid = 4; Nspan_outer = 10;
Nspan = Nspan_central + Nspan_mid + Nspan_outer;
DY = [ones(1,Nspan_central)*(central_span/2/Nspan_central), ...
    ones(1,Nspan_mid)*(l_interpol/Nspan_mid), ...
    ones(1,Nspan_outer)*(outer_span/Nspan_outer)];
GJ = zeros(1,Nspan+1); EI = zeros(1,Nspan+1);
EA = zeros(1,Nspan+1); AC = zeros(1,Nspan+1);
A0 = zeros(1,Nspan+1); CH = zeros(1,Nspan+1);

ySpan = 0;
for n=0:Nspan
    
    total_l = central_span/2+l_interpol+outer_span;
    fnChord = @(y)(tip_chord-root_chord)/total_l*y+root_chord;
    fnRearSparChord = @(y)central_spar_root_chord_ratio*root_chord - tan(sweep)*y;
    
    chord = fnChord(ySpan); CH(n+1) = chord;
    origin = [slanted_forward_spar_x_chord_ratio*chord, 0, 0];
    
    % airfoil spline
    if ySpan<total_l/2
        [sp_upper sp_lower] = fnSplineAirfoilData(central_airfoil);
        AC(n+1) = central_airfoil_ac*chord;
        A0(n+1) = a0_central;
    else
        [sp_upper sp_lower] = fnSplineAirfoilData(outer_airfoil);
        AC(n+1) = outer_airfoil_ac*chord;
        A0(n+1) = a0_outer;
    end

    %-- calculation for d-box

    % calculate Ixx_dbox, GJ_dbox and A_dbox (D-box)
    N = 200;
    dx = slanted_forward_spar_x_chord_ratio*chord/N;
    x1=0; Ixx_dbox = 0; GJ_dbox = 0; A_dbox = 0;
    for i=1:N
        x2 = x1+dx;

        % upper surface
        y1 = ppval(sp_upper,x1); y2=ppval(sp_upper,x2);
        y = (y1+y2)/2; dy = y2-y1;
        ds = sqrt(dx^2+dy^2);
        Ixx_dbox = Ixx_dbox + (y-origin(2))^2*t_sheeting*ds;
        GJ_dbox = GJ_dbox + 1/G_balsa/t_sheeting*ds;
        A_dbox = A_dbox + abs(dx*y);
        % lower surface
        y1 = ppval(sp_lower,x1); y2=ppval(sp_lower,x2);
        y = (y1+y2)/2; dy = y2-y1;
        ds = sqrt(dx^2+dy^2);
        Ixx_dbox = Ixx_dbox + (y-origin(2))^2*t_sheeting*ds;
        GJ_dbox = GJ_dbox + 1/G_balsa/t_sheeting*ds;
        A_dbox = A_dbox + abs(dx*y);

        x1 = x2;
    end
    % spar contribution
    lup = ppval(sp_upper,slanted_forward_spar_x_chord_ratio*chord);
    ldown = ppval(sp_lower,slanted_forward_spar_x_chord_ratio*chord);
    Ixx_dbox = Ixx_dbox + t_shearweb_depron*lup^3/3 + t_shearweb_depron*ldown^3/3;
    % flanges
    GJ_dbox = GJ_dbox + 1/G_cf/t_shearweb_depron*2*flange_thickness;
    % shearweb
    GJ_dbox = GJ_dbox + 1/G_depron/t_shearweb_depron*(lup-2*flange_thickness-ldown);
    % compute final value
    GJ_dbox = 4*A_dbox^2/GJ_dbox;

    %-- calculation for rear spar (Ixx_dbox, GJ_dbox)

    rear_spar_loc = fnRearSparChord(ySpan);
    if rear_spar_loc<slanted_forward_spar_x_chord_ratio*chord
        % no rear spar once it intersects with the main spar
        GJ_rear = 0;
        Ixx_rear = 1;
        lup_rear = 1;
        ldown_rear = 0;
    else
        lup_rear = ppval(sp_upper,rear_spar_loc);
        ldown_rear = ppval(sp_lower,rear_spar_loc);
        h_rear = lup_rear-ldown_rear;
        Ixx_rear = (t_cf_stab*2+t_shearweb_depron)*h_rear^3/12;
        [~, J_cf] = fnGetRectangleTorsionConstants(h_rear, t_cf_stab);
        [~, J_depron] = fnGetRectangleTorsionConstants(h_rear, t_shearweb_depron);
        GJ_rear = 2*G_cf*J_cf + G_depron*J_depron;
    end

    % now we can get total torsional stiffness
    GJ(n+1) = GJ_dbox + GJ_rear;

    %-- calculate shear flow in dbox (q0)

    Qy_dbox = GJ_dbox/GJ(n+1);    % shear force in the dbox with unity dummy load
    q = 0; I1 = 0; I2 = 0;
    % lower surface
    x1 = slanted_forward_spar_x_chord_ratio*chord;
    for i=1:N
        x2 = x1-dx;
        y1 = ppval(sp_lower,x1); y2=ppval(sp_lower,x2); dy = y2-y1;
        ds = sqrt(dx^2+dy^2); y = (y1+y2)/2;
        q = q - t_sheeting*y*ds*Qy_dbox/Ixx_dbox;

        I1 = I1 - 1/t_sheeting/G_balsa*q*ds;
        I2 = I2 + 1/t_sheeting/G_balsa*ds;

        x1 = x2;
    end
    % upper surface
    x1 = 0;
    for i=1:N
        x2 = x1+dx;
        y1 = ppval(sp_upper,x1); y2=ppval(sp_upper,x2); dy = y2-y1;
        ds = sqrt(dx^2+dy^2); y = (y1+y2)/2;
        q = q - t_sheeting*y*ds*Qy_dbox/Ixx_dbox;

        I1 = I1 - 1/t_sheeting/G_balsa*q*ds;
        I2 = I2 + 1/t_sheeting/G_balsa*ds;

        x1 = x2;
    end
    % shear web and flanges
    N2 = 30;
    dy = (lup-ldown)/N2;
    for i=1:N2
        y = lup-dy*(i-1);

        q = q - t_shearweb_depron*y*dy*Qy_dbox/Ixx_dbox;

        if y > (lup-flange_thickness) || y < (ldown+flange_thickness)
            I1 = I1 - 1/t_shearweb_depron/G_cf*q*dy;
            I2 = I2 + 1/t_shearweb_depron/G_cf*dy;
        else
            I1 = I1 - 1/t_shearweb_depron/G_depron*q*dy;
            I2 = I2 + 1/t_shearweb_depron/G_depron*dy;
        end
    end
    % calculate q0
    q0_dbox = I1/I2;

    %-- calculate elastic centre
    delta = 0;
    q_dbox = q0_dbox;
    % lower surface
    x1 = slanted_forward_spar_x_chord_ratio*chord;
    for i=1:N
        x2 = x1-dx;
        x = (x1+x2)/2;

        y1 = ppval(sp_lower,x1); y2=ppval(sp_lower,x2); dy = y2-y1;
        ds = sqrt(dx^2+dy^2); y = (y1+y2)/2;
        q_dbox = q_dbox - t_sheeting*y*ds*Qy_dbox/Ixx_dbox;

        T = [-dx,dy,0]/norm([-dx,dy,0]);    % unit tangent vec
        delta = delta + q_dbox*norm(cross([x,y,0]-origin, T))*ds;

        x1 = x2;
    end
    % upper surface
    x1 = 0;
    for i=1:N
        x2 = x1+dx;
        x = (x1+x2)/2;

        y1 = ppval(sp_upper,x1); y2=ppval(sp_upper,x2); dy = y2-y1;
        ds = sqrt(dx^2+dy^2); y = (y1+y2)/2;
        q_dbox = q_dbox - t_sheeting*y*ds*Qy_dbox/Ixx_dbox;

        T = [dx,dy,0]/norm([dx,dy,0]);    % unit tangent vec
        delta = delta + q_dbox*norm(cross([x,y,0]-origin, T))*ds;

        x1 = x2;
    end
    % rear spar
    Qy_rear = GJ_rear/GJ(n+1);
    x = rear_spar_loc - slanted_forward_spar_x_chord_ratio*chord;
    delta = delta + Qy_rear/Ixx_rear*t_shearweb_depron*x*(lup_rear*(lup_rear-ldown_rear)^2/2-(lup_rear-ldown_rear)^3/6);

    % elastic axis from the LE
    EA(n+1) = origin(1)+delta;

    %-- EI

    h_sw = (lup-ldown)-flange_thickness*2;
    b = t_shearweb_depron;
    Ixx_sw = b*h_sw^3/12;
    Ixx_flange = b*(lup-ldown)^3/12-Ixx_sw;

    EI(n+1)  = E_cf*Ixx_flange + E_depron*Ixx_sw;

    % advance to next node
    if n<Nspan
        ySpan = ySpan + DY(n+1);
    end
end

% take average and arrange data for operations
SWEEP = zeros(1,Nspan); vecEI = zeros(1,Nspan); vecGJ = zeros(1,Nspan);
vecE = zeros(1,Nspan); vecA0 = zeros(1,Nspan); vecC = zeros(1,Nspan);
ySpan = 0;
for n=1:Nspan
    vecGJ(n) = (GJ(n)+GJ(n+1))/2;
    vecEI(n) = (EI(n)+EI(n+1))/2;
    vecE(n) = (EA(n)+EA(n+1))/2 - (AC(n)+AC(n+1))/2;
    vecC(n) = (CH(n)+CH(n+1))/2;
    vecA0(n) = (A0(n)+A0(n+1))/2;
    
    dy = ySpan+DY(n) - ySpan;
    SWEEP(n) = atan(((tan(sweep)*(ySpan+DY(n))+EA(n+1))-(tan(sweep)*ySpan+EA(n)))/dy);
    
    ySpan = ySpan + DY(n);
end

% calculate flexibility matrix
[~, Czt, Ctt] = fnCalcSpanFlexibilityMatrix(vecGJ, vecEI, SWEEP, DY);

% divergence airspeed
Vdiv = fnGetDivergenceSpeed(Czt, Ctt, vecE, vecC, vecA0, SWEEP, DY);

end