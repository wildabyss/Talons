function output = fnParseFuselageData(ANF_DATA_Geometry)
% Parse the hstab geometry data into a structure that's more conducive to
% calculations
    
    fields = fieldnames(ANF_DATA_Geometry);
    for i = 1:numel(fields)
        fieldname = fields{i};
        
        C = textscan(fieldname, '%s', 'Delimiter', '_');
        if strcmp(strtrim(C{1}{1}), 'fuselage')
            if strcmp(strtrim(C{1}{2}), 'duplicate')
                output.duplicate = ANF_DATA_Geometry.(fieldname);
            elseif strcmp(strtrim(C{1}{2}), 'translate')
                output.translate = ANF_DATA_Geometry.(fieldname);
            elseif strcmp(strtrim(C{1}{2}), 'file')
                output.file = ANF_DATA_Geometry.(fieldname);
            end
        end
    end

end