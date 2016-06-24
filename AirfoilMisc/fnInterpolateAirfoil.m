% Author:: Jonathan Ng       Last Edited: Oct 28th, 2011

% This function takes in airfoils at two different sections, and
% interpolates the resulted airfoil at a given point in-between.
% The input airfoil data points are assumed to be in the order of TE->Upper
% Surface->LE->Lower Surface->TE
% data_interval is recommended to be less than 0.00001 for reasonably good
% interpolation results.

function new_airfoil_data = fnInterpolateAirfoil(root_airfoil_file,tip_airfoil_file,y_root,y_tip,y_new,data_interval)
    [sp_root_upper sp_root_lower] = fnSplineAirfoilData(root_airfoil_file);
    [sp_tip_upper sp_tip_lower] = fnSplineAirfoilData(tip_airfoil_file);
    
    x = flipud(transpose(0:data_interval:1));
    np = length(x);
    
    z_root_upper = ppval(sp_root_upper, x);
    z_root_lower = ppval(sp_root_lower, x);
    z_tip_upper = ppval(sp_tip_upper, x);
    z_tip_lower = ppval(sp_tip_lower, x);
    % force the TE and LE to be equal
    z_root_upper(1) = z_root_lower(1);
    z_root_upper(np) = z_root_lower(np);
    z_tip_upper(1) = z_tip_lower(1);
    z_tip_upper(np) = z_tip_lower(np);

    close all;
    figure(1)
    plot([x;flipud(x)],[z_root_upper;flipud(z_root_lower)]); axis equal;
    figure(2)
    plot([x;flipud(x)],[z_tip_upper;flipud(z_tip_lower)]); 
    axis equal;

    z_new_upper = zeros(np,1);
    z_new_lower = zeros(np,1);
    delta_y = y_tip - y_root;
    for i=1:np
        %upper surface
        z_new_upper(i) = ((z_tip_upper(i)-z_root_upper(i))/(delta_y))*y_new + z_root_upper(i);
        %bottom surface
        z_new_lower(i) = ((z_tip_lower(i)-z_root_lower(i))/(delta_y))*y_new + z_root_lower(i);
    end
    % force the LE and TE to be equal
    z_new_upper(1) = z_new_lower(1);
    z_new_upper(np) = z_new_lower(np);
    new_airfoil_data(:,1) = [x(1:np);flipud(x)];
    new_airfoil_data(:,2) = [z_new_upper(1:np);flipud(z_new_lower)];
    
    figure;
    plot(new_airfoil_data(:,1),new_airfoil_data(:,2));
    axis equal;
end
