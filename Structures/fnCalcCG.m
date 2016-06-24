%% Calculates the CG of the aircraft at design payload

function [total_weight CGx CGy CGz] = fnCalcCG(ANF_DATA)

g = clDefaults.g;

% check for inertia type
if isfield(ANF_DATA, 'Inertia') && isfield(ANF_DATA.Inertia, 'type')
	inertia_type = ANF_DATA.Inertia.type;
else
    inertia_type = 2;
    ANF_DATA.Inertia.type = inertia_type;
end

if inertia_type == 2
    % specify lump sum mass
    if isfield(ANF_DATA.Inertia, 'O_TOTAL_MASS')
        total_mass = ANF_DATA.Inertia.O_TOTAL_MASS;
    else
        total_mass = [clDefaults.Inertia_total_mass, clDefaults.Inertia_CGx, ...
            clDefaults.Inertia_CGy, clDefaults.Inertia_CGz];
        ANF_DATA.Inertia.O_TOTAL_MASS = total_mass;
    end
    
    total_weight = total_mass(1)*g;
    CGx = total_mass(2);
    CGy = total_mass(3);
    CGz = total_mass(4);
else
    % specify components
    
    total_weight = 0;
    Mx = 0; My = 0; Mz = 0;
    
    fields = fieldnames(ANF_DATA.Inertia);
    for i = 1:numel(fields)
        fieldname = fields{i};
        if strcmp(fieldname, 'O_TOTAL_MASS') || strcmp(fieldname, 'type')
            % skip these special fields
            continue;
        else
            inertia = ANF_DATA.Inertia.(fieldname);
            total_weight = total_weight + inertia(1)*g;
            Mx = Mx + inertia(1)*g*inertia(2);
            My = My + inertia(1)*g*inertia(3);
            Mz = Mz + inertia(1)*g*inertia(4);
        end
    end
    
    CGx = Mx/total_weight;
    CGy = My/total_weight;
    CGz = Mz/total_weight;
end

end