function fnRotateAirfoil(filename, destination, twist)
    %import ze data
    airfoil = importdata(filename, ' ', 1);
    n = size(airfoil.data);

    translation = ones(n(1),2)/4;
    translation(:,2) = zeros(n(1),1);

    airfoilTranslate = airfoil.data - translation;
    rotation = [cos(twist)  -sin(twist) ; sin(twist)  cos(twist)];

    % do the rotation
    airfoilRotation = zeros(n(1),2);
    for index = 1:n(1);
        airfoilRotation(index,1) = rotation(1)*airfoilTranslate(index,1) + rotation(2)*airfoilTranslate(index,2);
        airfoilRotation(index,2) = rotation(3)*airfoilTranslate(index,1) + rotation(4)*airfoilTranslate(index,2);
    end

    airfoilFinal = airfoilRotation + translation;

    % file header
    destFile = fopen(destination, 'w');
    fprintf(destFile, 'Rotated airfoil by %f deg\n', twist/pi*180);
    fclose(destFile);

    % save data points
    dlmwrite(destination, airfoilFinal, '-append', 'delimiter', ' ', 'precision', '%10.7f');

end