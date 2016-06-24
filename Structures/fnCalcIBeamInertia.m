%% Calculates first and second moment for an I-Beam
% Inputs:
% b = flange width (x)
% h = height (x)
% t = flange thickness (x)
% t_web = web thickness (x)
%
% outputs:
% Q_centre = First moment of Inertia (x) about centre of the I-beam
% Q_glue = First moment of Inertia (x) about the glue area (connection
% between the flange and the web)
% I = Second Moment of Inertia (x)
%
% Note: x = distance from root chord

function [I, Q_centre, Q_glue] = fnCalcIBeamInertia(b, h, t, t_web)

% bh^3/12 of square - bh^3/12 of hollow 
I = @(x) (b(x)*h(x)^3-(b(x)-t_web(x))*(h(x)-2*t(x))^3)/12; 

% first moment about the centre of the I-Beam
Q_centre = @(x) (h(x)+t(x)/2)*b(x)*t(x) + t_web(x)*(h(x)/2-t(x))*(h(x)/2-t(x))/2;

% first moment about the glueing area
Q_glue = @(x) (h(x)+t(x)/2)*b(x)*t(x);

end