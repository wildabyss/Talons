% The maximum achievable steady sideslip given max rudder input.
% Sideslip translates to maximum crosswind holding

function [beta_max] = fnCalcRudderAuthority(CGx, CGx_ref, CL, Cyb, Cyda, Cydr, ...
    Clb, Clda, Cldr, Cnb, Cnda, Cndr, max_rud, b)

    % correct the aerodynamic coefficients to longitudinal CG
    Cnb = Cnb + Cyb*(CGx-CGx_ref)/b;
    Cnda = Cnda + Cyda*(CGx-CGx_ref)/b;
    Cndr = Cndr + Cydr*(CGx-CGx_ref)/b;

    A = [CL Cyb Cyda
        0 Clb Clda
        0 Cnb Cnda];
    B = -[Cydr*max_rud
        Cldr*max_rud
        Cndr*max_rud];
    
    x = A\B;
    beta_max = x(2);
end

