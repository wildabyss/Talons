function TAS = fnAcalcDynPres2TAS(q, sigma, unit)

rho = fnAcalcDensity(sigma, unit);
TAS = sqrt(2*q/rho);
if unit==0
    % Convert to kts
    TAS = TAS*0.592484;
end