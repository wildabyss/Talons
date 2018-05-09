function TAS = fnAcalcDynPres2TAS(q, sigma, unit)
% Convert dynamic pressure to TAS
%
% Inputs:	q: dynamic pressure
%			sigma: density ratio
%			unit: 0 for imperial (kt, psf), 1 for SI (m/s, N/sq.m)
% Outputs:	true airspeed (TAS)

rho = fnAcalcDensity(sigma, unit);
TAS = sqrt(2*q/rho);
if unit==0
    % Convert to kts
    TAS = TAS*0.592484;
end