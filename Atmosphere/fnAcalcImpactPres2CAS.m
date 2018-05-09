function CAS = fnAcalcImpactPres2CAS(qc, unit)
% Convert impact pressure to CAS
%
% Inputs:	qc: impact pressure
%			unit: 0 for imperial (kt, psf), 1 for SI (m/s, N/sq.m)
% Outputs:	calibrated airspeed (CAS)

a0 = fnAcalcSpeedOfSound(1, unit);
if unit==0
    % Convert to ft/s
    a0 = a0*1.68781;
end
P0 = fnAcalcStaticPres(1, unit);
CAS = a0*sqrt(5*((qc/P0+1).^(2/7)-1));
if unit==0
    % Convert to kts
    CAS = CAS*0.592484;
end