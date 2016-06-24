% Find trim values
% Angles are in radians

function [alpha_trim de_trim] = fnTrim(CL, CLa, CLde, Cma, Cmde, CL0, ...
    alpha0, Cm0, CGx, CGx_ref, MAC)

    % correct the aerodynamic coefficients to longitudinal CG
    Cm0 = Cm0 + CL*(CGx-CGx_ref)/MAC;
    Cma = Cma + CLa*(CGx-CGx_ref)/MAC;
    Cmde = Cmde + CLde*(CGx-CGx_ref)/MAC;

    de_trim = -(Cm0*CLa+Cma*(CL-CL0))/(Cmde*CLa-CLde*Cma);
    alpha_trim = (CL-CL0-CLde*de_trim)/CLa + alpha0;

end