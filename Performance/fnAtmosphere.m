function [rho T] = fnAtmosphere(hMSL, DISA)

    p0 = 101.325e3; % sea level standard pressure, kPa
    T0 = 288.15;    % K
    g  = 9.81;
    L  = 0.0065;    % temperature lapse rate, K/m
    R  = 8.314;     % ideal gas constant, J/mol/K
    M  = 0.02896;   % molar mass of dry air, kg/mol
    
    T = T0 - L*hMSL + DISA;
    p = p0*(1-L*hMSL/T0)^(g*M/R/L);
    rho = p*M/R/T;

    % convert temperature to celcius
    T = T - T0;
end