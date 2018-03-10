function q = fnAcalcEAS2DynPres(EAS, unit)

rho0 = fnAcalcDensity(1, unit);
if unit==0
    % Convert to ft/s
    EAS = EAS/0.592484;
end
q = 1/2*rho0*EAS.^2;