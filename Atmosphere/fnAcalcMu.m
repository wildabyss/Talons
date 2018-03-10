function mu = fnAcalcMu(theta, unit)
% Calculate the dynamic viscosity of air

OAT0 = 288.15;
C1 = 1.458e-6; % kg/m/s/sqrt(K)
S = 110.4; % Kelvin
mu = sqrt(OAT0)*C1*theta.^(3/2)./(theta+S/OAT0);

if unit==0
    mu = mu*0.0208854;
end

end
