%% Calculates Reynolds number

function Re = fnCalcRe(rho, v, l, mu)

Re = rho.*v.*l./mu;

end