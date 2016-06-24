% All vectors and matrices below must have the same number of rows and/or
% columns
%
% Czt, Ctt = flexibility coefficient matrices
% E = a vector of distance from AC to EA for each section
% C = a vector of section chords for each section
% A0 = a vector of section lift coefficient for each section
% DY = a vector of spanwise discretization

function Vdiv = fnGetDivergenceSpeed(Czt, Ctt, vecE, vecC, vecA0, SWEEP, DY)

DELTA = diag(DY);
E = diag(vecE);
C = diag(vecC);
A0 = diag(vecA0.*cos(SWEEP));

rho = clParameters.rho;
A = transpose(Czt)*DELTA*C*A0 + Ctt*DELTA*E*C*A0;

% find the smallest q_div
q = sort(1./eig(A));
len = length(q);
qmin = q(1);
for i=2:len
    if isreal(qmin) && qmin<q(i)
        break;
    else
        qmin = q(i);
    end
end

Vdiv = sqrt(2*qmin/rho);

end