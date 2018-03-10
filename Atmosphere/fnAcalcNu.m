function nu = fnAcalcNu(delta, theta, unit)
% Calculate the kinematic viscosity of air

mu = fnAcalcMu(theta, unit);
sigma = fnAcalcSigma(delta, theta);
rho = fnAcalcDensity(sigma, unit);
nu = mu/rho;

end
