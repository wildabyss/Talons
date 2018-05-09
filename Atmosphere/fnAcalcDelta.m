function pressure_ratio = fnAcalcDelta(h_ft)
% Calculate pressure ratio (delta) given pressure altitude in ft
%
% Inputs:	h_ft: pressure altitude in ft
% Outputs:	pressure ratio (delta)

h_bound = h_ft < 36089;
pressure_ratio = h_bound.*(1 - h_ft/145442).^5.2559 + (1-h_bound).*0.22336.*exp(-((h_ft-36089)./20806));

end