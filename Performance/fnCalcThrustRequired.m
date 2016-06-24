%% Calculates thrust required
% Tr = D

function Tr = fnCalcThrustRequired(CD, V, S, rho)

Tr = 1/2*rho.*V.^2*S.*CD;