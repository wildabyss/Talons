function Pt = fnAcalcTotalPres(P, qc)
% Calculate total pressure given static pressure and impact pressure
%
% Inputs:	P: static pressure
%			qc: impact pressure
% Outputs:	total pressure

Pt = P + qc;