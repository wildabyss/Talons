% Get the torsion constants for a rectangular cross section
% Ja is the torsion constant used in shear stress calculation
% tau = T*t/Ja
% Jb is the torsion constant used in twist rate calculation
% dphi/dx = T/G/Jb
% b = height of the rectangle
% t = width of the rectangle

function [Ja Jb] = fnGetRectangleTorsionConstants(h, w)
    

AR = w/h;

a = 1/3/(1+0.6095*AR+0.8865*AR^2-1.8025*AR^3+0.91*AR^4);
b = 1/3 - 0.21*AR*(1-1/12*AR^4);

Ja = a*h*w^3;
Jb = b*h*w^3;

end