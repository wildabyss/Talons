function temp_ratio = fnAcalcTheta(delta, DISA)
% Calculate temperature ratio (theta) given pressure ratio (delta) and 
% delta ISA temperature in C
%
% Inputs:	delta: pressure ratio
%			DISA: delta ISA temperature in C
% Outputs:	temperature ratio (theta)

h_ft = fnAcalcPresAlt(delta, 0);
h_bound = h_ft < 36089;
temp_ratio = h_bound.*(1 - 6.87535e-6*h_ft + DISA/288.15) + (1-h_bound).*(0.7519 + DISA/288.15);

end