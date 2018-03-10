function density = fnAcalcDensity(sigma, unit)
% Calculate the density given density ratio

rho0 = 0.00237689; % slug/cu.ft
density = rho0*sigma;

if unit==1
    density = density*515.379;
end