% 1. The trimmable AoA range is purely linear. The actual trimmable range 
% will be significantly smaller than this.
% 2. Elevator sensitivity to speed change (rad of elevator for every m/s in 
% speed change). Speed stability requires that de/dV be positive
% 3. Elevator sensitivity to g pull/push (rad of elevator for 1g change in
% the normal axis). Stability requires that de/(n-1) be negative

% CL0 = CL obtained from aerodynamic data (to match Cm0)
% CLe = trimmed CL

function [min_AoA_trim max_AoA_trim dedV deG] = fnCalcElevatorAuthority(CGx, CGx_ref, ...
    CL0, CLe, CLa, CLde, CLq, Cm0, Cma, Cmde, Cmq, alpha_0, V, W, S, MAC, ...
    rho, g, de_max)

    % correct the aerodynamic coefficients to longitudinal CG
    Cm0 = Cm0 + CL0*(CGx-CGx_ref)/MAC;
    Cma = Cma + CLa*(CGx-CGx_ref)/MAC;
    Cmq = Cmq + CLq*(CGx-CGx_ref)/MAC;
    Cmde = Cmde + CLde*(CGx-CGx_ref)/MAC;

    % min and max trimmable AoA
    % fully linear
    min_AoA_trim = (-Cm0-Cmde*de_max)/Cma + alpha_0;
    max_AoA_trim = (-Cm0+Cmde*de_max)/Cma + alpha_0;

    % speed stability (dedV)
    
    det = CLa*Cmde-CLde*Cma;
    dedV = 2*CLe*Cma/det/V;
    
    % elevator angle per g (deG)
    
    CW = W/(1/2*rho*V^2*S);
    mu = 2*W/g/rho/S/MAC;
    deG = -CW/det*(Cma-1/2/mu*(CLq*Cma-CLa*Cmq));
end