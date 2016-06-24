% Calculates the range (m) and endurance (min) of flight at constant
% airspeed
% Ve = cruise speed
% Wi = initial weight (N)
% h = pressure cruise altitude
% T = ambient temperature
% e = span efficiency factor (aerodynamic)
% AR = wing aspect ratio

function [R tE] = fnCalcEndurance(Ve, Wi, h, T, rho, g, CD0, e, AR, S, ...
    ANF_DATA_Propulsion)

    % ensure existence of fields
    if isfield(ANF_DATA_Propulsion, 'total_fuel')
        total_fuel = ANF_DATA_Propulsion.total_fuel;
    else
        total_fuel = clDefaults.Propulsion_total_fuel;
    end
    if isfield(ANF_DATA_Propulsion, 'type')
        type = ANF_DATA_Propulsion.type;
    else
        type = clDefaults.Propulsion_type;
    end
    
    % central assumption: constant airspeed is maintained
    formatted_engine_data = fnParseEngineGeomData(ANF_DATA_Propulsion);
    Ta = fnCalcThrustAvailable(ANF_DATA_Propulsion, Ve, h, T)*formatted_engine_data.nums;
    
    if type == 1
        % battery powered
        
        % assume constant thrust
        CLe = Wi/(1/2*rho*Ve^2*S);
        CD = fnCalcDrag(CLe, CD0, e, AR);
        Tr = fnCalcThrustRequired(CD, Ve, S, rho);
        
        % check that thrust required is not more than thrust available
        if Tr>Ta
            error('Tr>Ta');
        end
        
        % fuel consumption rate
        sfc = fnSpecificFuelConsumption(ANF_DATA_Propulsion, Ve, h, T);
        fc = sfc*Tr;
        
        t_total = total_fuel/fc;
        R = Ve*t_total;
    else
        % fuel based
        
        R = 0;
        t_total = 0;
        
        % discretization
        N = 100;
        dW = total_fuel*g/N;
        W = Wi;
        
        for i=1:N
            % take the central stencil
            W = W - dW/2;
            
            CLe = W/(1/2*rho*Ve^2*S);
            CD = fnCalcDrag(CLe, CD0, e, AR);
            Tr = fnCalcThrustRequired(CD, Ve, S, rho);
            
            % check that thrust required is not more than thrust available
            if Tr>Ta
                error('Tr>Ta');
            end
            
            % fuel consumption rate
            sfc = fnSpecificFuelConsumption(ANF_DATA_Propulsion, Ve, h, T);
            fc = sfc*Tr;
            
            R = R + Ve/fc/g*dW;
            t_total = t_total + dW/fc/g;
            W = W - dW/2;
        end
    end
    
    tE = t_total/60;        % convert to min
end