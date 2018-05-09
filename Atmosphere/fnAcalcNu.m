function nu = fnAcalcNu(delta, theta, unit)
% Calculate the kinematic viscosity of air
%
% Inputs:	delta: pressure ratio
%			theta: temperature ratio
%			unit: 0 for imperial (sq.ft/sec), 1 for SI (sq.m/sec)
% Outputs:	kinematic viscosity (nu)

mu = fnAcalcMu(theta, unit);
sigma = fnAcalcSigma(delta, theta);
rho = fnAcalcDensity(sigma, unit);
nu = mu/rho;

end
