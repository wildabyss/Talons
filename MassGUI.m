function varargout = MassGUI(varargin)
% MASSGUI MATLAB code for MassGUI.fig
%      MASSGUI, by itself, creates a new MASSGUI or raises the existing
%      singleton*.
%
%      H = MASSGUI returns the handle to a new MASSGUI or the handle to
%      the existing singleton*.
%
%      MASSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASSGUI.M with the given input arguments.
%
%      MASSGUI('Property','Value',...) creates a new MASSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MassGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MassGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MassGUI

% Last Modified by GUIDE v2.5 09-Mar-2014 22:53:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MassGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MassGUI_OutputFcn, ...
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


% --- Executes just before MassGUI is made visible.
function MassGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MassGUI (see VARARGIN)

% Choose default command line output for MassGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MassGUI wait for user response (see UIRESUME)
% uiwait(handles.MassGUI);

update(handles);

% --- Outputs from this function are returned to the command line.
function varargout = MassGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function setEnable(boolIndMass, handles)
if boolIndMass
    set(handles.radInd,'Value',1);
    set(handles.radTotal,'Value',0);
    set(handles.txtTotMass,'Enable','off');
    set(handles.txtXCG,'Enable','off');
    set(handles.txtYCG,'Enable','off');
    set(handles.txtZCG,'Enable','off');
    set(handles.tabMass,'Enable','on');
    set(handles.cmdAddMass,'Enable','on');
    set(handles.cmdRemoveMass,'Enable','on');
else
    set(handles.radInd,'Value',0);
    set(handles.radTotal,'Value',1);
    set(handles.txtTotMass,'Enable','on');
    set(handles.txtXCG,'Enable','on');
    set(handles.txtYCG,'Enable','on');
    set(handles.txtZCG,'Enable','on');
    set(handles.tabMass,'Enable','off');
    set(handles.cmdAddMass,'Enable','off');
    set(handles.cmdRemoveMass,'Enable','off');
end
    
% --- Executes on button press in radTotal.
function radTotal_Callback(hObject, eventdata, handles)
% hObject    handle to radTotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
ANF_DATA.Inertia.type = 2;
update(handles);


% --- Executes on button press in radInd.
function radInd_Callback(hObject, eventdata, handles)
% hObject    handle to radInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
ANF_DATA.Inertia.type = 1;
update(handles);


function txtTotMass_Callback(hObject, eventdata, handles)
% hObject    handle to txtTotMass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTotMass as text
%        str2double(get(hObject,'String')) returns contents of txtTotMass as a double

updateLumpSumMass(handles)


% --- Executes during object creation, after setting all properties.
function txtTotMass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTotMass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtXCG_Callback(hObject, eventdata, handles)
% hObject    handle to txtXCG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtXCG as text
%        str2double(get(hObject,'String')) returns contents of txtXCG as a double

updateLumpSumMass(handles)


% --- Executes during object creation, after setting all properties.
function txtXCG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtXCG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtYCG_Callback(hObject, eventdata, handles)
% hObject    handle to txtYCG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtYCG as text
%        str2double(get(hObject,'String')) returns contents of txtYCG as a double

updateLumpSumMass(handles)


% --- Executes during object creation, after setting all properties.
function txtYCG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtYCG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtZCG_Callback(hObject, eventdata, handles)
% hObject    handle to txtZCG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtZCG as text
%        str2double(get(hObject,'String')) returns contents of txtZCG as a double

updateLumpSumMass(handles)


% --- Executes during object creation, after setting all properties.
function txtZCG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtZCG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cmdAddMass.
function cmdAddMass_Callback(hObject, eventdata, handles)
% hObject    handle to cmdAddMass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
ANF_DATA.Inertia.new_mass = [0 0 0 0];

fields = fieldnames(ANF_DATA.Inertia);
update(handles, length(fields)-2);


% --- Executes on button press in cmdRemoveMass.
function cmdRemoveMass_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRemoveMass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
selRow = get(handles.tabMass, 'UserData');

if ~isempty(selRow) && selRow > 0
    data = get(handles.tabMass, 'Data');
    key = data{selRow,1};

    if ~strcmp(key, 'TOTAL')
        inertia = rmfield(ANF_DATA.Inertia, key);
        ANF_DATA.Inertia = inertia;

        update(handles);
    end
end


% --- Executes on button press in cmdRefresh.
function cmdRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update(handles);


function update(handles, selRow)

global ANF_DATA;

% check for inertia type
if isfield(ANF_DATA, 'Inertia')
    if isfield(ANF_DATA.Inertia, 'type')
        inertia_type = ANF_DATA.Inertia.type;
    else
        inertia_type = 2;
        ANF_DATA.Inertia.type = inertia_type;
    end

else
    inertia_type = 2; ANF_DATA.Inertia.type = inertia_type;
end

% reset figure
cla(handles.figMass, 'reset');
hold(handles.figMass, 'all');

% draw aircraft
if isfield(ANF_DATA, 'Geometry') && isfield(ANF_DATA, 'Propulsion')
    fnDrawAircraft(handles.figMass, ANF_DATA.Geometry, ANF_DATA.Propulsion,...
        ANF_DATA.Directory);
    hold(handles.figMass, 'all');
end

if inertia_type == 2
    % specify lump sum mass
    if isfield(ANF_DATA.Inertia, 'O_TOTAL_MASS')
        total_mass = ANF_DATA.Inertia.O_TOTAL_MASS;
    else
        total_mass = [clDefaults.Inertia_total_mass, clDefaults.Inertia_CGx, ...
            clDefaults.Inertia_CGy, clDefaults.Inertia_CGz];
        ANF_DATA.Inertia.O_TOTAL_MASS = total_mass;
    end
    
    plot3(handles.figMass, total_mass(2), total_mass(3), total_mass(4), 'o', ...
        'MarkerEdgeColor', 'm', 'MarkerFaceColor', 'm');
    
    % update textboxes
    set(handles.txtTotMass, 'String', total_mass(1));
    set(handles.txtXCG, 'String', total_mass(2));
    set(handles.txtYCG, 'String', total_mass(3));
    set(handles.txtZCG, 'String', total_mass(4));
else
    % specify components.
    data = cell(0,5);
    
    total_mass = 0;
    Mx = 0; My = 0; Mz = 0;
    
    fields = fieldnames(ANF_DATA.Inertia);
    counter = 0;
    for i = 1:numel(fields)
        fieldname = fields{i};
        if strcmp(fieldname, 'O_TOTAL_MASS') || strcmp(fieldname, 'type')
            % skip these special fields
            continue;
        else
            % calculate zeroth and first moments
            inertia = ANF_DATA.Inertia.(fieldname);
            total_mass = total_mass + inertia(1);
            Mx = Mx + inertia(1)*inertia(2);
            My = My + inertia(1)*inertia(3);
            Mz = Mz + inertia(1)*inertia(4);
            
            counter = counter + 1;
            data{counter,1} = fieldname;
            data{counter,2} = inertia(1);
            data{counter,3} = inertia(2);
            data{counter,4} = inertia(3);
            data{counter,5} = inertia(4);
            
            % update figure
            if nargin>1 && selRow == counter
                plot3(handles.figMass, inertia(2), inertia(3), inertia(4), ...
                    'gs', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
            else
                plot3(handles.figMass, inertia(2), inertia(3), inertia(4), ...
                    'gs', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
            end
        end
    end

    % calculate total mass/CG
    counter = counter + 1;
    data{counter,1} = 'TOTAL';
    data{counter,2} = total_mass;
    data{counter,3} = Mx/total_mass;
    data{counter,4} = My/total_mass;
    data{counter,5} = Mz/total_mass;
    
    % plot CG
    plot3(handles.figMass, Mx/total_mass, My/total_mass, Mz/total_mass, 'o', ...
        'MarkerEdgeColor', 'm', 'MarkerFaceColor', 'm');
    
    % parse data to the table
    set(handles.tabMass, 'Data', data);
end

% close figure for editing
hold(handles.figMass, 'off');
xlabel(handles.figMass, 'X (m)');
ylabel(handles.figMass, 'Y (m)');
zlabel(handles.figMass, 'Z (m)');
axis(handles.figMass, 'equal');
grid(handles.figMass, 'on');

setEnable(inertia_type==1, handles);


function updateLumpSumMass(handles)

global ANF_DATA;
total_mass = str2double(get(handles.txtTotMass,'String'));
XCG = str2double(get(handles.txtXCG,'String'));
YCG = str2double(get(handles.txtYCG,'String'));
ZCG = str2double(get(handles.txtZCG,'String'));

ANF_DATA.Inertia.O_TOTAL_MASS = [total_mass XCG YCG ZCG];

update(handles);

% --- Executes when entered data in editable cell(s) in tabMass.
function tabMass_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tabMass (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
data = get(hObject, 'Data');
s = size(data);
len = s(1);

% clear existing global data
o_total_mass = ANF_DATA.Inertia.O_TOTAL_MASS;
inertia_type = ANF_DATA.Inertia.type;
ANF_DATA.Inertia = [];
ANF_DATA.Inertia.O_TOTAL_MASS = o_total_mass;
ANF_DATA.Inertia.type = inertia_type;

for i=1:len
    if ~strcmp(data{i,1}, 'TOTAL')
        % 
        ANF_DATA.Inertia.(genvarname(data{i,1})) = [data{i,2} data{i,3} data{i,4} data{i,5}];
    end
end

update(handles, eventdata.Indices(1));


% --- Executes when selected cell(s) is changed in tabMass.
function tabMass_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tabMass (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    set(hObject, 'UserData', eventdata.Indices(1));
    update(handles, eventdata.Indices(1));
else
    set(hObject, 'UserData', 0);
end
