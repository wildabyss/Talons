%% Calculates the necessary ground roll distance after touchdown
% W = total weight (inc payload)

function Sg = fnCalcLandingDistance(W, S, CLg, CLag, CLmax, CDg, AoAg, ...
    jig_theta, flare_alpha, mu_tire, rho, g)

    % at rolling, Cl ~ 0, so no induced drag
    CL = (jig_theta-AoAg)*CLag + CLg;
    
    % calculate flare CL
    CLflare = (flare_alpha-AoAg)*CLag + CLg;
    CLflare = min(CLflare, CLmax);

    % calculate total stopping distance
    Vlo = sqrt(W/0.5/rho/S/CLflare);         % airspeed at touchdown
    Sg = quad(@(Vsq)fnLandingRoll(Vsq, W, S, g, rho, mu_tire, CDg, CL), Vlo^2, 0);

end

function ds = fnLandingRoll(Vsq, W, S, g, rho, mu, CDg, CL)
    ds = 1/2/g./(-rho*Vsq*S*CDg/2/W-mu*(1-rho*Vsq*S*CL/2/W));
end