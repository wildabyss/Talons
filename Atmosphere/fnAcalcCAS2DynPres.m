function q = fnAcalcCAS2DynPres(CAS, delta, unit)

% Impact pressure
a0 = fnAcalcSpeedOfSound(1, unit);
P0 = fnAcalcStaticPres(1, unit);
if unit==0
    % Convert to ft/s
    CAS = CAS*1.68781;
    a0 = a0*1.68781;
end
qc = (((CAS/a0).^2/5+1).^(7/2)-1)*P0;

% P and Mach
P = fnAcalcStaticPres(delta, unit);
Mach = sqrt(((qc./P+1).^(2/7)-1)/0.2);

q = 1/2*1.4*P.*Mach.^2;
