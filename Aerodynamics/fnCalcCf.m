% This function uses the Blasius solution to determine the skin friction
% drag across a NON-TAPERED surface
% l = length of plate along the flow
% w = width of the plate perpendicular to the flow
% turb = is it fully turbulent?

function Cf = fnCalcCf(rho, v, mu, s, l, w, turb)

%This function accounts for the top and bottom surfaces of of a given
%object and normalizes the coefficient with respect to the given span

Re_t = 5e5;                         % transition Re
xt = mu*Re_t/rho/v;         		% flow separation length
Re_w = fnCalcRe(rho, v, l, mu);
q = 1/2*rho*v^2*l*w;

%Check to see if the flow transitions to turbulent along the plate
if (turb)
    D = 0.074/Re_w^0.2*q*2;
elseif(xt<=l)
    D = (1.328/sqrt(Re_t) + 0.074/Re_w^0.2 - 0.074/Re_t^0.2)*q*2; 
else
    %Otherwise use the laminar solution
    D = 1.328/sqrt(Re_w)*q*2;
end

% renormalize to the given reference area
Cf = D/0.5/rho/v^2/s;

end