%% Calculates the total span of a surface
%%

function b = fnCalcWingSpan(formatted_part_data)
    
    % horizontal surface, spanInd = 2
    % vertical surface, spanInd = 3
    spanInd = fnSurfaceSpanwiseIndex(formatted_part_data);

    sec_data_beg = formatted_part_data.s1.section;
    sec_data_end = formatted_part_data.(sprintf('s%i',formatted_part_data.nums)).section;
    b = abs(sec_data_beg(spanInd)-sec_data_end(spanInd));

    if spanInd==2 && isfield(formatted_part_data, 'duplicate') && formatted_part_data.duplicate==1
        b = b*2;
    end

end