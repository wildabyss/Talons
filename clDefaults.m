% A static class containing the parameters used in the Aircraft Analyzer
% All numbers below are in metric units (kg, N, m, s, etc.)
% Convention dictates angles should be in deg

classdef clDefaults
    
    properties (Constant, GetAccess=public)
        
        g = 9.81;
        
        
        %------------------------------
        % Atmospheric Data
        %------------------------------

        Air_runway_alt = 0;
        Air_cruise_height = 50;
        Air_DISA = 0;
        Air_cruise_speed = 18;
        Air_CD0 = 0.17;
        Air_CL_max = 1.73;
        Air_mu = 1.81e-5;
        
        
        %-------------------------------
        % Propulsion
        %-------------------------------
        
        Propulsion_type = 1;
        Propulsion_thrust = '50-0.6*V';
        Propulsion_consumption = '0';
        Propulsion_total_fuel = '1000';
        Propulsion_thrust_line = [0; 0; 0];
        
        
        %-------------------------------
        % Interactions
        %-------------------------------
        
        Interaction_rotation_alpha = 8;    % max linear CL-alpha
        Interaction_flare_alpha = 8;
        Interaction_mu_tire = 0.015;
        Interaction_mu_brake = 0.5;
        Interaction_max_elev = 20;
        Interaction_max_ail = 20;
        Interaction_max_rud = 20;
        Interaction_servo_resolution = 60/128;
        
        
        %-------------------------------
        % Inertia
        %-------------------------------
        
        Inertia_total_mass = 10;
        Inertia_CGx = 0.09;
        Inertia_CGy = 0;
        Inertia_CGz = 0;
        
        
        %-------------------------------
        % Geometry
        %-------------------------------
        
        Geometry_MLG_height = 0.25;
        Geometry_MLG_width = 0.39
        Geometry_MLG_X = 0.19
        Geometry_NG_height = 0.25
        Geometry_NG_X = -0.26
        Geometry_wing_duplicate = 1;
        Geometry_wing_translate = [0; 0; 0];
        Geometry_hstab_duplicate = 1;
        Geometry_hstab_translate = [0; 0; 0];
        Geometry_vstab_duplicate = 0;
        Geometry_vstab_translate = [0; 0; 0];
        Geometry_fuselage_duplicate = 0;
        Geometry_fuselage_translate = [0; 0; 0];
        Geometry_fuselage_file = '';
    end   
end

