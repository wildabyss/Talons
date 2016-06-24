%% Calculates aircraft drag
% 1.05 for interference drag

function [Cd0 Cdi] = fnCalcDrag(central_span, outer_span, root_chord, tip_chord, sweep, AoA, twist_tip, v, CGx)

mu = clParameters.mu;
rho = clParameters.rho;
s = fnCalcPlanformArea(central_span, outer_span, root_chord, tip_chord);
b = fnCalcWingSpan(central_span, outer_span);
winglet_bottom_tip_chord = clParameters.winglet_bottom_chord_ratio*tip_chord;
winglet_top_tip_chord = clParameters.winglet_top_chord_ratio*tip_chord;
winglet_top_span = clParameters.winglet_top_span_ratio*tip_chord;
winglet_bottom_span = clParameters.winglet_bottom_span_ratio*tip_chord;


%% Determine the wing skin friction drag

%Multiplied by two to account for two halves of the inner section
%note the parameter central_span has been intentionally divided by two

% prop wash causes full turbulence
propeller_diameter = clParameters.propeller_diameter;
turb_tip = (tip_chord-root_chord)/(b/2)*(propeller_diameter/2)+root_chord;
Cf_wing1 = 2*fnCalcCft(rho,v,root_chord,turb_tip,mu,s,propeller_diameter/2,true)*1.05;
Cf_wing2 = 2*fnCalcCft(rho,v,turb_tip,tip_chord,mu,s,b/2-propeller_diameter/2,false)*1.05;


%% Determine the skin friction drag on the winglets

%Multiplied by two to account for the two winglets
Cf_winglets = 2*1.05*(fnCalcCft(rho,v,tip_chord,winglet_top_tip_chord,mu,s,winglet_top_span,false)+fnCalcCft(rho,v,tip_chord,winglet_bottom_tip_chord,mu,s,winglet_bottom_span,false));		%winglet bottom section drag

%% Determine the total drag on the landing gear

%Over the range of reynolds numbers the plane will be flying as most
%litertature will dicate the drag coefficient is approximately equal to
%1 for a cylindrical body
% 1.7 for bluff bodies

wheelR = clParameters.wheel_radius;
wheelW = clParameters.wheel_width;
nose_gear_support_radius = clParameters.nose_gear_support_radius;
nose_gear_support_height = clParameters.nose_gear_support_height;

% 3 wheels of the landing gear + 1 for DAS
Cd_landinggear = (4*(wheelR*2*wheelW)/s + 4*(nose_gear_support_radius*2*nose_gear_support_height)/s)*1.7;

%% Extract total induced drag from AVL
Cdi = fnGetAVLResults('CDi', central_span, outer_span, root_chord, tip_chord, sweep, AoA, twist_tip, v, CGx, 0, 1);

%% Sum all skin friction drag and form drag cd0 (parasitic drag)

fos = 1.3;  % from Fluent
Cd0 = (Cf_wing1 + Cf_wing2 + Cd_landinggear + Cf_winglets)*fos;

end