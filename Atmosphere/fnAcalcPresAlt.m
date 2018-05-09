function pressure_altitude = fnAcalcPresAlt(delta, unit)
% Calculate the pressure altitude given pressure ratio
% Input: delta: pressure ratio
%        unit: 0 = imperial (ft), 1 = SI (m)
% Output: pressure altitude in ft or m

h_bound = delta > 0.2234;
pressure_altitude = h_bound.*(1-delta.^(1/5.2559))/6.87535e-6 + (1-h_bound).*(36089 - 20806*log(4.477*delta));

if unit==1
    pressure_altitude = pressure_altitude*0.3048;
end

end
