% Rmin = minimum turn radius (m)
% tmin = minimum time to turn 180 deg
% n = load factor (L/W)
% All angles are in radians
% Assuming steady level flight at turn maneuvering

function [Rmin n_max tmin] = fnCalcTurnPerformance(W, S, AR, v, e, rho, g, ...
    alt, temp, CD0, CLmax, ANF_DATA_Propulsion)

    % search for the maximum bank angle (i.e. load factor)
    formatted_engine_data = fnParseEngineGeomData(ANF_DATA_Propulsion);
    Ta = fnCalcThrustAvailable(ANF_DATA_Propulsion, v, alt, temp)*formatted_engine_data.nums;
    lenV = length(v);
    L = zeros(1, lenV);
    for i=1:lenV
    
%         CLe = fnCalcLift(W, S, rho, v(i));      % new cruise CL associated with the airspeed
        CL_trial = 0:0.01:CLmax;
        CD = CD0 + CL_trial.^2/pi/e/AR;
        Tr = fnCalcThrustRequired(CD, v(i), S, rho);
        
        % find first instance where thrust req exceeds thrust available
        ind = find(Tr>=ones(1,length(CL_trial))*Ta(i), 1);
        if isempty(ind)
            CL = CLmax;
        else
            CL = CL_trial(ind(1));
        end
        
        L(i) = 1/2*rho*v(i)^2*S*CL;
    end
    n = L/W;
    n_max = n;
    valid = (n_max > 1);

    wmax = g*sqrt(n.^2-1)./v.*valid;
    tmin = pi./wmax.*valid;
    Rmin = v.^2/g./sqrt(n.^2-1).*valid;
end