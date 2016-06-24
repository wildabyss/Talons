function VH = fnCalcTailVolume(CGx, MAC, S, formatted_hstab_data)
    tail_origin = formatted_hstab_data.s1.section(1);
    sec_mom = 0; St = 0;
    for i=1:formatted_hstab_data.nums-1;
        sec_data_a = formatted_hstab_data.(sprintf('s%i',i)).section;
        sec_data_b = formatted_hstab_data.(sprintf('s%i',i+1)).section;
        
        cr = sec_data_a(4);
        ct = sec_data_b(4);
        y1 = sec_data_a(2);
        y2 = sec_data_b(2);
        
        % second moment c^2*dy
        sec_mom = sec_mom + (ct^2+ct*cr+cr^2)*(y2-y1)/3;
        
        % area
        St = St + (ct+cr)*(y2-y1)/2;
    end
    
    St = St*2;
    Htail_MAC = sec_mom*2/St;
    

% moment arm wrt CG
lt = tail_origin + 0.25*Htail_MAC - CGx;

VH = lt*St/MAC/S;

end