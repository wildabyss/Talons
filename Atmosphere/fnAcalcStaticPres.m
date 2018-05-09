function P = fnAcalcStaticPres(delta, unit)
% Calculate static pressure (ambient pressure) given delta
%
% Inputs: delta: pressure ratio
%         unit: 0=imperial (psf), 1=SI (N/sq.m)
% Outputs: static pressure in lbf/sq.ft or N/sq.m


P0 = 2116.224;
P = P0*delta;

if unit==1
    P = P*47.88026;
end

end