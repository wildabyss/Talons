function q = fnAcalcMach2DynPres(Mach, delta, unit)
% Convert Mach to dynamic pressure
%
% Inputs:	Mach
%			delta: pressure ratio
%			unit: 0 for imperial (psf), 1 for SI (N/sq.m)
% Outputs:	true airspeed (TAS)

P = fnAcalcStaticPres(delta, unit);
q = 1/2*1.4*P.*Mach.^2;