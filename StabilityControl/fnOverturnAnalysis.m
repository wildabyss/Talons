function rc = fnOverturnAnalysis(MLG_width, MLG_height, ycg, zcg, m, g, L, Vt)
% Calculates turning radius at which the aircraft will overturn on the
% ground for a given tangential speed
% L = aircraft lift

    arm = MLG_width/2 - abs(ycg);

    % centrifugal force
    Fc = (m*g*arm-L*arm)/(MLG_height+zcg);
    rc = m*Vt.^2./Fc;

end

