%% Calculates the max planar shear and bending stress for a Bernoulli beam
% Inputs:
% q = force distribution along the span (x)
% I = second moment function along the span (x)
% Q = first moment function along the span (x)
% y = beam height function along the span (x)
% t = beam thickness function along the span (x)
% b = total span
% V = optional shear force feed in. If provided, will override q
%
% Assumes the cantilever is constrained at x=0
%
% Outputs:
% max shear stress and max bending stress

function [max_shear, max_bending] = fnCalcCantileverStress(q, I, Q, y, t, b, V)

% Perform numerical integration
N = 20;
int_size = b/(N-1); % interval size

x = (0:int_size:b);

M = zeros(N,1); % Bending Moment
I_array = zeros(N,1);
Q_array = zeros(N,1);
h = zeros(N,1);
t_array = zeros(N,1);
q_dist = zeros(N,1);
V_array = zeros(N,1);
for i=1:N
    I_array(i) = I(x(i));
    Q_array(i) = Q(x(i));
    h(i) = y(x(i));
    t_array(i) = t(x(i));
    if nargin<7
        q_dist(i) = q(x(i));
    end
end

% shear force
if nargin<7
    for i = N-1:-1:1
        V_array(i) = trapz(q_dist(i:N))*int_size;
    end
else
    for i=1:N
        V_array(i) = V(x(i));
    end
end

% moment
for i = N-1:-1:1;
    M(i) = trapz(V_array(i:N))*int_size;
end

% bending stress
bending_stress = M.*h./I_array; % Euler
[max_bending, ~] = max(bending_stress);

% shear stress
shear_stress = V_array.*Q_array./(I_array.*t_array); % Jourawski
[max_shear, ~] = max(shear_stress);

end