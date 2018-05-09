function density = fnAcalcDensity(sigma, unit)
% Calculate the density given density ratio
%
% Inputs:	sigma: density ratio
%			unit: 0 for imperial (slug/cu.ft), 1 for SI (kg/cu.m)
% Outputs:	density

rho0 = 0.00237689; % slug/cu.ft
density = rho0*sigma;

if unit==1
    density = density*515.379;
end