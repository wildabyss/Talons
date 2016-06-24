% Cubic spline the upper and lower curves of the airfoil given coordinate
% file. Returns the matlab piece-wise spline objects.

function [sp_upper sp_lower] = fnSplineAirfoilData(airfoil_file)

    airfoil_data = importdata(airfoil_file, ' ', 1);
    airfoil_data = airfoil_data.data;

    l = length(airfoil_data);
    % split the airfoil into upper and lower surfaces
    for i=1:l-1
        if airfoil_data(i,1)<=airfoil_data(i+1,1)
            ul = i;
            break;
        end
    end

    sp_upper = spline(airfoil_data(1:ul,1),airfoil_data(1:ul,2));
    sp_lower = spline(airfoil_data(ul+1:l,1),airfoil_data(ul+1:l,2));

end