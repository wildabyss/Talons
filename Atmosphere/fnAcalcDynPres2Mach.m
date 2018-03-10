function Mach = fnAcalcDynPres2Mach(q, delta, unit)

P = fnAcalcStaticPres(delta, unit);
Mach = sqrt(2*q/1.4/P);