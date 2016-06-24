% Calculates the zero-thrust and max-thrust neutral point (dimensionalized)
% Cma = zero-thrust Cma (aerodynamic)
% CGx_ref = ref CG where aerodynamic data are obtained

function NP = fnCalcNeutralPoint(Cma, CLa, MAC, CGx_ref)

    % zero-thrust neutral point
    NP = CGx_ref - Cma/CLa*MAC;
    
end