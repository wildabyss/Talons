function EAS = fnAcalcDynPres2EAS(q, unit)

rho0 = fnAcalcDensity(1, unit);
EAS = sqrt(2*q/rho0);
if unit==0
    EAS = EAS*0.592484;
end