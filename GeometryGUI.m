function varargout = GeometryGUI(varargin)
% GEOMETRYGUI MATLAB code for GeometryGUI.fig
%      GEOMETRYGUI, by itself, creates a new GEOMETRYGUI or raises the existing
%      singleton*.
%
%      H = GEOMETRYGUI returns the handle to a new GEOMETRYGUI or the handle to
%      the existing singleton*.
%
%      GEOMETRYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEOMETRYGUI.M with the given input arguments.
%
%      GEOMETRYGUI('Property','Value',...) creates a new GEOMETRYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeometryGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeometryGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeometryGUI

% Last Modified by GUIDE v2.5 15-Mar-2014 11:16:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeometryGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GeometryGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GeometryGUI is made visible.
function GeometryGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeometryGUI (see VARARGIN)

% Choose default command line output for GeometryGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeometryGUI wait for user response (see UIRESUME)
% uiwait(handles.GeometryGUI);

update(handles);

% --- Outputs from this function are returned to the command line.
function varargout = GeometryGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function txtMLGHeight_Callback(hObject, eventdata, handles)
% hObject    handle to txtMLGHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMLGHeight as text
%        str2double(get(hObject,'String')) returns contents of txtMLGHeight as a double

updateData(handles)


% --- Executes during object creation, after setting all properties.
function txtMLGHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMLGHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cmdAddSection.
function cmdAddSection_Callback(hObject, eventdata, handles)
% hObject    handle to cmdAddSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;

hSel = get(handles.grpSurfaces, 'SelectedObject');
if eq(hSel, handles.radWing)
    formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
    i = formatted_wing_data.nums + 1;
    ANF_DATA.Geometry.(sprintf('wing_%i',i)) = [0; 0; 0; 0; 0];
elseif eq(hSel, handles.radHStab)
    formatted_hstab_data = fnParseHStabData(ANF_DATA.Geometry);
    i = formatted_hstab_data.nums + 1;
    ANF_DATA.Geometry.(sprintf('hstab_%i',i)) = [0; 0; 0; 0; 0];
elseif eq(hSel, handles.radVStab)
    formatted_vstab_data = fnParseVStabData(ANF_DATA.Geometry);
    i = formatted_vstab_data.nums + 1;
    ANF_DATA.Geometry.(sprintf('vstab_%i',i)) = [0; 0; 0; 0; 0];
elseif eq(hSel, handles.radEngines)
    formatted_engine_data = fnParseEngineGeomData(ANF_DATA.Propulsion);
    i = formatted_engine_data.nums + 1;
    ANF_DATA.Propulsion.(sprintf('engine_%i',i)) = [0; 0; 0];
end

update(handles);

% --- Executes on button press in cmdRemoveSection.
function cmdRemoveSection_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRemoveSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
selRow = get(handles.tabGeometry, 'UserData');
if ~isempty(selRow) && selRow > 0
    hSel = get(handles.grpSurfaces, 'SelectedObject');
    if eq(hSel, handles.radWing)
        component = 'Geometry';
        surface = 'wing';
    elseif eq(hSel, handles.radHStab)
        component = 'Geometry';
        surface = 'hstab';
    elseif eq(hSel, handles.radVStab)
        component = 'Geometry';
        surface = 'vstab';
    elseif eq(hSel, handles.radEngines)
        component = 'Propulsion';
        surface = 'engine';
        
        % we should have at least one engine
        formatted_engine_data = fnParseEngineGeomData(ANF_DATA.(component));
        if formatted_engine_data.nums <= 1
            return;
        end
    else
        return;
    end
    
    % remove field from the global variable
    base_name = sprintf('%s_%i',surface,selRow);
    if isfield(ANF_DATA.(component), base_name)
        ANF_DATA.(component) = rmfield(ANF_DATA.(component), base_name);
    end
    if isfield(ANF_DATA.(component), [base_name '_file'])
        ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_file']);
    end
    if isfield(ANF_DATA.(component), [base_name '_elevator'])
        ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_elevator']);
    end
    if isfield(ANF_DATA.(component), [base_name '_aileron'])
        ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_aileron']);
    end
    if isfield(ANF_DATA.(component), [base_name '_rudder'])
        ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_rudder']);
    end
    
    % rename the ensuing sections, if any exist
    i = selRow+1;
    base_name = sprintf('%s_%i',surface,i);
    while isfield(ANF_DATA.(component), base_name)
        new_base_name = sprintf('%s_%i',surface,i-1);
        
        ANF_DATA.(component).(new_base_name) = ANF_DATA.(component).(base_name);
        ANF_DATA.(component) = rmfield(ANF_DATA.(component), base_name);
        
        if isfield(ANF_DATA.(component), [base_name '_file'])
            ANF_DATA.(component).([new_base_name, '_file']) = ANF_DATA.(component).([base_name, '_file']);
            ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_file']);
        end
        if isfield(ANF_DATA.(component), [base_name '_elevator'])
            ANF_DATA.(component).([new_base_name, '_elevator']) = ANF_DATA.(component).([base_name, '_elevator']);
            ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_elevator']);
        end
        if isfield(ANF_DATA.(component), [base_name '_aileron'])
            ANF_DATA.(component).([new_base_name, '_aileron']) = ANF_DATA.(component).([base_name, '_aileron']);
            ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_aileron']);
        end
        if isfield(ANF_DATA.(component), [base_name '_rudder'])
            ANF_DATA.(component).([new_base_name, '_rudder']) = ANF_DATA.(component).([base_name, '_rudder']);
            ANF_DATA.(component) = rmfield(ANF_DATA.(component), [base_name '_rudder']);
        end
        
        i=i+1;
    end

    update(handles);
end


% --- Executes on button press in cmdRefresh.
function cmdRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update(handles);


% --- Executes on button press in chkDuplicate.
function chkDuplicate_Callback(hObject, eventdata, handles)
% hObject    handle to chkDuplicate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDuplicate

updateData(handles);


function txtTranslate_Callback(hObject, eventdata, handles)
% hObject    handle to txtTranslate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTranslate as text
%        str2double(get(hObject,'String')) returns contents of txtTranslate as a double

updateData(handles);


% --- Executes during object creation, after setting all properties.
function txtTranslate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTranslate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in grpSurfaces.
function grpSurfaces_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in grpSurfaces 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

componentSelection(handles);


% user makes a selection 
function componentSelection(handles)
global ANF_DATA;

% surface table layout (fuselage table layout is different)
std_col_name = {'XLE (m)', 'YLE (m)', 'ZLE (m', 'Chord (m)', ...
    'Incidence (deg)', 'Airfoil', 'Control Surface', 'Control Hinge %Chord'};
std_col_edit = [true true true true true true true true];
std_col_width = {'auto', 'auto', 'auto', 'auto', 'auto', 150, 'auto', 'auto'};

hSel = get(handles.grpSurfaces, 'SelectedObject');
if eq(hSel, handles.radWing)
    formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);

    set(handles.chkDuplicate, 'Value', formatted_wing_data.duplicate);
    set(handles.chkDuplicate, 'Enable', 'Off');
    set(handles.txtTranslate, 'String', sprintf('%1.3f, %1.3f, %1.3f', ...
        formatted_wing_data.translate));
    set(handles.cmdAddSection, 'Enable', 'On');
    set(handles.cmdRemoveSection, 'Enable', 'On');

    % set table layout
    set(handles.tabGeometry, 'ColumnName', std_col_name);
    set(handles.tabGeometry, 'ColumnEditable', std_col_edit);
    set(handles.tabGeometry, 'ColumnWidth', std_col_width);
    col_format = {'numeric', 'numeric', 'numeric', 'numeric', 'numeric', ...
        'char', {'none','aileron','elevator'}, 'numeric'};
    set(handles.tabGeometry, 'ColumnFormat', col_format);

    % set data
    tab_data = cell(formatted_wing_data.nums, 8);
    for i=1:formatted_wing_data.nums
        section = formatted_wing_data.(sprintf('s%i',i));

        tab_data{i,1} = section.section(1);
        tab_data{i,2} = section.section(2);
        tab_data{i,3} = section.section(3);
        tab_data{i,4} = section.section(4);
        tab_data{i,5} = section.section(5);

        % airfoil
        if isfield(section, 'file')
            tab_data{i,6} = section.file;
        end

        % control
        if isfield(section, 'elevator')
            tab_data{i,7} = 'elevator';
            tab_data{i,8} = section.elevator;
        elseif isfield(section, 'aileron')
            tab_data{i,7} = 'aileron';
            tab_data{i,8} = section.aileron;
        else
            tab_data{i,7} = 'none';
            tab_data{i,8} = [];
        end
    end
    set(handles.tabGeometry, 'Data', tab_data);
elseif eq(hSel, handles.radHStab)
    formatted_hstab_data = fnParseHStabData(ANF_DATA.Geometry);

    set(handles.chkDuplicate, 'Value', formatted_hstab_data.duplicate);
    set(handles.chkDuplicate, 'Enable', 'Off');
    set(handles.txtTranslate, 'String', sprintf('%1.3f, %1.3f, %1.3f', ...
        formatted_hstab_data.translate));
    set(handles.cmdAddSection, 'Enable', 'On');
    set(handles.cmdRemoveSection, 'Enable', 'On');

    % set table layout
    set(handles.tabGeometry, 'ColumnName', std_col_name);
    set(handles.tabGeometry, 'ColumnEditable', std_col_edit);
    set(handles.tabGeometry, 'ColumnWidth', std_col_width);
    col_format = {'numeric', 'numeric', 'numeric', 'numeric', 'numeric', ...
        'char', {'none','elevator'}, 'numeric'};
    set(handles.tabGeometry, 'ColumnFormat', col_format);

    % set data
    tab_data = cell(formatted_hstab_data.nums, 8);
    for i=1:formatted_hstab_data.nums
        section = formatted_hstab_data.(sprintf('s%i',i));

        tab_data{i,1} = section.section(1);
        tab_data{i,2} = section.section(2);
        tab_data{i,3} = section.section(3);
        tab_data{i,4} = section.section(4);
        tab_data{i,5} = section.section(5);

        % airfoil
        if isfield(section, 'file')
            tab_data{i,6} = section.file;
        end

        % control
        if isfield(section, 'elevator')
            tab_data{i,7} = 'elevator';
            tab_data{i,8} = section.elevator;
        else
            tab_data{i,7} = 'none';
            tab_data{i,8} = '';
        end
    end
    set(handles.tabGeometry, 'Data', tab_data);
elseif eq(hSel, handles.radVStab)
    formatted_vstab_data = fnParseVStabData(ANF_DATA.Geometry);

    set(handles.chkDuplicate, 'Value', formatted_vstab_data.duplicate);
    set(handles.chkDuplicate, 'Enable', 'On');
    set(handles.txtTranslate, 'String', sprintf('%1.3f, %1.3f, %1.3f', ...
        formatted_vstab_data.translate));
    set(handles.cmdAddSection, 'Enable', 'On');
    set(handles.cmdRemoveSection, 'Enable', 'On');

    % set table layout
    set(handles.tabGeometry, 'ColumnName', std_col_name);
    set(handles.tabGeometry, 'ColumnEditable', std_col_edit);
    set(handles.tabGeometry, 'ColumnWidth', std_col_width);
    col_format = {'numeric', 'numeric', 'numeric', 'numeric', 'numeric', ...
        'char', {'none','rudder'}, 'numeric'};
    set(handles.tabGeometry, 'ColumnFormat', col_format);

    % set data
    tab_data = cell(formatted_vstab_data.nums, 8);
    for i=1:formatted_vstab_data.nums
        section = formatted_vstab_data.(sprintf('s%i',i));

        tab_data{i,1} = section.section(1);
        tab_data{i,2} = section.section(2);
        tab_data{i,3} = section.section(3);
        tab_data{i,4} = section.section(4);
        tab_data{i,5} = section.section(5);

        % airfoil
        if isfield(section, 'file')
            tab_data{i,6} = section.file;
        end

        % control
        if isfield(section, 'rudder')
            tab_data{i,7} = 'rudder';
            tab_data{i,8} = section.rudder;
        else
            tab_data{i,7} = 'none';
            tab_data{i,8} = '';
        end
    end
    set(handles.tabGeometry, 'Data', tab_data);
elseif eq(hSel, handles.radFuselage)
    formatted_fuselage_data = fnParseFuselageData(ANF_DATA.Geometry);

    set(handles.chkDuplicate, 'Value', formatted_fuselage_data.duplicate);
    set(handles.chkDuplicate, 'Enable', 'On');
    set(handles.txtTranslate, 'String', sprintf('%1.3f, %1.3f, %1.3f', ...
        formatted_fuselage_data.translate));
    set(handles.cmdAddSection, 'Enable', 'Off');
    set(handles.cmdRemoveSection, 'Enable', 'Off');

    % set table layout
    set(handles.tabGeometry, 'ColumnName', {'Body File'});
    set(handles.tabGeometry, 'ColumnWidth', {200});
    set(handles.tabGeometry, 'ColumnFormat', {'char'});
    set(handles.tabGeometry, 'ColumnEditable', logical([1]));

    % set data
    if isfield(formatted_fuselage_data, 'file')
        set(handles.tabGeometry, 'Data', {formatted_fuselage_data.file});
    else
        set(handles.tabGeometry, 'Data', {''});
    end
elseif eq(hSel, handles.radEngines)
    formatted_engine_data = fnParseEngineGeomData(ANF_DATA.Propulsion);

    set(handles.chkDuplicate, 'Value', 0);
    set(handles.chkDuplicate, 'Enable', 'Off');
    set(handles.txtTranslate, 'Enable', 'Off');
    set(handles.txtTranslate, 'String', '0.000, 0.000, 0.000');
    set(handles.cmdAddSection, 'Enable', 'On');
    set(handles.cmdRemoveSection, 'Enable', 'On');

    % set table layout
    set(handles.tabGeometry, 'ColumnName', {'#', 'Thrust Line X (m)', ...
        'Thrust Line Y (m)', 'Thrust Line Z (m)'});
    set(handles.tabGeometry, 'ColumnEditable', logical([0 1 1 1]));
    set(handles.tabGeometry, 'ColumnWidth', {20, 120, 120, 120});
    col_format = {'numeric', 'numeric', 'numeric', 'numeric'};
    set(handles.tabGeometry, 'ColumnFormat', col_format);

    % set data
    tab_data = cell(formatted_engine_data.nums, 4);
    for i=1:formatted_engine_data.nums
        section = formatted_engine_data.(sprintf('s%i',i));

        tab_data{i,1} = i;
        tab_data{i,2} = section(1);
        tab_data{i,3} = section(2);
        tab_data{i,4} = section(3);
    end
    set(handles.tabGeometry, 'Data', tab_data);
end


function txtWingArea_Callback(hObject, eventdata, handles)
% hObject    handle to txtWingArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtWingArea as text
%        str2double(get(hObject,'String')) returns contents of txtWingArea as a double


% --- Executes during object creation, after setting all properties.
function txtWingArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtWingArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtWingMAC_Callback(hObject, eventdata, handles)
% hObject    handle to txtWingMAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtWingMAC as text
%        str2double(get(hObject,'String')) returns contents of txtWingMAC as a double


% --- Executes during object creation, after setting all properties.
function txtWingMAC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtWingMAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtWingAR_Callback(hObject, eventdata, handles)
% hObject    handle to txtWingAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtWingAR as text
%        str2double(get(hObject,'String')) returns contents of txtWingAR as a double


% --- Executes during object creation, after setting all properties.
function txtWingAR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtWingAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateData(handles)
% update the global variable ANF_DATA for changes made by user
% event data is supplied by table celledit callback

global ANF_DATA ANF_RESULTS_AIR ANF_RESULTS_GROUND;
ANF_RESULTS_AIR.NeedUpdate = 1;
ANF_RESULTS_GROUND.NeedUpdate = 1;

hSel = get(handles.grpSurfaces, 'SelectedObject');
if eq(hSel, handles.radWing)
    comp = 'wing';
elseif eq(hSel, handles.radHStab)
    comp = 'hstab';
elseif eq(hSel, handles.radVStab)
    comp = 'vstab';
elseif eq(hSel, handles.radFuselage)
    comp = 'fuselage';
elseif eq(hSel, handles.radEngines)
    comp = 'engine';
else
    return;
end

% first, update table data

% delete all entries related to the component
fields = fieldnames(ANF_DATA.Geometry);
for i=1:numel(fields)
    fieldname = fields{i};
    k = findstr(fieldname, comp);
    if ~isempty(k) && k==1
        ANF_DATA.Geometry = rmfield(ANF_DATA.Geometry, fieldname);
    end
end

% reconstruct the raw geometry from table
tabData = get(handles.tabGeometry, 'Data');
if ~eq(hSel, handles.radFuselage) && ~eq(hSel, handles.radEngines)
    % aerodynamic surfaces
    dim = size(tabData); len = dim(1);
    for i=1:len
        ANF_DATA.Geometry.(sprintf('%s_%i',comp,i)) = [tabData{i,1}; tabData{i,2};...
            tabData{i,3}; tabData{i,4}; tabData{i,5}];

        if ~isempty(tabData{i,6})
            afile = strtrim(tabData{i,6});
            if ~isempty(afile)
                if ~isempty(afile) && ~exist(afile, 'file') && ~exist([ANF_DATA.Directory afile], 'file')
                    msgbox('The airfoil file specified does not exist.', 'Warning');
                end
                ANF_DATA.Geometry.(sprintf('%s_%i_file', comp, i)) = afile;
            end
        end
        if ~strcmp(tabData{i,7}, 'none')
            if isnumeric(tabData{i,8})
                ANF_DATA.Geometry.(sprintf('%s_%i_%s', comp, i, tabData{i,7})) = tabData{i,8};
            else
                ANF_DATA.Geometry.(sprintf('%s_%i_%s', comp, i, tabData{i,7})) = str2double(tabData{i,8});
            end
        end
    end
elseif eq(hSel, handles.radEngines)
    % engines
    dim = size(tabData); len = dim(1);
    for i=1:len
        ANF_DATA.Propulsion.(sprintf('engine_%i',i)) = [tabData{i,2}; tabData{i,3};...
            tabData{i,4}];
    end
elseif eq(hSel, handles.radFuselage)
    % fuselage
    fuse_file = tabData{1,1};
    
    if isempty(fuse_file)
        ANF_DATA.Geometry = rmfield(ANF_DATA.Geometry, 'fuselage_file');
    else
        if ~exist(fuse_file, 'file')
            msgbox('The fuselage file specified does not exist.', 'Warning');
        end
        ANF_DATA.Geometry.fuselage_file = fuse_file;
    end
end

% update translation and duplicate
val = textscan(get(handles.txtTranslate, 'String'), '%f', 'Delimiter', ',', 'CollectOutput', 1);
ANF_DATA.Geometry.([comp '_translate']) = val{1}; 
ANF_DATA.Geometry.([comp '_duplicate']) = get(handles.chkDuplicate, 'Value');

% LG geometry
MLG_height = str2double(get(handles.txtMLGHeight,'String'));
ANF_DATA.Geometry.MLG_height = MLG_height;
MLG_width = str2double(get(handles.txtMLGWidth,'String'));
ANF_DATA.Geometry.MLG_width = MLG_width;
MLG_X = str2double(get(handles.txtMLGX,'String'));
ANF_DATA.Geometry.MLG_X = MLG_X;
NG_height = str2double(get(handles.txtNGHeight,'String'));
ANF_DATA.Geometry.NG_height = NG_height;
NG_X = str2double(get(handles.txtNGX,'String'));
ANF_DATA.Geometry.NG_X = NG_X;

% update GUI
update(handles);


function update(handles)
% updates GUI handles

global ANF_DATA;

% initialize
if isfield(ANF_DATA, 'Geometry')
    if ~isfield(ANF_DATA.Geometry, 'MLG_height')
        ANF_DATA.Geometry.MLG_height = clDefaults.Geometry_MLG_height;
    end
    if ~isfield(ANF_DATA.Geometry, 'MLG_width')
        ANF_DATA.Geometry.MLG_width = clDefaults.Geometry_MLG_width;
    end
    if ~isfield(ANF_DATA.Geometry, 'MLG_X')
        ANF_DATA.Geometry.MLG_X = clDefaults.Geometry_MLG_X;
    end
    if ~isfield(ANF_DATA.Geometry, 'NG_height')
        ANF_DATA.Geometry.NG_height = clDefaults.Geometry_NG_height;
    end
    if ~isfield(ANF_DATA.Geometry, 'NG_X')
        ANF_DATA.Geometry.NG_X = clDefaults.Geometry_NG_X;
    end
    if ~isfield(ANF_DATA.Geometry, 'wing_duplicate')
        ANF_DATA.Geometry.wing_duplicate = clDefaults.Geometry_wing_duplicate;
    end
    if ~isfield(ANF_DATA.Geometry, 'wing_translate')
        ANF_DATA.Geometry.wing_translate = clDefaults.Geometry_wing_translate;
    end
    if ~isfield(ANF_DATA.Geometry, 'hstab_duplicate')
        ANF_DATA.Geometry.hstab_duplicate = clDefaults.Geometry_hstab_duplicate;
    end
    if ~isfield(ANF_DATA.Geometry, 'hstab_translate')
        ANF_DATA.Geometry.hstab_translate = clDefaults.Geometry_hstab_translate;
    end
    if ~isfield(ANF_DATA.Geometry, 'vstab_duplicate')
        ANF_DATA.Geometry.vstab_duplicate = clDefaults.Geometry_vstab_duplicate;
    end
    if ~isfield(ANF_DATA.Geometry, 'vstab_translate')
        ANF_DATA.Geometry.vstab_translate = clDefaults.Geometry_vstab_translate;
    end
    if ~isfield(ANF_DATA.Geometry, 'fuselage_duplicate')
        ANF_DATA.Geometry.fuselage_duplicate = clDefaults.Geometry_fuselage_duplicate;
    end
    if ~isfield(ANF_DATA.Geometry, 'fuselage_translate')
        ANF_DATA.Geometry.fuselage_translate = clDefaults.Geometry_fuselage_translate;
    end
else
    ANF_DATA.Geometry.MLG_height = clDefaults.Geometry_MLG_height;
    ANF_DATA.Geometry.MLG_width = clDefaults.Geometry_MLG_width;
    ANF_DATA.Geometry.MLG_X = clDefaults.Geometry_MLG_X;
    ANF_DATA.Geometry.NG_height = clDefaults.Geometry_NG_height;
    ANF_DATA.Geometry.NG_X = clDefaults.Geometry_NG_X;
    ANF_DATA.Geometry.wing_duplicate = clDefaults.Geometry_wing_duplicate;
    ANF_DATA.Geometry.wing_translate = clDefaults.Geometry_wing_translate;
    ANF_DATA.Geometry.hstab_duplicate = clDefaults.Geometry_hstab_duplicate;
    ANF_DATA.Geometry.hstab_translate = clDefaults.Geometry_hstab_translate;
    ANF_DATA.Geometry.vstab_duplicate = clDefaults.Geometry_vstab_duplicate;
    ANF_DATA.Geometry.vstab_translate = clDefaults.Geometry_vstab_translate;
    ANF_DATA.Geometry.fuselage_duplicate = clDefaults.Geometry_fuselage_duplicate;
    ANF_DATA.Geometry.fuselage_translate = clDefaults.Geometry_fuselage_translate;
end
if ~isfield(ANF_DATA, 'Propulsion')
    ANF_DATA.Propulsion.type = clDefaults.Propulsion_type;
end

% update table and graph
componentSelection(handles);
cla(handles.figShow, 'reset');
try
    fnDrawAircraft(handles.figShow, ANF_DATA.Geometry, ANF_DATA.Propulsion,...
        ANF_DATA.Directory);
catch ME
    disp('Geometry draw failed');
end

% landing gear geoemtry
set(handles.txtMLGHeight, 'String', ANF_DATA.Geometry.MLG_height);
set(handles.txtMLGWidth, 'String', ANF_DATA.Geometry.MLG_width);
set(handles.txtMLGX, 'String', ANF_DATA.Geometry.MLG_X);
set(handles.txtNGHeight, 'String', ANF_DATA.Geometry.NG_height);
set(handles.txtNGX, 'String', ANF_DATA.Geometry.NG_X);

% calculate characteristic summary
formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
try
    MAC = fnCalcMAC(formatted_wing_data);
    b = fnCalcWingSpan(formatted_wing_data);
    S = fnCalcPlanformArea(formatted_wing_data);
    AR = fnCalcAspectRatio(b, S);
    
    set(handles.txtWingArea, 'String', sprintf('%1.3f',S));
    set(handles.txtWingMAC, 'String', sprintf('%1.3f',MAC));
    set(handles.txtWingAR, 'String', sprintf('%1.2f',AR));
catch ME
    set(handles.txtWingArea, 'String', 'N/A');
    set(handles.txtWingMAC, 'String', 'N/A');
    set(handles.txtWingAR, 'String', 'N/A');
end


% --- Executes when entered data in editable cell(s) in tabGeometry.
function tabGeometry_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tabGeometry (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

updateData(handles);


% --- Executes when selected cell(s) is changed in tabGeometry.
function tabGeometry_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tabGeometry (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    set(hObject, 'UserData', eventdata.Indices(1));
else
    set(hObject, 'UserData', 0);
end



function txtMLGWidth_Callback(hObject, eventdata, handles)
% hObject    handle to txtMLGWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMLGWidth as text
%        str2double(get(hObject,'String')) returns contents of txtMLGWidth as a double

updateData(handles)


% --- Executes during object creation, after setting all properties.
function txtMLGWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMLGWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMLGX_Callback(hObject, eventdata, handles)
% hObject    handle to txtMLGX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMLGX as text
%        str2double(get(hObject,'String')) returns contents of txtMLGX as a double

updateData(handles)


% --- Executes during object creation, after setting all properties.
function txtMLGX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMLGX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNGHeight_Callback(hObject, eventdata, handles)
% hObject    handle to txtNGHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNGHeight as text
%        str2double(get(hObject,'String')) returns contents of txtNGHeight as a double

updateData(handles)


% --- Executes during object creation, after setting all properties.
function txtNGHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNGHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNGX_Callback(hObject, eventdata, handles)
% hObject    handle to txtNGX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNGX as text
%        str2double(get(hObject,'String')) returns contents of txtNGX as a double

updateData(handles)


% --- Executes during object creation, after setting all properties.
function txtNGX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNGX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
