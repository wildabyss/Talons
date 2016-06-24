function [jig_theta avg_height] = fnJigTheta(ANF_DATA_Geometry)
% Jig refers to the aircraft on the ground
% This function calculates the sitting angle of the aircraft in rad

    MLG_height = ANF_DATA_Geometry.MLG_height;
    MLG_X = ANF_DATA_Geometry.MLG_X;
    NG_height = ANF_DATA_Geometry.NG_height;
    NG_X = ANF_DATA_Geometry.NG_X;
    
    jig_theta = atan((NG_height-MLG_height)/(MLG_X-NG_X));
    avg_height = (MLG_height+NG_height)/2;
end

