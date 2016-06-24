function VV = fnCalcVTailVolume(CGx, b, S, formatted_vstab_data)
    tail_origin = formatted_vstab_data.s1.section(1);
    sec_mom = 0; Sv = 0;
    for i=1:formatted_vstab_data.nums-1;
        sec_data_a = formatted_vstab_data.(sprintf('s%i',i)).section;
        sec_data_b = formatted_vstab_data.(sprintf('s%i',i+1)).section;
        
        cr = sec_data_a(4);
        ct = sec_data_b(4);
        z1 = sec_data_a(3);
        z2 = sec_data_b(3);
        
        % second moment c^2*dy
        sec_mom = sec_mom + (ct^2+ct*cr+cr^2)*(z2-z1)/3;
        
        % area
        Sv = Sv + (ct+cr)*(z2-z1)/2;
    end
    
    Sv = Sv*2;
    Vtail_MAC = sec_mom*2/Sv;
    
    % moment arm wrt CG
    lv = tail_origin + 0.25*Vtail_MAC - CGx;

    VV = lv*Sv/b/S;

end