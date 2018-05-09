function mu = fnAcalcMu(theta, unit)
% Calculate the dynamic viscosity of air
%
% Inputs:	theta: temperature ratio
%			unit: 0 for imperial (slug/ft/sec), 1 for SI (Pa.sec)
% Outputs:	dynamic viscosity (mu)

OAT0 = 288.15;
C1 = 1.458e-6; % kg/m/s/sqrt(K)
S = 110.4; % Kelvin
mu = sqrt(OAT0)*C1*theta.^(3/2)./(theta+S/OAT0);

if unit==0
    mu = mu*0.0208854;
end

end
