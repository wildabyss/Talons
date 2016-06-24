%This function uses the Blasius solution to determine the skin friction
%drag across a tapered surface, this solution DOES NOT apply to a
%non-tapered surface
% w = length perpendicular to the flow
% turb = is it fully turbulent?

function Cf = fnCalcCft (rho, v, root_chord, tip_chord, mu, s, w, turb)

%This function accounts for the top and bottom surfaces of of a given
%object and normalizes the coefficient with respect to the given span

Re_t = 5e5;                         % transition Re
delta = tip_chord - root_chord;
xt = mu*Re_t/rho/v;         		% flow separation length

% since the chord is a function of spanwise axis, we'll need to integrate
% to find drag (for top and bottom sides)
% D = int(rho*v^2*cf*(delta/w*y+root_chord), y, 0, w);
% chord function
fnC = @(y)(delta/w*y+root_chord);
% local laminar solution
fnCf_lam = @(c)(1.328/sqrt(rho*v*c/mu));
% local turbulent solution
fnCf_tub = @(c)(1.328/sqrt(Re_t) + 0.074/(rho*v*c/mu)^0.2 - 0.074/Re_t^0.2);
% fully turbulent solution
fnCf_ftub = @(c)(0.074/(rho*v*c/mu)^0.2); 

% use Simpson's quadrature
N = 100;                            % number of subintervals
dy = w/N;
D = 0;                              % quadrature sum
for i=0:N-1
    yi = i*dy;                      % yi
    yi1 = (i+1)*dy;                 % yi+1
    yim = (yi+yi1)/2;               % yi+0.5
    
    ci = fnC(yi);
    ci1 = fnC(yi1);
    cim = fnC(yim);
    
    if (turb)
        % Fully turbulent
        cfi = fnCf_ftub(ci);
        cfi1 = fnCf_ftub(ci1);
        cfim = fnCf_ftub(cim);
    elseif (xt>cim)
        % If the flow remains completely laminar
        cfi = fnCf_lam(ci);
        cfi1 = fnCf_lam(ci1);
        cfim = fnCf_lam(cim);
    else
        % Otherwise if we have turbulent flow
        cfi = fnCf_tub(ci);
        cfi1 = fnCf_tub(ci1);
        cfim = fnCf_tub(cim);
    end
    
    fi = rho*v^2*cfi*ci;
    fi1 = rho*v^2*cfi1*ci1;
    fim = rho*v^2*cfim*cim;
    
    D = D + dy/6*(fi+4*fim+fi1);
end

Cf = D/0.5/rho/v^2/s;

end