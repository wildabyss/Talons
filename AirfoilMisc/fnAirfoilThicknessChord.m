function [ max_thickness ] = fnAirfoilThicknessChord( airfoil_file )
    chord = 1;
    old_height = 0;
    new_height = 0.00001;
    interval = 0.01;
    x = 0;
    while new_height>old_height
        old_height = new_height;
        x = x + interval;
        if x > chord
            error = MException('AcctError:Incomplete','Error in determining maximum thickness of airfoil: %s',airfoil_file);
            throw(error);
        end
        [u l] = fnAirfoilHeight(chord, x, airfoil_file);
        new_height = u - l;
    end
    max_thickness = old_height;
end