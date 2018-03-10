function DISA = fnAcalcOAT2DISA(OAT, delta)

OAT0 = 288.15; % Kelvin
OAT = OAT + 273.15;
theta_ISA = fnAcalcTheta(delta, 0);
OAT_ISA = theta_ISA*OAT0;

DISA = OAT - OAT_ISA;