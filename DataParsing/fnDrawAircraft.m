function fnDrawAircraft(hFig, ANF_DATA_Geometry, ANF_DATA_Propulsion, proj_dir)
% This function draws the aircraft contourand places it in hFig

    % formatted geometry data
    formatted_wing_data = fnParseWingData(ANF_DATA_Geometry);
    formatted_hstab_data = fnParseHStabData(ANF_DATA_Geometry);
    formatted_vstab_data = fnParseVStabData(ANF_DATA_Geometry);
    formatted_fuselage_data = fnParseFuselageData(ANF_DATA_Geometry);
    formatted_engine_data = fnParseEngineGeomData(ANF_DATA_Propulsion);

    hold(hFig, 'all');
    
    % draw wing
    if formatted_wing_data.nums>0
        if formatted_wing_data.duplicate
            Xo = zeros(formatted_wing_data.nums,2);
            Yo = zeros(formatted_wing_data.nums,2);
            Zo = zeros(formatted_wing_data.nums,2);
        end
        X = zeros(formatted_wing_data.nums,2);
        Y = zeros(formatted_wing_data.nums,2);
        Z = zeros(formatted_wing_data.nums,2);   
            
        for i=1:formatted_wing_data.nums
            section = formatted_wing_data.(sprintf('s%i',i)).section;
            
            t = section(5);     % twist
            x1 = section(1);
            x2 = x1 + section(4);   % x1 + chord
            y = section(2);
            z1 = section(3);
            rot = [cosd(t) sind(t); -sind(t) cosd(t)]*([x2;z1]-[x1;z1])+[x1;z1];
            x2 = rot(1); z2 = rot(2);
            
            X(i,:) = [x1 x2];
            Y(i,:) = [y y];
            Z(i,:) = [z1 z2];
            if formatted_wing_data.duplicate
                Xo(i,:) = [x1 x2];
                Yo(i,:) = [-y -y];
                Zo(i,:) = [z1 z2];
            end
        end
        
        % apply translation
        X = X + formatted_wing_data.translate(1);
        Y = Y + formatted_wing_data.translate(2);
        Z = Z + formatted_wing_data.translate(3);
        
        surf(hFig, X,Y,Z);
        
        % draw mirror image
        if formatted_wing_data.duplicate
            % apply translation
            Xo = Xo + formatted_wing_data.translate(1);
            Yo = Yo + formatted_wing_data.translate(2);
            Zo = Zo + formatted_wing_data.translate(3);
            
            surf(hFig, Xo,Yo,Zo);
        end
    end
    
    % draw hstab
    if formatted_hstab_data.nums>0
        if formatted_hstab_data.duplicate
            Xo = zeros(formatted_hstab_data.nums,2);
            Yo = zeros(formatted_hstab_data.nums,2);
            Zo = zeros(formatted_hstab_data.nums,2);
        end
        X = zeros(formatted_hstab_data.nums,2);
        Y = zeros(formatted_hstab_data.nums,2);
        Z = zeros(formatted_hstab_data.nums,2);
        
        for i=1:formatted_hstab_data.nums
            section = formatted_hstab_data.(sprintf('s%i',i)).section;
            
            t = section(5);     % twist
            x1 = section(1);
            x2 = x1 + section(4);   % x1 + chord
            y = section(2);
            z1 = section(3);
            rot = [cosd(t) sind(t); -sind(t) cosd(t)]*([x2;z1]-[x1;z1])+[x1;z1];
            x2 = rot(1); z2 = rot(2);
            
            X(i,:) = [x1 x2];
            Y(i,:) = [y y];
            Z(i,:) = [z1 z2];
            if formatted_hstab_data.duplicate
                Xo(i,:) = [x1 x2];
                Yo(i,:) = [-y -y];
                Zo(i,:) = [z1 z2];
            end
        end
        
        % apply translation
        X = X + formatted_hstab_data.translate(1);
        Y = Y + formatted_hstab_data.translate(2);
        Z = Z + formatted_hstab_data.translate(3);
        
        surf(hFig, X,Y,Z);
        
        % draw mirror image
        if formatted_hstab_data.duplicate
            % apply translation
            Xo = Xo + formatted_hstab_data.translate(1);
            Yo = Yo + formatted_hstab_data.translate(2);
            Zo = Zo + formatted_hstab_data.translate(3);
            
            surf(hFig, Xo,Yo,Zo);
        end
    end
    
    % draw vstab
    if formatted_vstab_data.nums>0
        if formatted_vstab_data.duplicate
            Xo = zeros(formatted_vstab_data.nums,2);
            Yo = zeros(formatted_vstab_data.nums,2);
            Zo = zeros(formatted_vstab_data.nums,2);
        end
        X = zeros(formatted_vstab_data.nums,2);
        Y = zeros(formatted_vstab_data.nums,2);
        Z = zeros(formatted_vstab_data.nums,2);
        
        for i=1:formatted_vstab_data.nums
            section = formatted_vstab_data.(sprintf('s%i',i)).section;
            
            t = section(5);     % twist
            x1 = section(1);
            x2 = x1 + section(4);   % x1 + chord
            y = section(2);
            z1 = section(3);
            rot = [cosd(t) sind(t); -sind(t) cosd(t)]*([x2;z1]-[x1;z1])+[x1;z1];
            x2 = rot(1); z2 = rot(2);
            
            X(i,:) = [x1 x2];
            Y(i,:) = [y y];
            Z(i,:) = [z1 z2];
            if formatted_vstab_data.duplicate
                Xo(i,:) = [x1 x2];
                Yo(i,:) = [-y -y];
                Zo(i,:) = [z1 z2];
            end
        end
        
        % apply translation
        X = X + formatted_vstab_data.translate(1);
        Y = Y + formatted_vstab_data.translate(2);
        Z = Z + formatted_vstab_data.translate(3);
        
        surf(hFig, X,Y,Z);
        
        % draw mirror image
        if formatted_vstab_data.duplicate
            % apply translation
            Xo = Xo + formatted_vstab_data.translate(1);
            Yo = Yo + formatted_vstab_data.translate(2);
            Zo = Zo + formatted_vstab_data.translate(3);
            
            surf(hFig, Xo,Yo,Zo);
        end
    end
    
    % draw fuselage
    if isfield(formatted_fuselage_data, 'file')
        raw_data = importdata([proj_dir formatted_fuselage_data.file]);
        
        len = (length(raw_data.data)+1)/2;
        
        num_breaks = 20;
        X_raw = linspace(raw_data.data(1,1), raw_data.data(len,1), num_breaks);
        Y_raw = spline(raw_data.data(1:len,1), raw_data.data(1:len,2), X_raw);
        
        for i=1:num_breaks
            x = X_raw(i); y = Y_raw(i);
            
            % number of points in the circle
            num_pnts = 20;
            X = ones(num_pnts+1,1)*x;
            Y = zeros(num_pnts+1,1); Z = Y;
            dt = 2*pi/num_pnts;
            
            Y(1) = y; Z(1) = 0;
            for j=1:num_pnts
                t = dt*j;
                rot = [cos(t) sin(t); -sin(t) cos(t)]*[0; y];
                
                Y(j+1) = rot(2); Z(j+1) = rot(1);
            end
            
            % apply translation
            X = X + formatted_fuselage_data.translate(1);
            Y = Y + formatted_fuselage_data.translate(2);
            Z = Z + formatted_fuselage_data.translate(3);
            
            plot3(hFig, X, Y, Z, 'Color', 'black');
        end
        
        % draw line through the fuselage
        plot3(hFig, [raw_data.data(1,1)+formatted_fuselage_data.translate(1),...
            raw_data.data(len,1)+formatted_fuselage_data.translate(1)], ...
            ones(1,2)*formatted_fuselage_data.translate(2), ...
            ones(1,2)*formatted_fuselage_data.translate(3), 'LineWidth', 1, ...
            'Color', 'black');
    end
    
    % draw landing gears
    if isfield(ANF_DATA_Geometry,'MLG_height') && isfield(ANF_DATA_Geometry,'MLG_width') ...
            && isfield(ANF_DATA_Geometry,'MLG_X') && isfield(ANF_DATA_Geometry,'NG_X') ...
            && isfield(ANF_DATA_Geometry,'NG_height')
        
        MLG_height = ANF_DATA_Geometry.MLG_height;
        MLG_width = ANF_DATA_Geometry.MLG_width;
        MLG_X = ANF_DATA_Geometry.MLG_X;
        NG_height = ANF_DATA_Geometry.NG_height;
        NG_X = ANF_DATA_Geometry.NG_X;
        
        % draw struts
        plot3(hFig, [NG_X NG_X], [0 0], [0, -NG_height], 'LineWidth', 1.5, ...
            'Color', 'black');
        plot3(hFig, [MLG_X MLG_X], [MLG_width MLG_width], [0, -MLG_height], ...
            'LineWidth', 1.5, 'Color', 'black');
        plot3(hFig, [MLG_X MLG_X], [-MLG_width -MLG_width], [0, -MLG_height], ...
            'LineWidth', 1.5, 'Color', 'black');
        
        % draw wheels
        plot3(hFig, NG_X, 0, -NG_height, 'o', 'MarkerFaceColor', 'black', ...
            'MarkerEdgeColor', 'black', 'MarkerSize', 8);
        plot3(hFig, MLG_X, MLG_width, -MLG_height, 'o', 'MarkerFaceColor', ...
            'black', 'MarkerEdgeColor', 'black', 'MarkerSize', 8);
        plot3(hFig, MLG_X, -MLG_width, -MLG_height, 'o', 'MarkerFaceColor', ...
            'black', 'MarkerEdgeColor', 'black', 'MarkerSize', 8);
    end
    
    % draw engine thrust lines
    try
        MAC = fnCalcMAC(formatted_wing_data);
    catch ME
        MAC = 0;
    end
    if MAC<=0
        MAC = 1;
    end
    
    for i=1:formatted_engine_data.nums
        tline = formatted_engine_data.(sprintf('s%i',i));
        
        plot3(hFig, [tline(1)-MAC tline(1)+MAC], [tline(2) tline(2)], ...
            [tline(3) tline(3)], 'r--');
    end
    
    xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
    axis(hFig, 'equal');
    grid(hFig, 'on');
    hold(hFig, 'off');
end