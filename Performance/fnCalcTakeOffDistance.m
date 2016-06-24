%% Calculates the necessary ground roll distance before take off
% W = total weight (inc payload)

function Sg = fnCalcTakeOffDistance(W, S, CLg, CLag, CLmax, CDg, AoAg, jig_theta, ...
    rotation_alpha, mu_tire, rho, g, alt, temp, ANF_DATA_Propulsion)

    % at rolling, CL ~ 0, so no induced drag
    CL = (jig_theta-AoAg)*CLag + CLg;
    
    % calculate rotation CL
    CLrot = (rotation_alpha-AoAg)*CLag + CLg;
    CLrot = min(CLrot, CLmax);

    % calculate total ground roll distance
    Vlo = sqrt(W/0.5/rho/S/CLrot);         % unstick speed
    Sg = quad(@(Vsq)fnGroundRoll(Vsq, W, S, ANF_DATA_Propulsion, g, rho, ...
        mu_tire, alt, temp, CDg, CL), 0, Vlo^2);

end

function ds = fnGroundRoll(Vsq, W, S, ANF_DATA_Propulsion, g, rho, mu, alt, ...
    temp, CDg, CL)

    formatted_engine_data = fnParseEngineGeomData(ANF_DATA_Propulsion);
    T = fnCalcThrustAvailable(ANF_DATA_Propulsion, sqrt(Vsq), alt, temp)*formatted_engine_data.nums;
    ds = 1/2/g./(T/W-rho*Vsq*S*CDg/2/W-mu*(1-rho*Vsq*S*CL/2/W));

end