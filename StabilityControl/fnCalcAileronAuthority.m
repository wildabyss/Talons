% The maximum achievable steady roll rate given max aileron input.

function [p_max] = fnCalcAileronAuthority(Clp, Clda, da_max, b, v)

% higher fidelity
% A = [Clb Clp; Cnb Cnp];
% B = -[Clda; Cnda]*da_max;
% 
% x = A\B;
% p_max = x(2)*2*v/b;     % normalize to rad/sec

% simplified
p_max = -Clda/Clp*da_max*2*v/b;

end

