function q = fnAcalcTAS2DynPres(TAS, sigma, unit)
% Convert TAS to dynamic pressure
%
% Inputs:	TAS: true airspeed
%			sigma: density ratio
%			unit: 0=imperial (psf, kt), 1=SI (N/sq.m, m/s)
% Outputs:	dynamic pressure

rho = fnAcalcDensity(sigma, unit);
if unit==0
    % Convert to ft/s
    TAS = TAS/0.592484;
end
q = 1/2*rho.*TAS.^2;