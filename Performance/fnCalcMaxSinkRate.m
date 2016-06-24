function RD = fnCalcMaxSinkRate(W, V, CD, S, rho)
% Maximum rate of descent

% thrust required
Tr = fnCalcThrustRequired(CD, V, S, rho);

RD = Tr.*V/W;

end

