function qc = fnAcalcDynPres2ImpactPres(q, delta, unit)
% Convert dynamic pressure to impact pressure
%
% Inputs:	q: dynamic pressure
%			delta: pressure ratio
%			unit: 0 for imperial (psf), 1 for SI (N/sq.m)
% Outputs:	impact pressure

P = fnAcalcStaticPres(delta, unit);
Mach = fnAcalcDynPres2Mach(q, delta, unit);
qc = P*((1+0.2*Mach.^2).^(7/2)-1);