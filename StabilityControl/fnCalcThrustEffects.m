% Estimate the effects of propulsive thrusts using maximum thrust available
% Inputs: pure aerodynamic derivatives
% Outputs: derivatives with thrust effects included

function [Cm_t, Cma_t, Cmq_t, Cmde_t, Cnb_t, Cnda_t, Cndr_t] = ...
    fnCalcThrustEffects(Cm, Cma, Cmq, Cmde, Cnb, Cnda, Cndr, CL, CLa, CLq, ...
    CLde, Cyb, Cyda, Cydr, cref, bref, CG, ANF_DATA_Propulsion, Ve, W, h, T)

    % change in neutral point due to thrust effect
    dNP = 0;
    formatted_engine_data = fnParseEngineGeomData(ANF_DATA_Propulsion);
    for i=1:formatted_engine_data.nums
        Th = fnCalcThrustAvailable(ANF_DATA_Propulsion, Ve, h, T);
        
        % calculate dT/dV using central differencing
        dV = 1;
        Th_u = fnCalcThrustAvailable(ANF_DATA_Propulsion, Ve+dV, h, T);
        Th_l = fnCalcThrustAvailable(ANF_DATA_Propulsion, Ve-dV, h, T);
        Th_V = (Th_u-Th_l)/dV/2;
        
        % thrust line moment arm
        tline = formatted_engine_data.(sprintf('s%i',i));
        zp = CG(3) - tline(3);
        
        dNP = dNP - Th*zp/W + 1/2*Th_V*Ve*zp/W;
    end
    
    % pitch
    Cm_t = Cm - CL*dNP/cref;
    Cma_t = Cma - CLa*dNP/cref;
    Cmq_t = Cmq - CLq*dNP/cref;
    Cmde_t = Cmde - CLde*dNP/cref;

    % yaw
    Cnb_t = Cnb - Cyb*dNP/bref;
    Cnda_t = Cnda - Cyda*dNP/bref;
    Cndr_t = Cndr - Cydr*dNP/bref;
end