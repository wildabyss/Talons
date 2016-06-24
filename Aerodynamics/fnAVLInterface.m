%% Constructs the AVL geometry fid
% All coordinates used in AVL geometry are in MKS and degrees
% mode = 0: in-air
% mode = 1: ground effect

function [ail_name, elev_name, rud_name] = fnAVLInterface(filename, mode, ANF_DATA)

ail_name = '';
elev_name = '';
rud_name = '';

% parse formatted geometry data
formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
formatted_hstab_data = fnParseHStabData(ANF_DATA.Geometry);
formatted_vstab_data = fnParseVStabData(ANF_DATA.Geometry);
formatted_fuselage_data = fnParseFuselageData(ANF_DATA.Geometry);

% Write .avl file
fid = fopen(filename, 'w');
fprintf(fid,'Aircraft for Analysis\n');
fprintf(fid,'#Mach\n');
fprintf(fid,'0\n');
fprintf(fid,'#IYsym  IZsym  Zsym\n');

% ground plane
if mode==1
    [~, LG_height] = fnJigTheta(ANF_DATA.Geometry);
    fprintf(fid,'0 1 -%f\n', LG_height);
else
    fprintf(fid,'0 0 0\n');
end

% reference coordinates about which moments are defined, (should be the CG)
[~, CGx, CGy, CGz] = fnCalcCG(ANF_DATA);

% reference parameters
Bref = fnCalcWingSpan(formatted_wing_data);
Sref = fnCalcPlanformArea(formatted_wing_data);
Cref = fnCalcMAC(formatted_wing_data);

fprintf(fid,'#Sref  Cref  Bref\n');
fprintf(fid,'%5.3f  %5.3f  %5.3f\n', Sref, Cref, Bref);
fprintf(fid,'#Xref  Yref  Zref\n');
fprintf(fid,'%5.3f  %5.3f  %5.3f\n', CGx, CGy, CGz);

% define wing
if formatted_wing_data.nums>0
    fprintf(fid,'\n#====================================================================\n');
    fprintf(fid,'SURFACE\n');
    fprintf(fid,'Wing\n');
    fprintf(fid,'#Nchordwise  Cspace  Nspan  Sspace ]\n');
    fprintf(fid,'12  1.0  26  -1.1\n');
    if formatted_wing_data.duplicate==1
        fprintf(fid,'YDUPLICATE\n');
        fprintf(fid,'0.0\n');
    end
    fprintf(fid,'TRANSLATE\n');
    fprintf(fid,'%5.3f  %5.3f  %5.3f\n', formatted_wing_data.translate(1), ...
        formatted_wing_data.translate(2), formatted_wing_data.translate(3));

    % write sections
    for i=1:formatted_wing_data.nums
        section = formatted_wing_data.(sprintf('s%i',i));
        section_geo = section.section;

        fprintf(fid,'\n#-------------------------------------------------------------------\n');
        fprintf(fid,'SECTION \n');
        fprintf(fid,'# Xle  Yle  Zle  Chord  Ainc\n');
        fprintf(fid,'%5.3f  %5.3f  %5.3f  %5.3f  %5.1f\n', ...
            section_geo(1), section_geo(2), section_geo(3), section_geo(4), section_geo(5));
        fprintf(fid,'#\n');
        if isfield(section, 'file')
            fprintf(fid,'AFILE \n');
            fprintf(fid,'%s \n', section.file);
        end

        if isfield(section, 'aileron')
            fprintf(fid,'CONTROL\n');
            fprintf(fid,'#Cname  Cgain  Xhinge  HingeVec  SgnDup\n');
            fprintf(fid,'aileron  1  %5.3f  0 0 0  -1\n', section.aileron);
            fprintf(fid,'#\n');
            
            ail_name = 'd1';
        end
        if isfield(section, 'elevator')
            fprintf(fid,'CONTROL\n');
            fprintf(fid,'#Cname  Cgain  Xhinge  HingeVec  SgnDup\n');
            fprintf(fid,'elevator  1  %5.3f  0 0 0  1\n', section.elevator);
            
            if isfield(section, 'aileron')
                elev_name = 'd2';
            else
                elev_name = 'd1';
            end
        end

        fprintf(fid,'#\n');
    end
end

% define horizontal tail
if formatted_hstab_data.nums>0
    fprintf(fid,'\n#====================================================================\n');
    fprintf(fid,'SURFACE\n');
    fprintf(fid,'Horizontal Stabilizer\n');
    fprintf(fid,'#Nchordwise  Cspace    [ Nspan    Sspace ]\n');
    fprintf(fid,'6  1.0  15  -1.1\n');
    if formatted_hstab_data.duplicate==1
        fprintf(fid,'YDUPLICATE\n');
        fprintf(fid,'0.0\n');
    end
    fprintf(fid,'TRANSLATE\n');
    fprintf(fid,'%5.3f  %5.3f  %5.3f\n', formatted_hstab_data.translate(1), ...
        formatted_hstab_data.translate(2), formatted_hstab_data.translate(3));

    for i=1:formatted_hstab_data.nums
        section = formatted_hstab_data.(sprintf('s%i',i));
        section_geo = section.section;
        
        fprintf(fid,'\n#-------------------------------------------------------------------\n');
        fprintf(fid,'SECTION \n');
        fprintf(fid,'# Xle  Yle  Zle  Chord  Ainc\n');
        fprintf(fid,'%5.3f  %5.3f  %5.3f  %5.3f  %5.1f\n', ...
            section_geo(1), section_geo(2), section_geo(3), section_geo(4), section_geo(5));
        fprintf(fid,'#\n');
        if isfield(section, 'file')
            fprintf(fid,'AFILE \n');
            fprintf(fid,'%s \n', section.file);
        end

        if isfield(section, 'elevator')
            fprintf(fid,'CONTROL\n');
            fprintf(fid,'#Cname  Cgain  Xhinge  HingeVec  SgnDup\n');
            fprintf(fid,'elevator  1  %5.3f  0 0 0  1\n', section.elevator);
            
            if isempty(ail_name)
                elev_name = 'd1';
            else
                elev_name = 'd2';
            end
        end
    end
end

% define vertical tail
if formatted_vstab_data.nums>0
    fprintf(fid,'\n#====================================================================\n');
    fprintf(fid,'SURFACE\n');
    fprintf(fid,'Vertical Stabilizer\n');
    fprintf(fid,'#Nchordwise  Cspace    [ Nspan    Sspace ]\n');
    fprintf(fid,'7  1.0  11  1.0\n');
    if formatted_vstab_data.duplicate==1
        fprintf(fid,'YDUPLICATE\n');
        fprintf(fid,'0.0\n');
    end
    fprintf(fid,'TRANSLATE\n');
    fprintf(fid,'%5.3f  %5.3f  %5.3f\n', formatted_vstab_data.translate(1), ...
        formatted_vstab_data.translate(2), formatted_vstab_data.translate(3));

    for i=1:formatted_vstab_data.nums
        section = formatted_vstab_data.(sprintf('s%i',i));
        section_geo = section.section;
        
        fprintf(fid,'\n#-------------------------------------------------------------------\n');
        fprintf(fid,'SECTION \n');
        fprintf(fid,'# Xle  Yle  Zle  Chord  Ainc\n');
        fprintf(fid,'%5.3f  %5.3f  %5.3f  %5.3f  %5.1f\n', ...
            section_geo(1), section_geo(2), section_geo(3), section_geo(4), section_geo(5));
        fprintf(fid,'#\n');
        if isfield(section, 'file')
            fprintf(fid,'AFILE \n');
            fprintf(fid,'%s \n', section.file);
        end

        if isfield(section, 'rudder')
            fprintf(fid,'CONTROL\n');
            fprintf(fid,'#Cname  Cgain  Xhinge  HingeVec  SgnDup\n');
            fprintf(fid,'rudder  1  %5.3f  0 0 -1  -1\n', section.rudder);
            
            if isempty(ail_name) && isempty(elev_name)
                rud_name = 'd1';
            elseif isempty(ail_name) && ~isempty(elev_name) || ~isempty(ail_name) && isempty(elev_name)
                rud_name = 'd2';
            else
                rud_name = 'd3';
            end
        end
    end
end

% define fuselage
if isfield(formatted_fuselage_data, 'file')
    fprintf(fid,'\n#====================================================================\n');
    fprintf(fid,'BODY\n');
    fprintf(fid,'Fuselage\n');
    fprintf(fid,'#Nchordwise  Cspace\n');
    fprintf(fid,'15  1.0\n');
    fprintf(fid,'#\n');
    if formatted_fuselage_data.duplicate==1
        fprintf(fid,'YDUPLICATE\n');
        fprintf(fid,'0.0\n');
    end
    fprintf(fid,'TRANSLATE\n');
    fprintf(fid,'%5.3f  %5.3f  %5.3f\n', formatted_fuselage_data.translate(1),...
        formatted_fuselage_data.translate(2), formatted_fuselage_data.translate(3));
    fprintf(fid,'BFIL\n');
    fprintf(fid,'%s\n', formatted_fuselage_data.file);
    fprintf(fid,'#\n');
end

fclose(fid);

end