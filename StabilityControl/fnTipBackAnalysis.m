function static_tipback_angle = fnTipBackAnalysis(x_wheel, z_wheel, xcg, zcg)
% Static tipback angle of the aircraft = pitch angle at which the CG
% coincides with the back wheel

    static_tipback_angle = atan((xcg-x_wheel)/(z_wheel-zcg));

end

