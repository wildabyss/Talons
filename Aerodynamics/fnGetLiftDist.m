% This function generates the lift distribution from AVL and returns it in
% the form of a spanwise shear force function. Unit is in N.

function V = fnGetLiftDist(central_span, outer_span, root_chord, tip_chord, sweep, AoA, twist_tip, v, CGx)

y = fnGetAVLResults('y', central_span, outer_span, root_chord, tip_chord, sweep, AoA, twist_tip, v, CGx, 0, 1);
clstrip = fnGetAVLResults('clstrip', central_span, outer_span, root_chord, tip_chord, sweep, AoA, twist_tip, v, CGx, 0, 1);
striparea = fnGetAVLResults('striparea', central_span, outer_span, root_chord, tip_chord, sweep, AoA, twist_tip, v, CGx, 0, 1);
    
% normalize cl to point forces (dirac delta force distribution)
rho = clParameters.rho;
df = 1/2*rho*v^2*striparea.*clstrip;

% normalize to force function
L = length(y);
V=@(x)0;
for i=1:L
    V = @(x) (V(x) + heaviside(x)*df(i) - heaviside(x-y(i))*df(i));
end

end