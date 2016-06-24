function varargout = AirGUI(varargin)
% AIRGUI MATLAB code for AirGUI.fig
%      AIRGUI, by itself, creates a new AIRGUI or raises the existing
%      singleton*.
%
%      H = AIRGUI returns the handle to a new AIRGUI or the handle to
%      the existing singleton*.
%
%      AIRGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AIRGUI.M with the given input arguments.
%
%      AIRGUI('Property','Value',...) creates a new AIRGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AirGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AirGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AirGUI

% Last Modified by GUIDE v2.5 04-Apr-2014 22:14:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AirGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AirGUI_OutputFcn, ...
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


% --- Executes just before AirGUI is made visible.
function AirGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AirGUI (see VARARGIN)

% Choose default command line output for AirGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AirGUI wait for user response (see UIRESUME)
% uiwait(handles.AirGUI);

update(handles);


% --- Outputs from this function are returned to the command line.
function varargout = AirGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtRunway_Callback(hObject, eventdata, handles)
% hObject    handle to txtRunway (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRunway as text
%        str2double(get(hObject,'String')) returns contents of txtRunway as a double

global ANF_DATA;
ANF_DATA.Air.runway_height = str2double(get(hObject, 'String'));
updateCL(handles);


% --- Executes during object creation, after setting all properties.
function txtRunway_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRunway (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtCruiseHeight_Callback(hObject, eventdata, handles)
% hObject    handle to txtCruiseHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCruiseHeight as text
%        str2double(get(hObject,'String')) returns contents of txtCruiseHeight as a double

global ANF_DATA;
ANF_DATA.Air.cruise_height = str2double(get(hObject, 'String'));
updateCL(handles);


% --- Executes during object creation, after setting all properties.
function txtCruiseHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCruiseHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtDISA_Callback(hObject, eventdata, handles)
% hObject    handle to txtDISA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDISA as text
%        str2double(get(hObject,'String')) returns contents of txtDISA as a double

global ANF_DATA;
ANF_DATA.Air.DISA = str2double(get(hObject, 'String'));
updateCL(handles);


% --- Executes during object creation, after setting all properties.
function txtDISA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDISA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function update(handles)

global ANF_DATA;
if isfield(ANF_DATA, 'Air')
    if isfield(ANF_DATA.Air, 'runway_alt')
        runway_alt = ANF_DATA.Air.runway_alt;
    else
        runway_alt = clDefaults.Air_runway_alt;
        ANF_DATA.Air.runway_alt = runway_alt;
    end
    if isfield(ANF_DATA.Air, 'cruise_height')
        cruise_height = ANF_DATA.Air.cruise_height;
    else
        cruise_height = clDefaults.Air_cruise_height;
        ANF_DATA.Air.cruise_height = cruise_height;
    end
    if isfield(ANF_DATA.Air, 'DISA')
        disa = ANF_DATA.Air.DISA;
    else
        disa = clDefaults.Air_DISA;
        ANF_DATA.Air.DISA = disa;
    end
    if isfield(ANF_DATA.Air, 'cruise_speed')
        airspeed = ANF_DATA.Air.cruise_speed;
    else
        airspeed = clDefaults.Air_cruise_speed;
        ANF_DATA.Air.cruise_speed = airspeed;
    end
    if isfield(ANF_DATA.Air, 'CD0')
        CD0 = ANF_DATA.Air.CD0;
    else
        CD0 = clDefaults.Air_CD0;
        ANF_DATA.Air.CD0 = CD0;
    end
    if isfield(ANF_DATA.Air, 'CL_max')
        CLmax = ANF_DATA.Air.CL_max;
    else
        CLmax = clDefaults.Air_CL_max;
        ANF_DATA.Air.CL_max = CLmax;
    end
    if isfield(ANF_DATA.Air, 'mu')
        mu = ANF_DATA.Air.mu;
    else
        mu = clDefaults.Air_mu;
        ANF_DATA.Air.mu = mu;
    end
else
    runway_alt = clDefaults.Air_runway_alt; ANF_DATA.Air.runway_alt = runway_alt;
    cruise_height = clDefaults.Air_cruise_height; ANF_DATA.Air.cruise_height = cruise_height;
    disa = clDefaults.Air_DISA; ANF_DATA.Air.DISA = disa;
    airspeed = clDefaults.Air_cruise_speed; ANF_DATA.Air.cruise_speed = airspeed;
    CD0 = clDefaults.Air_CD0; ANF_DATA.Air.CD0 = CD0;
    CLmax = clDefaults.Air_CL_max; ANF_DATA.Air.CL_max = CLmax;
    mu = clDefaults.Air_mu; ANF_DATA.Air.mu = mu;
end

% update textboxes
set(handles.txtRunway, 'String', runway_alt);
set(handles.txtCruiseHeight, 'String', cruise_height);
set(handles.txtDISA, 'String', disa);
set(handles.txtCruiseSpeed, 'String', airspeed);
set(handles.txtCd0, 'String', CD0);
set(handles.txtCLmax, 'String', CLmax);
set(handles.txtMu, 'String', mu);
updateCL(handles);


function txtCruiseSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to txtCruiseSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCruiseSpeed as text
%        str2double(get(hObject,'String')) returns contents of txtCruiseSpeed as a double

global ANF_DATA;
ANF_DATA.Air.cruise_speed = str2double(get(hObject, 'String'));
updateCL(handles);


% --- Executes during object creation, after setting all properties.
function txtCruiseSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCruiseSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtCd0_Callback(hObject, eventdata, handles)
% hObject    handle to txtCd0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCd0 as text
%        str2double(get(hObject,'String')) returns contents of txtCd0 as a double

global ANF_DATA;
ANF_DATA.Air.CD0 = str2double(get(hObject, 'String'));
updateCL(handles);


% --- Executes during object creation, after setting all properties.
function txtCd0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCd0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtCL_Callback(hObject, eventdata, handles)
% hObject    handle to txtCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCL as text
%        str2double(get(hObject,'String')) returns contents of txtCL as a double


% --- Executes during object creation, after setting all properties.
function txtCL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateCL(handles)

global ANF_DATA;

try
    total_weight = fnCalcCG(ANF_DATA);
    h_cruise = ANF_DATA.Air.cruise_height + ANF_DATA.Air.runway_alt;
    rho = fnAtmosphere(h_cruise, ANF_DATA.Air.DISA);
    v_cruise = ANF_DATA.Air.cruise_speed;
    
    formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
    S = fnCalcPlanformArea(formatted_wing_data);

    CL = total_weight/(1/2*rho*v_cruise^2*S);
    set(handles.txtCL, 'String', sprintf('%0.3f',CL));
catch ME
    set(handles.txtCL, 'String', 'N/A');
end


function txtCLmax_Callback(hObject, eventdata, handles)
% hObject    handle to txtCLmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCLmax as text
%        str2double(get(hObject,'String')) returns contents of txtCLmax as a double

global ANF_DATA;
ANF_DATA.Air.CL_max = str2double(get(hObject, 'String'));
updateCL(handles);


% --- Executes during object creation, after setting all properties.
function txtCLmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCLmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtMu_Callback(hObject, eventdata, handles)
% hObject    handle to txtMu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMu as text
%        str2double(get(hObject,'String')) returns contents of txtMu as a double

global ANF_DATA;
ANF_DATA.Air.mu = str2double(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function txtMu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
