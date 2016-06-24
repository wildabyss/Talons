% Finds the spanwise index of the surface, depending on whether it's a
% horizontal or vertical surface
% Return: 2 = horizontal surface
%         3 = vertical surface
function index = fnSurfaceSpanwiseIndex(formatted_part_data)
    delta_y = abs(formatted_part_data.s1.section(2) - formatted_part_data.s2.section(2));
    delta_z = abs(formatted_part_data.s1.section(3) - formatted_part_data.s2.section(3));
    
    if delta_y>=delta_z
        index = 2;
    else
        index = 3;
    end
end