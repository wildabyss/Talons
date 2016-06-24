%% Calculates the coefficient of lift (CL)

function CL = fnCalcLift(W, S, rho, v)

CL = W./(1/2*rho*v.^2*S);

end