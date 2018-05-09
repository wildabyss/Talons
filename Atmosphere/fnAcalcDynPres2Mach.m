function Mach = fnAcalcDynPres2Mach(q, delta, unit)
% Convert dynamic pressure to Mach
%
% Inputs:	q: dynamic pressure
%			delta: pressure ratio
%			unit: 0 for imperial (psf), 1 for SI (N/sq.m)
% Outputs:	Mach

P = fnAcalcStaticPres(delta, unit);
Mach = sqrt(2*q/1.4/P);