function q = fnAcalcEAS2DynPres(EAS, unit)
% Convert EAS to dynamic pressure
%
% Inputs:	EAS: equivalent airspeed
%			unit: 0 for imperial (kt, psf), 1 for SI (m/s, N/sq.m)
% Outputs:	dynamic pressure

rho0 = fnAcalcDensity(1, unit);
if unit==0
    % Convert to ft/s
    EAS = EAS/0.592484;
end
q = 1/2*rho0*EAS.^2;