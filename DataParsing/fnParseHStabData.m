function output = fnParseHStabData(ANF_DATA_Geometry)
% Parse the hstab geometry data into a structure that's more conducive to
% calculations

    fields = fieldnames(ANF_DATA_Geometry);
    output.nums = 0;	% total number of wing sections
    for i = 1:numel(fields)
        fieldname = fields{i};
        
        C = textscan(fieldname, '%s', 'Delimiter', '_');
        if strcmp(strtrim(C{1}{1}), 'hstab')
            if strcmp(strtrim(C{1}{2}), 'duplicate')
                output.duplicate = ANF_DATA_Geometry.(fieldname);
            elseif strcmp(strtrim(C{1}{2}), 'translate')
                output.translate = ANF_DATA_Geometry.(fieldname);
            elseif ~isempty(str2num(C{1}{2}))
                % this is a section
                if length(C{1})==3
                    % this is a control surf definition or coordinate file
                    output.(['s' C{1}{2}]).(C{1}{3}) = ANF_DATA_Geometry.(fieldname);
                else
                    % this is a section definition
                    output.(['s' C{1}{2}]).section = ANF_DATA_Geometry.(fieldname);
                    output.nums = output.nums + 1;
                end
            end
        end
    end

end