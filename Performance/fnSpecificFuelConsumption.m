%% Calculates fuel consumption rate of the engine
% V = airspeed
% T = temperature
% h = pressure altitude

function SFC = fnSpecificFuelConsumption(ANF_DATA_Propulsion, V, h, T)

if isfield(ANF_DATA_Propulsion, 'consumption')
    consumption = ANF_DATA_Propulsion.consumption;
else
    consumption = clDefaults.Propulsion_consumption;
end

% if the expression is a single constant, it may be read in as a number
if ~isnumeric(consumption)
    consumption = strrep(consumption, '*','.*');
    consumption = strrep(consumption, '/','./');
    consumption = strrep(consumption, '^','.^');

    SFC = eval(consumption);
else
    SFC = consumption;
end

% ensure the final size is correct
if length(SFC)<length(V) && length(SFC)==1
    SFC = ones(size(V))*SFC;
end