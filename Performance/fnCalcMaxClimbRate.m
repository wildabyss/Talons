%% Calculates the maximum rate of climb
%%

function RC = fnCalcMaxClimbRate(W, V, alt, temp, CD, S, rho, ANF_DATA_Propulsion)

% multiply by the number of engines
formatted_engine_data = fnParseEngineGeomData(ANF_DATA_Propulsion);

% thrust required
Tr = fnCalcThrustRequired(CD, V, S, rho);

% thrust available
Ta = fnCalcThrustAvailable(ANF_DATA_Propulsion, V, alt, temp)*formatted_engine_data.nums;

RC = (Ta.*V-Tr.*V)/W;

end