function [u l] = fnAirfoilHeight(chord, x, airfoil_file)
	[u_spline l_spline] = fnSplineAirfoilData(airfoil_file);
	u = ppval(u_spline,x)*chord;
	l = ppval(l_spline,x)*chord;
end%fnAirfoilHeight