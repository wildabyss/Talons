%% Constructs the avlkeystroke.txt file used to capture all AVL commands

function fnAVLKeystroke(ks_fullname, avlfilename, stab_file, hm_file, ...
    CL, elev_angle, elev_name, ail_angle, ail_name, rud_angle, rud_name)

% create keystroke file
fid = fopen(ks_fullname,'w');

fprintf(fid,['LOAD ', avlfilename, '\n']);
fprintf(fid,'OPER\n');
fprintf(fid,'A C %f\n', CL');
if ail_angle ~= 0
    fprintf(fid,'%s\n%s %f\n', ail_name, ail_name, ail_angle*180/pi);
end
if elev_angle ~= 0
    fprintf(fid,'%s\n%s %f\n', elev_name, elev_name, elev_angle*180/pi);
end
if rud_angle ~= 0
    fprintf(fid,'%s\n%s %f\n', rud_name, rud_name, rud_angle*180/pi);
end

% running and outputting
fprintf(fid,'X\n');
fprintf(fid,['HM ' hm_file '\n']);
fprintf(fid,['ST ' stab_file '\n']);
fprintf(fid,'\nQ\n');

fclose(fid);

end