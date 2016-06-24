function ANF_RESULTS = fnRunAVL(proj_dir, mode, CL, elev, ail, rud, ANF_DATA)
% Run AVL analysis and parse the results into ANF_RESULTS
% mode = 0: in-air
% mode = 1: ground effect

    ANF_RESULTS = [];
    % mark results as need update, in case anything inside fails
    ANF_RESULTS.NeedUpdate = 1;

    
    % ----
    % analyze data in proj_dir/proj_file
    
    stab_file = 'avlstability.txt';
    hm_file = 'avlhinge.txt';
    ks_file = 'avlkeystroke.txt';
    int_file = 'avlinterface.avl';
    
    % remove existing files
    delete([proj_dir stab_file]);
    delete([proj_dir hm_file]);
    delete([proj_dir ks_file]);
%     delete([proj_dir int_file]);
    
    % generate keystroke and .avl geometry
    [ail_name elev_name rud_name] = fnAVLInterface([proj_dir int_file], mode, ANF_DATA);
    fnAVLKeystroke([proj_dir ks_file], int_file, stab_file, hm_file, CL,...
        elev, elev_name, ail, ail_name, rud, rud_name);

    curr_dir = pwd;
    copyfile('./Aerodynamics/AVL.exe', [proj_dir 'AVL.exe']);
    cd(proj_dir);
    
    [status,result] = dos('AVL < avlkeystroke.txt');

    delete('AVL.exe');
    cd(curr_dir);
    
    
    % ----
    % parse results into ANF_RESULTS 

    stab_fid = fopen([proj_dir stab_file], 'r');
    hm_fid = fopen([proj_dir hm_file], 'r');

    if stab_fid == -1 || hm_fid == -1
        % cannot open file(s)
        return;
    end
    
    % read stability axis results
    tline = fgets(stab_fid);
    while ischar(tline)
        tline = strtrim(tline);
        if strcmp(tline, '')
            tline = fgets(stab_fid);
            continue;
        end

        C = textscan(tline, '%s%f', 'Delimiter', '=');
        nums = C{2};            % this is supposedly the numeric field
        len = length(nums);

        for i=1:len
            label = strtrim(C{1}{i});
            D = textscan(label, '%s');
            label = D{1}{length(D{1})};

            % determine the data to parse
            switch label
                case 'Xref'
                    ANF_RESULTS.('CGx_ref') = nums(i);
                
                % aerodynamic derivatives
                case 'Alpha'
                    ANF_RESULTS.('Alpha') = nums(i);
                case 'Beta'
                    ANF_RESULTS.('Beta') = nums(i);
                case 'CLtot'
                    ANF_RESULTS.('CL') = nums(i);
                case 'CDtot'
                    ANF_RESULTS.('CD') = nums(i);
                case 'Cmtot'
                    ANF_RESULTS.('Cm') = nums(i);
                case 'e'
                    ANF_RESULTS.('e') = nums(i);

                % stability derivatives
                case 'CLa'
                    ANF_RESULTS.('CLa') = nums(i);
                case 'Cma'
                    ANF_RESULTS.('Cma') = nums(i);
                case 'CYb'
                    ANF_RESULTS.('Cyb') = nums(i);
                case 'Clb'
                    ANF_RESULTS.('Clb') = nums(i);
                case 'Cnb'
                    % The following is a hack since avlstability also has a
                    % line near the end of file:
                    % Clb Cnr / Clr Cnb  =   xxxx 
                    % which confuses the program
                    if ~isfield(ANF_RESULTS, 'Cnb')
                        ANF_RESULTS.('Cnb') = nums(i);
                    end
                case 'Clp'
                    ANF_RESULTS.('Clp') = nums(i);
                case 'CLq'
                    ANF_RESULTS.('CLq') = nums(i);
                case 'Cmq'
                    ANF_RESULTS.('Cmq') = nums(i);
                case 'Cnr'
                    ANF_RESULTS.('Cnr') = nums(i);
                case 'Clr'
                    ANF_RESULTS.('Clr') = nums(i);
                case 'Cnp'
                    ANF_RESULTS.('Cnp') = nums(i);
                case 'CYr'
                    ANF_RESULTS.('Cyr') = nums(i);

                % control derivatives
                case sprintf('Cl%s', ail_name)
                    ANF_RESULTS.('Clda') = nums(i)*180/pi;
                case sprintf('Cn%s', ail_name)
                    ANF_RESULTS.('Cnda') = nums(i)*180/pi;
                case sprintf('CL%s', elev_name)
                    ANF_RESULTS.('CLde') = nums(i)*180/pi;
                case sprintf('Cm%s', elev_name)
                    ANF_RESULTS.('Cmde') = nums(i)*180/pi;
                case sprintf('Cl%s', rud_name)
                    ANF_RESULTS.('Cldr') = nums(i)*180/pi;
                case sprintf('Cn%s', rud_name)
                    ANF_RESULTS.('Cndr') = nums(i)*180/pi;
                case sprintf('CY%s', ail_name)
                    ANF_RESULTS.('Cyda') = nums(i)*180/pi;
                case sprintf('CY%s', rud_name)
                    ANF_RESULTS.('Cydr') = nums(i)*180/pi;

                % neutral point
                case 'Xnp'
                    ANF_RESULTS.('NP') = nums(i);
            end
        end

        % get next line
        tline = fgets(stab_fid);
    end
    
    % read HM results
    tline = fgets(hm_fid);
    while ischar(tline)
        tline = strtrim(tline);
        if strcmp(tline, '')
            tline = fgets(hm_fid);
            continue;
        end

        C = textscan(tline, '%s%f');
        nums = C{2};            % this is supposedly the numeric field
        len = length(nums);

        for i=1:len
            label = strtrim(C{1}{i});

            % determine the data to parse
            switch label
                case 'aileron'
                    ANF_RESULTS.('hm_ail') = nums(i);
                case 'elevator'
                    ANF_RESULTS.('hm_elev') = nums(i);
                case 'rudder'
                    ANF_RESULTS.('hm_rud') = nums(i);
            end
        end
        
        % get next line
        tline = fgets(hm_fid);
    end
        
    % indicate that ANF_RESULTS do not need updating
    ANF_RESULTS.NeedUpdate = 0;
    
    % close result handles
    fclose(stab_fid);
    fclose(hm_fid);
end