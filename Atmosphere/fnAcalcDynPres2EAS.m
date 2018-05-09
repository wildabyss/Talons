function EAS = fnAcalcDynPres2EAS(q, unit)
% Convert dynamic pressure to EAS
%
% Inputs:	q: dynamic pressure
%			unit: 0 for imperial (kt, lbf), 1 for SI (m/s, N)
% Outputs:	equivalent airspeed (EAS)

rho0 = fnAcalcDensity(1, unit);
EAS = sqrt(2*q/rho0);
if unit==0
    EAS = EAS*0.592484;
end