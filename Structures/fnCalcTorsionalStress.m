%% Calculates the shear stress on a uniform circular cylinder under torsion
% Inputs:
% T = torque
% r = radius
% J = polar moment
% output:
% torsional(shear) stress

function [torsion_stress] = fnCalcTorsionalStress(T,r,J)

torsion_stress = T*r/J;

end