function [ CGx ] = fnAirfoilCGx( airfoil_file )
    chord = 1;
    interval = 0.00001;
    x = interval:interval:chord;
    [u_spline l_spline] = fnSplineAirfoilData(airfoil_file);
	u = ppval(u_spline,x)*chord;
	l = ppval(l_spline,x)*chord;
    %CGx = sum(vertical strip area_i * x_i)/Total Area
    airfoil_area = abs(trapz(x,u)) + abs(trapz(x,l));
    cg_sum = sum(interval*((x-(interval/2)).*(u-l)));
    CGx = cg_sum/airfoil_area;
end

