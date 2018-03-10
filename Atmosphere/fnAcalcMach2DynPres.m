function q = fnAcalcMach2DynPres(Mach, delta, unit)

P = fnAcalcStaticPres(delta, unit);
q = 1/2*1.4*P.*Mach.^2;