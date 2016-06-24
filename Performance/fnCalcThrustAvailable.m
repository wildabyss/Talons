%% Calculates thrust available of a single engine
% V = airspeed
% T = ambient temperature
% h = pressure altitude

function Th = fnCalcThrustAvailable(ANF_DATA_Propulsion, V, h, T)

if isfield(ANF_DATA_Propulsion, 'thrust')
    thrust = ANF_DATA_Propulsion.thrust;
else
    thrust = clDefaults.Propulsion_thrust;
end

% if the expression is a single constant, it may be read in as a number
if ~isnumeric(thrust)
    thrust = strrep(thrust, '*','.*');
    thrust = strrep(thrust, '/','./');
    thrust = strrep(thrust, '^','.^');

    Th = eval(thrust);
else
    Th = thrust;
end

% ensure the final size is correct
if length(Th)<length(V) && length(Th)==1
    Th = ones(size(V))*Th;
end