%% Calculates mean aerodynamic chord of a surface
%%

function MAC = fnCalcMAC(formatted_part_data)

    S = fnCalcPlanformArea(formatted_part_data);
    
    sec_mom = 0;
    spanInd = fnSurfaceSpanwiseIndex(formatted_part_data);
    for i=1:formatted_part_data.nums-1;
        sec_data_a = formatted_part_data.(sprintf('s%i',i)).section;
        sec_data_b = formatted_part_data.(sprintf('s%i',i+1)).section;
        
        cr = sec_data_a(4);
        ct = sec_data_b(4);
        y1 = sec_data_a(spanInd);
        y2 = sec_data_b(spanInd);
        
        sec_mom = sec_mom + (ct^2+ct*cr+cr^2)*(y2-y1)/3;
    end
    MAC = sec_mom/S;
    
    if spanInd==2 && isfield(formatted_part_data, 'duplicate') && formatted_part_data.duplicate==1
        MAC = MAC*2;
    end

end