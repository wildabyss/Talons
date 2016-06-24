function varargout = PropulsionGUI(varargin)
% PROPULSIONGUI MATLAB code for PropulsionGUI.fig
%      PROPULSIONGUI, by itself, creates a new PROPULSIONGUI or raises the existing
%      singleton*.
%
%      H = PROPULSIONGUI returns the handle to a new PROPULSIONGUI or the handle to
%      the existing singleton*.
%
%      PROPULSIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROPULSIONGUI.M with the given input arguments.
%
%      PROPULSIONGUI('Property','Value',...) creates a new PROPULSIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PropulsionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PropulsionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PropulsionGUI

% Last Modified by GUIDE v2.5 13-May-2014 19:28:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PropulsionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PropulsionGUI_OutputFcn, ...
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


% --- Executes just before PropulsionGUI is made visible.
function PropulsionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PropulsionGUI (see VARARGIN)

% Choose default command line output for PropulsionGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PropulsionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
updateGraph(handles);

function updateGraph(handles)
global ANF_DATA;
if isfield(ANF_DATA, 'Propulsion')
    if isfield(ANF_DATA.Propulsion, 'type')
        type = ANF_DATA.Propulsion.type;
    else
        type = clDefaults.Propulsion_type;
        ANF_DATA.Propulsion.type = type;
    end
    if isfield(ANF_DATA.Propulsion, 'thrust')
        thrust = ANF_DATA.Propulsion.thrust;
    else
        thrust = clDefaults.Propulsion_thrust;
        ANF_DATA.Propulsion.thrust = thrust;
    end
    if isfield(ANF_DATA.Propulsion, 'consumption')
        consumption = ANF_DATA.Propulsion.consumption;
    else
        consumption = clDefaults.Propulsion_consumption;
        ANF_DATA.Propulsion.consumption = consumption;
    end
    if isfield(ANF_DATA.Propulsion, 'total_fuel')
        total_fuel = ANF_DATA.Propulsion.total_fuel;
    else
        total_fuel = clDefaults.Propulsion_total_fuel;
        ANF_DATA.Propulsion.total_fuel = total_fuel;
    end
else
    % set up default if values don't exist
    type = clDefaults.Propulsion_type;
    thrust = clDefaults.Propulsion_thrust;
    consumption = clDefaults.Propulsion_consumption;
    total_fuel = clDefaults.Propulsion_total_fuel;
    
    ANF_DATA.Propulsion.type = type;
    ANF_DATA.Propulsion.thrust = thrust;
    ANF_DATA.Propulsion.consumption = consumption;
    ANF_DATA.Propulsion.total_fuel = total_fuel;
end

% change GUI prompts
switch type
    case 1
        set(handles.lblConsumption, 'String', 'SEC = ');
        set(handles.lblExp, 'String',{'SEC = specific energy consumption (W/N-thrust)',...
            'V = airspeed (m/s)', 'h = pressure altitude (m)', 'T = ambient temperature (degC)'});
        set(handles.lblTotalFuel, 'String', {'Total Energy (J)', 'for All Engines:'});
    case 2
        set(handles.lblConsumption, 'String', 'SFC = ');
        set(handles.lblExp, 'String',{'SFC = specific fuel consumption (kg/s/N-thrust)',...
            'V = airspeed (m/s)', 'h = pressure altitude (m)', 'T = ambient temperature (degC)'});
        set(handles.lblTotalFuel, 'String', {'Total Fuel (kg)', 'for All Engines:'});
end

% update GUI
set(handles.txtThrust, 'String', thrust);
set(handles.txtFuel, 'String', consumption);
set(handles.txtTotalFuel, 'String', total_fuel);
set(handles.mnuType, 'value', type);

% update graphs
vecH = [0, 1000, 2000, 3000];
cla(handles.figThrust, 'reset'); cla(handles.figFuel, 'reset');

% update thrust graph
vecV = 5:0.5:85;
vecT = get(handles.mnuTempThrust, 'String');
T = str2double(vecT{get(handles.mnuTempThrust,'value')});
[V h] = meshgrid(vecV, vecH);
Th = fnCalcThrustAvailable(ANF_DATA.Propulsion, V, h, T);
hold(handles.figThrust,'all');

leg = cell(1,length(vecH));
for i=1:length(vecH)
    plot(handles.figThrust, vecV, Th(i,:));
    leg{i} = sprintf('h = %im', vecH(i));
end
legend(handles.figThrust, leg);
hold(handles.figThrust, 'off');

xlabel(handles.figThrust, 'V (m/s)'); 
ylabel(handles.figThrust, 'Thrust (N)');
grid(handles.figThrust, 'on');

% update fuel consumption graph
vecT = get(handles.mnuTempFuel, 'String');
T = str2double(vecT{get(handles.mnuTempFuel,'value')});
SFC = fnSpecificFuelConsumption(ANF_DATA.Propulsion, V, h, T);
hold(handles.figFuel,'all');

leg = cell(1,length(vecH));
for i=1:length(vecH)
    plot(handles.figFuel, vecV, SFC(i,:));
    leg{i} = sprintf('h = %im', vecH(i));
end
legend(handles.figFuel, leg);
hold(handles.figFuel, 'off');

xlabel(handles.figFuel, 'V (m/s)'); 
switch type
    case 1
        ylabel(handles.figFuel, 'SEC (Watt/N-thrust)');
    case 2
        ylabel(handles.figFuel, 'SFC (kg/s/N-thrust)');
end
grid(handles.figFuel, 'on');

% find maximum speed where thrust falls to 0
i = find(max(Th)<=0,1);
if ~isempty(i)
    xlim(handles.figThrust, [5, vecV(i)]);
    xlim(handles.figFuel, [5, vecV(i)]);
end


% --- Outputs from this function are returned to the command line.
function varargout = PropulsionGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function txtThrust_Callback(hObject, eventdata, handles)
% hObject    handle to txtThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtThrust as text
%        str2double(get(hObject,'String')) returns contents of txtThrust as a double

global ANF_DATA;
thrust = strrep(get(hObject, 'String'), ' ','');
ANF_DATA.Propulsion.thrust = thrust;

updateGraph(handles);


% --- Executes during object creation, after setting all properties.
function txtThrust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtFuel_Callback(hObject, eventdata, handles)
% hObject    handle to txtFuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFuel as text
%        str2double(get(hObject,'String')) returns contents of txtFuel as a double

global ANF_DATA;
consumption = strrep(get(hObject, 'String'),' ','');
ANF_DATA.Propulsion.consumption = consumption;

updateGraph(handles);


% --- Executes during object creation, after setting all properties.
function txtFuel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuType.
function mnuType_Callback(hObject, eventdata, handles)
% hObject    handle to mnuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuType

global ANF_DATA;
ANF_DATA.Propulsion.type = get(hObject, 'value');

updateGraph(handles);


% --- Executes during object creation, after setting all properties.
function mnuType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtTotalFuel_Callback(hObject, eventdata, handles)
% hObject    handle to txtTotalFuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTotalFuel as text
%        str2double(get(hObject,'String')) returns contents of txtTotalFuel as a double

global ANF_DATA;
ANF_DATA.Propulsion.total_fuel = str2double(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function txtTotalFuel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTotalFuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuTempFuel.
function mnuTempFuel_Callback(hObject, eventdata, handles)
% hObject    handle to mnuTempFuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuTempFuel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuTempFuel

updateGraph(handles);


% --- Executes during object creation, after setting all properties.
function mnuTempFuel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuTempFuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuTempThrust.
function mnuTempThrust_Callback(hObject, eventdata, handles)
% hObject    handle to mnuTempThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuTempThrust contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuTempThrust

updateGraph(handles);


% --- Executes during object creation, after setting all properties.
function mnuTempThrust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuTempThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
