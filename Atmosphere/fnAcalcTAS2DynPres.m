function q = fnAcalcTAS2DynPres(TAS, sigma, unit)

rho = fnAcalcDensity(sigma, unit);
if unit==0
    % Convert to ft/s
    TAS = TAS/0.592484;
end
q = 1/2*rho.*TAS.^2;