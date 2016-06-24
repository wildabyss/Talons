function output = fnParseEngineGeomData(ANF_DATA_Propulsion)
% Parse the engines geometry data into a structure that's more conducive to
% calculations

    fields = fieldnames(ANF_DATA_Propulsion);
    output.nums = 0;	% total number of wing sections
    for i = 1:numel(fields)
        fieldname = fields{i};
        
        C = textscan(fieldname, '%s', 'Delimiter', '_');
        if strcmp(strtrim(C{1}{1}), 'engine')
            if ~isempty(str2num(C{1}{2}))
                % this is a section
                output.nums = output.nums + 1;
                output.(sprintf('s%i',output.nums)) = ANF_DATA_Propulsion.(fieldname);
            end
        end
    end

    % set default value if not present
    if output.nums == 0
        output.nums = 1;
        output.s1 = clDefaults.Propulsion_thrust_line;
    end
end