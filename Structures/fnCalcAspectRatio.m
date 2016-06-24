%% Calculates wing aspect ratio
% b = total wing span
% S = planform area
%%

function AR = fnCalcAspectRatio(b, S)
AR = b^2/S;
end