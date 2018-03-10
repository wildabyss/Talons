function [DISA, OAT] = fnAcalcTemperature(theta, delta)
% Calculate the delta ISA and outside air temperature in C given
% temperature ratio and pressure ratio
%
% Inputs: theta: temp ratio
%         delta: pressure ratio

OAT0 = 288.15; % Kelvin
OAT = theta*OAT0;

% ISA temperature at delta:
theta_ISA = fnAcalcTheta(delta, 0);
DISA = OAT - OAT0*theta_ISA;

% Convert to C
OAT = OAT - 273.15;