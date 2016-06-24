%% Function that returns the ESDU data for hinge moment calculations
% Author: Wen Cheng Chong
% ESDU_data series:
% 1) W 01.01.05 for a1_0
% 2) C 01.01.03 for a2_0
% 3) C 04.01.01 for b1_0
% 4) C 04.01.02 for b2_0
% 5) 89009 for G1, G2, G3
%
% Inputs:
% for plain control, F_B = 1, otherwise, need Figures 2(a) and 2(b) from
% ESDU 89009
% swp_hng (deg), sweep at hinge-line in degrees
% beta = sqrt(1-Mach^2)
% A, aspect ratio
% swp25 (deg), sweep at quarter chord in degrees
% tau, trailing edge angle in degrees
% toc, t/c (thickness to chord ratio)
% R, reynolds number
% cfoc, control chord aft of hinge line over airfoil chord (now handles
% 0.2<= cfoc <=0.4), if cfoc out of the bound, G1 is assumed to vary
% linearly with G1 at boundaries
% xtoc, boundary layer transition location
% etai, distance of control surfrace from root over half span (for use in
% aileron, elevator and rudder has etai = 0)
% swp50 (deg), sweep at half chord in degrees (if etai=0, swp50 does not
% matter)

% Output: G1 for use in calculating b1, G2, G3 (corrections to part-span)
%        a1_0,a2_0,b1_0,b2_0

function [a1_0,a2_0,b1_0,b2_0,G1,G2,G3] = fnAirfoilESDU(F_B,swp_hng,beta,A,swp25,tau,toc,R,cfoc,xtoc,etai,swp50)

R = max(1e6, R);    % ESDU gives incorrect results for low Re

%% estimating a1_0 from W01.01.05
% Equation (2.1) and (2.2) in W 01.01.05
a1_OT = 2*pi + (4.75+0.02*tau)*toc;
num = 0.1+(1.05-0.5*xtoc)*tand(tau/2);
den = (log10(R)-5)^(1-2.5*tand(tau/2));
a1_0_over_a1_OT = 1-num/den;
a1_0 = a1_0_over_a1_OT*a1_OT;

%% standard aerofoil section
% disp('from equation');
% tau_prime = 2*atand(toc);
% a1_OT_std = 2*pi + (4.75+0.02*tau_prime)*toc;
% num = 0.1+(1.05-0.5*xtoc)*tand(tau_prime/2);
% den = (log10(R)-5)^(1-2.5*tand(tau_prime/2));
% a1_0_over_a1_OT_std = 1-num/den;
% a1_0_std = a1_0_over_a1_OT_std*a1_OT_std;

%% estimating a2_0 from C 01.01.03

var1 = [0.70 0.72 0.74 0.76 0.78 0.80 0.82 0.84 0.86 0.88 0.90 0.92 0.94 0.96 0.98 1.00]; %a1_0/a1_OT
var2 = [0.05 0.10 0.20 0.30 0.50]; % cf/c
data = [0.36 0.40 0.43 0.49 0.53 0.58 0.62 0.66 0.70 0.74 0.785 0.825 0.87 0.91 0.945 1.00;
        0.385 0.43 0.48 0.52 0.57 0.62 0.655 0.697 0.74 0.77 0.81 0.85 0.89 0.92 0.96 1.00;
        0.43 0.48 0.525 0.57 0.615 0.655 0.697 0.73 0.77 0.80 0.842 0.87 0.90 0.935 0.965 1.00;
        0.48 0.52 0.56 0.60 0.645 0.69 0.72 0.755 0.79 0.82 0.85 0.88 0.91 0.94 0.97 1.00;
        0.55 0.585 0.62 0.66 0.70 0.73 0.762 0.793 0.82 0.85 0.875 0.90 0.93 0.95 0.975 1.00];
    
% a2_0_over_a2_OT = interp2(var1,var2,data,a1_0_over_a1_OT,cfoc,'spline');
a2_0_over_a2_OT = griddata(var1,var2,data,a1_0_over_a1_OT,cfoc,'v4');
% a2_0_over_a2_OT_std = interp2(var1,var2,data,a1_0_over_a1_OT_std,cfoc,'spline');

var1 = [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50]; %cfoc
var2 = [0 0.02 0.04 0.06 0.08 0.10 0.12 0.15]; %toc
data = [1.775 2.49 3.0 3.45 3.85 4.15 4.45 4.70 4.94 5.15;
        1.775 2.50 3.05 3.49 3.87 4.23 4.51 4.775 5.025 5.25;
        1.775 2.51 3.06 3.53 3.93 4.28 4.55 4.87 5.13 5.35;
        1.775 2.52 3.10 3.56 3.98 4.33 4.60 4.95 5.21 5.45;
        1.775 2.54 3.11 3.60 4.03 4.40 4.67 5.04 5.31 5.56;
        1.775 2.55 3.15 3.65 4.07 4.45 4.72 5.10 5.40 5.66
        1.775 2.56 3.16 3.68 4.13 4.52 4.79 5.20 5.50 5.77;
        1.775 2.57 3.20 3.75 4.20 4.60 4.97 5.30 5.65 5.94]; %a2_OT
    
a2_OT = griddata(var1,var2,data,cfoc,toc,'v4');
% a2_OT_std = a2_OT; % a2_OT is only a function of toc and cfoc

a2_0 = a2_0_over_a2_OT*a2_OT;
% a2_0_std = a2_0_over_a2_OT_std*a2_OT_std;

%% estimating b1_0 from C 04.01.01

var1 = [0.70 0.75 0.80 0.85 0.90 0.95 1.00]; %(a1)_0/(a1)_OT
var2 = [0.10 0.15 0.20 0.25 0.30 0.35 0.40]; %cfoc
data = [-0.09 0.14 0.36 0.54 0.70 0.86 1.00;
        -0.06 0.18 0.382 0.56 0.72 0.863 1.00;
        -0.03 0.218 0.42 0.588 0.74 0.878 1.00;
        0.02 0.25 0.45 0.615 0.76 0.88 1.00;
        0.06 0.28 0.48 0.64 0.778 0.89 1.00;
        0.10 0.32 0.517 0.662 0.79 0.90 1.00;
        0.14 0.36 0.54 0.69 0.805 0.907 1.00]; %(b1)_0/(b1)_OT
    
b1_0_over_b1_OT_std = griddata(var1,var2,data,a1_0_over_a1_OT,cfoc,'v4');
    
var1 = [0.10 0.15 0.20 0.25 0.30 0.35 0.40]; %cfoc
var2 = [0 0.02 0.04 0.06 0.08 0.10 0.12 0.15]; %toc
data = [0.345 0.43 0.50 0.57 0.63 0.69 0.75;
        0.33 0.412 0.488 0.552 0.617 0.678 0.74;
        0.313 0.40 0.47 0.54 0.60 0.668 0.728;
        0.30 0.38 0.45 0.52 0.588 0.65 0.715;
        0.283 0.362 0.438 0.503 0.57 0.638 0.702;
        0.268 0.345 0.418 0.488 0.552 0.62 0.69;
        0.25 0.33 0.40 0.47 0.54 0.607 0.677;
        0.228 0.30 0.37 0.44 0.51 0.58 0.65]; %-(b1)_OT
    
b1_OT_std = -griddata(var1,var2,data,cfoc,toc,'v4');

b1_0_std = b1_0_over_b1_OT_std*b1_OT_std;
b1_0 = b1_0_std + 2*(a1_OT - a1_0)*(tand(tau/2) - toc);

%% estimaing b2_0 from C 04.01.02

var1 = [0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]; %a2_0/a2_OT
var2 = [0.10 0.15 0.20 0.25 0.30 0.35 0.40]; %cfoc
data = [0.65 0.702 0.753 0.80 0.843 0.885 0.925 0.962 1.00;
        0.625 0.69 0.747 0.792 0.84 0.88 0.923 0.963 1.00;
        0.598 0.67 0.735 0.788 0.835 0.879 0.92 0.96 1.00;
        0.568 0.65 0.72 0.78 0.83 0.877 0.918 0.96 1.00;
        0.52 0.625 0.705 0.77 0.823 0.87 0.916 0.96 1.00;
        0.47 0.59 0.687 0.755 0.815 0.865 0.912 0.958 1.00;
        0.418 0.548 0.66 0.74 0.803 0.86 0.91 0.953 1.00]; %b2_0/b2_OT
    
b2_0_over_b2_OT_std = griddata(var1,var2,data,a2_0_over_a2_OT,cfoc,'v4');


var1 = [0.10 0.15 0.20 0.25 0.30 0.35 0.40]; %cfoc
var2 = [0 0.02 0.04 0.06 0.08 0.10 0.12 0.15]; %toc
data = [0.885 0.903 0.923 0.945 0.965 0.99 1.012;
        0.858 0.88 0.905 0.93 0.954 0.98 1.005;
        0.83 0.857 0.885 0.913 0.94 0.97 0.997;
        0.80 0.833 0.864 0.895 0.927 0.956 0.987;
        0.77 0.805 0.84 0.875 0.91 0.942 0.975;
        0.735 0.775 0.813 0.85 0.887 0.924 0.96;
        0.70 0.74 0.783 0.823 0.865 0.904 0.945;
        0.637 0.685 0.737 0.78 0.825 0.873 0.915]; %-b2_OT

b2_OT_std = -griddata(var1,var2,data,cfoc,toc,'v4');

b2_0_std = b2_0_over_b2_OT_std*b2_OT_std;
b2_0 = b2_0_std + 2*(a2_OT - a2_0)*(tand(tau/2)-toc);

%% estimating G1, Cfoc = 0.2

var1 = [2 3 4 5 6 8 10];%betaA
var2 = [0 0.5 1.0]; % (1/beta)*tan(sweep25)
data = [0.1 0.08 0.065 0.05 0.04 0.025 0.02;
        0.075 0.045 0.02 -0.005 -0.02 -0.03 -0.04;
        0.025 -0.01 -0.04 -0.06 -0.075 -0.09 -0.1]; % 2pibeta G1 / (Fb a10 cos(swp_hng)) (rad^-1)
    
input1 = beta*A; %betaA
input2 = (1/beta)*tand(swp25); %(1/beta)*tan(sweep25)

output = griddata(var1,var2,data,input1,input2,'v4');
G1_0 = output*F_B*a1_0*cosd(swp_hng)/(2*pi*beta);

%% estimating G1, Cfoc = 0.3

var1 = [2 3 4 5 6 8 10];%betaA
var2 = [0 0.5 1.0]; % (1/beta)*tan(sweep25)
data = [0.121 0.100 0.078 0.06 0.048 0.032 0.026;
        0.09 0.06 0.03 0.01 -0.01 -0.03 -0.035;
        0.027 -0.004 -0.032 -0.054 -0.07 -0.09 -0.1]; % 2pibeta G1 / (Fb a10 cos(swp_hng)) (rad^-1)
    
input1 = beta*A; %betaA
input2 = (1/beta)*tand(swp25); %(1/beta)*tan(sweep25)

output = griddata(var1,var2,data,input1,input2,'v4');
G1_1 = output*F_B*a1_0*cosd(swp_hng)/(2*pi*beta);

%% estimating G1, Cfoc = 0.4

var1 = [2 3 4 5 6 8 10];%betaA
var2 = [0 0.5 1.0]; % (1/beta)*tan(sweep25)
data = [0.14 0.11 0.085 0.068 0.05 0.035 0.03;
        0.085 0.06 0.03 0.01 -0.005 -0.02 -0.025;
        0.03 -0.01 -0.03 -0.05 -0.07 -0.087 -0.09]; % 2pibeta G1 / (Fb a10 cos(swp_hng)) (rad^-1).
    
input1 = beta*A; %betaA
input2 = (1/beta)*tand(swp25); %(1/beta)*tan(sweep25)

output = griddata(var1,var2,data,input1,input2,'v4');
G1_2 = output*F_B*a1_0*cosd(swp_hng)/(2*pi*beta);

if cfoc < 0.2
    G1 = cfoc/0.2*G1_0; % assume linear for cfoc < 0.2
elseif cfoc >= 0.2 && cfoc <= 0.3
    G1 = (G1_1 - G1_0)/(0.3-0.2)*(cfoc - 0.2) + G1_0; %linear between 0.2 <= cfoc <= 0.3
elseif cfoc >= 0.3 && cfoc <= 0.4
    G1 = (G1_2 - G1_1)/(0.4-0.3)*(cfoc - 0.3) + G1_1; %linear between 0.3 <= cfoc <= 0.4
else
    G1 = cfoc/0.4*G1_2; % assume linear for cfoc > 0.4
end

%% estimating G2 (assumed eta_o >= 0.9)
var1 = [0 0.2 0.4 0.6 0.8 1.0]; %etai
var2 = [0 2 4 6]; %A tan(swp50)

data = [0 0 0 0 0 0;
        0 0.022 0.050 0.061 0.064 0.0645;
        0 0.042 0.099 0.120 0.125 0.127;
        0 0.052 0.117 0.145 0.153 0.155];% 2*pi*beta*G2/(F_B*a1_0*cos(swp_hng))
    
input1 = etai;
input2 = A*tand(swp50);
output = griddata(var1,var2,data,input1,input2,'v4');

G2 = output*F_B*a1_0*cosd(swp_hng)/(2*pi*beta);

%% estimating G3 
output = 0.15*etai; %2*pi*beta*G3/(F_B*a1_0*cos(swp_hng))
G3 = output*F_B*a1_0*cosd(swp_hng)/(2*pi*beta);

end