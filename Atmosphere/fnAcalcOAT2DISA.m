function DISA = fnAcalcOAT2DISA(OAT, delta)
% Convert outside air temperature to delta ISA temperature
% Units in Celsius
%
% Inputs:	OAT: outside air temperature (C)
%			delta: pressure ratio
% Outputs:	delta ISA temperature (C)

OAT0 = 288.15; % Kelvin
OAT = OAT + 273.15;
theta_ISA = fnAcalcTheta(delta, 0);
OAT_ISA = theta_ISA*OAT0;

DISA = OAT - OAT_ISA;