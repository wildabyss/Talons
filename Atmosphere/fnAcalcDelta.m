function pressure_ratio = fnAcalcDelta(h_ft)

h_bound = h_ft < 36089;
pressure_ratio = h_bound.*(1 - h_ft/145442).^5.2559 + (1-h_bound).*0.22336.*exp(-((h_ft-36089)./20806));

end