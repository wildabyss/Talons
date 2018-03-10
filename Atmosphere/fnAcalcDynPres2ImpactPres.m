function qc = fnAcalcDynPres2ImpactPres(q, delta, unit)

P = fnAcalcStaticPres(delta, unit);
Mach = fnAcalcDynPres2Mach(q, delta, unit);
qc = P*((1+0.2*Mach.^2).^(7/2)-1);