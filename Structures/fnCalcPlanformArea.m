%% Calculates the geometric planform area of a surface
%%

function S = fnCalcPlanformArea(formatted_part_data)

    S = 0;
    spanInd = fnSurfaceSpanwiseIndex(formatted_part_data);
    for i=1:formatted_part_data.nums-1;
        sec_data_a = formatted_part_data.(sprintf('s%i',i)).section;
        sec_data_b = formatted_part_data.(sprintf('s%i',i+1)).section;
        
        S = S + (sec_data_a(4)+sec_data_b(4))*(sec_data_b(spanInd)-sec_data_a(spanInd))/2;
    end
    
    if spanInd==2 && isfield(formatted_part_data, 'duplicate') && formatted_part_data.duplicate==1
        S = S*2;
    end
end