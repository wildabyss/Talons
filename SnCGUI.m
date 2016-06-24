function varargout = SnCGUI(varargin)
% SNCGUI MATLAB code for SnCGUI.fig
%      SNCGUI, by itself, creates a new SNCGUI or raises the existing
%      singleton*.
%
%      H = SNCGUI returns the handle to a new SNCGUI or the handle to
%      the existing singleton*.
%
%      SNCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SNCGUI.M with the given input arguments.
%
%      SNCGUI('Property','Value',...) creates a new SNCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SnCGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SnCGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SnCGUI

% Last Modified by GUIDE v2.5 15-May-2014 22:11:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SnCGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SnCGUI_OutputFcn, ...
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


% --- Executes just before SnCGUI is made visible.
function SnCGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SnCGUI (see VARARGIN)

% Choose default command line output for SnCGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SnCGUI wait for user response (see UIRESUME)
% uiwait(handles.SnCGUI);

updateVars(handles);

% --- Outputs from this function are returned to the command line.
function varargout = SnCGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtSM_Callback(hObject, eventdata, handles)
% hObject    handle to txtSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSM as text
%        str2double(get(hObject,'String')) returns contents of txtSM as a double


% --- Executes during object creation, after setting all properties.
function txtSM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtElevTrim_Callback(hObject, eventdata, handles)
% hObject    handle to txtElevTrim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtElevTrim as text
%        str2double(get(hObject,'String')) returns contents of txtElevTrim as a double


% --- Executes during object creation, after setting all properties.
function txtElevTrim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtElevTrim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMaxElev_Callback(hObject, eventdata, handles)
% hObject    handle to txtMaxElev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMaxElev as text
%        str2double(get(hObject,'String')) returns contents of txtMaxElev as a double

global ANF_DATA;
ANF_DATA.Interaction.max_elev = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtMaxElev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMaxElev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtAoAMin_Callback(hObject, eventdata, handles)
% hObject    handle to txtAoAMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAoAMin as text
%        str2double(get(hObject,'String')) returns contents of txtAoAMin as a double


% --- Executes during object creation, after setting all properties.
function txtAoAMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAoAMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtAoAMax_Callback(hObject, eventdata, handles)
% hObject    handle to txtAoAMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAoAMax as text
%        str2double(get(hObject,'String')) returns contents of txtAoAMax as a double


% --- Executes during object creation, after setting all properties.
function txtAoAMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAoAMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtServoRes_Callback(hObject, eventdata, handles)
% hObject    handle to txtServoRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtServoRes as text
%        str2double(get(hObject,'String')) returns contents of txtServoRes as a double

global ANF_DATA;
ANF_DATA.Interaction.servo_resolution = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtServoRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtServoRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMinDV_Callback(hObject, eventdata, handles)
% hObject    handle to txtMinDV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMinDV as text
%        str2double(get(hObject,'String')) returns contents of txtMinDV as a double


% --- Executes during object creation, after setting all properties.
function txtMinDV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMinDV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtdDedG_Callback(hObject, eventdata, handles)
% hObject    handle to txtdDedG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtdDedG as text
%        str2double(get(hObject,'String')) returns contents of txtdDedG as a double


% --- Executes during object creation, after setting all properties.
function txtdDedG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtdDedG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtdDedV_Callback(hObject, eventdata, handles)
% hObject    handle to txtdDedV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtdDedV as text
%        str2double(get(hObject,'String')) returns contents of txtdDedV as a double


% --- Executes during object creation, after setting all properties.
function txtdDedV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtdDedV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtCnb_Callback(hObject, eventdata, handles)
% hObject    handle to txtCnb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCnb as text
%        str2double(get(hObject,'String')) returns contents of txtCnb as a double


% --- Executes during object creation, after setting all properties.
function txtCnb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCnb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMaxAil_Callback(hObject, eventdata, handles)
% hObject    handle to txtMaxAil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMaxAil as text
%        str2double(get(hObject,'String')) returns contents of txtMaxAil as a double

global ANF_DATA;
ANF_DATA.Interaction.max_ail = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtMaxAil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMaxAil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMaxP_Callback(hObject, eventdata, handles)
% hObject    handle to txtMaxP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMaxP as text
%        str2double(get(hObject,'String')) returns contents of txtMaxP as a double


% --- Executes during object creation, after setting all properties.
function txtMaxP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMaxP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMaxRud_Callback(hObject, eventdata, handles)
% hObject    handle to txtMaxRud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMaxRud as text
%        str2double(get(hObject,'String')) returns contents of txtMaxRud as a double

global ANF_DATA;
ANF_DATA.Interaction.max_rud = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtMaxRud_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMaxRud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMaxSHSS_Callback(hObject, eventdata, handles)
% hObject    handle to txtMaxSHSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMaxSHSS as text
%        str2double(get(hObject,'String')) returns contents of txtMaxSHSS as a double


% --- Executes during object creation, after setting all properties.
function txtMaxSHSS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMaxSHSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtAoACruise_Callback(hObject, eventdata, handles)
% hObject    handle to txtAoACruise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAoACruise as text
%        str2double(get(hObject,'String')) returns contents of txtAoACruise as a double


% --- Executes during object creation, after setting all properties.
function txtAoACruise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAoACruise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse motion over figure - except title and menu.
function SnCGUI_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to SnCGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cmdRefresh.
function cmdRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateCalcs(handles);


function txtVH_Callback(hObject, eventdata, handles)
% hObject    handle to txtVH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVH as text
%        str2double(get(hObject,'String')) returns contents of txtVH as a double


% --- Executes during object creation, after setting all properties.
function txtVH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtVV_Callback(hObject, eventdata, handles)
% hObject    handle to txtVV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVV as text
%        str2double(get(hObject,'String')) returns contents of txtVV as a double


% --- Executes during object creation, after setting all properties.
function txtVV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateVars(handles)

global ANF_DATA;
if isfield(ANF_DATA, 'Interaction')
    if isfield(ANF_DATA.Interaction, 'max_elev')
        max_elev = ANF_DATA.Interaction.max_elev;
    else
        max_elev = clDefaults.Interaction_max_elev;
        ANF_DATA.Interaction.max_elev = max_elev;
    end
    if isfield(ANF_DATA.Interaction, 'max_ail')
        max_ail = ANF_DATA.Interaction.max_ail;
    else
        max_ail = clDefaults.Interaction_max_ail;
        ANF_DATA.Interaction.max_ail = max_ail;
    end
    if isfield(ANF_DATA.Interaction, 'max_rud')
        max_rud = ANF_DATA.Interaction.max_rud;
    else
        max_rud = clDefaults.Interaction_max_rud;
        ANF_DATA.Interaction.max_rud = max_rud;
    end
    if isfield(ANF_DATA.Interaction, 'servo_resolution')
        servo_resolution = ANF_DATA.Interaction.servo_resolution;
    else
        servo_resolution = clDefaults.Interaction_servo_resolution;
        ANF_DATA.Interaction.servo_resolution = servo_resolution;
    end
else
    % set up default if values don't exist
    max_elev = clDefaults.Interaction_max_elev;
    ANF_DATA.Interaction.max_elev = max_elev;
    max_ail = clDefaults.Interaction_max_ail;
    ANF_DATA.Interaction.max_ail = max_ail;
    max_rud = clDefaults.Interaction_max_rud;
    ANF_DATA.Interaction.max_rud = max_rud;
    servo_resolution = clDefaults.Interaction_servo_resolution;
    ANF_DATA.Interaction.servo_resolution = servo_resolution;
end

% update textboxes
set(handles.txtMaxElev, 'String', max_elev);
set(handles.txtMaxAil, 'String', max_ail);
set(handles.txtMaxRud, 'String', max_rud);
set(handles.txtServoRes, 'String', servo_resolution);

% update calculations
updateCalcs(handles);


function updateCalcs(handles)

global ANF_RESULTS_AIR ANF_RESULTS_GROUND ANF_DATA ANF_RESULTS_HM;

% "need update" label
if ANF_RESULTS_AIR.NeedUpdate==1 || ANF_RESULTS_GROUND.NeedUpdate==1
    set(handles.lblChanged, 'String', 'Geometry changed. Rerun analysis.');
    set(handles.lblChanged, 'Visible', 'on');
    return;
end

% get inputs
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'runway_alt')
    ANF_DATA.Air.runway_alt = clDefaults.Air_runway_alt;
end
hRunway = ANF_DATA.Air.runway_alt;
if ~isfield(ANF_DATA.Air, 'cruise_height')
    ANF_DATA.Air.cruise_height = clDefaults.Air_cruise_height;
end
hCruise = hRunway + ANF_DATA.Air.cruise_height;
if ~isfield(ANF_DATA.Air, 'DISA')
    ANF_DATA.Air.DISA = clDefaults.Air_DISA;
end
DISA = ANF_DATA.Air.DISA;
if ~isfield(ANF_DATA.Air, 'cruise_speed')
    ANF_DATA.Air.cruise_speed = clDefaults.Air_cruise_speed;
end
Ve = ANF_DATA.Air.cruise_speed;
if ~isfield(ANF_DATA.Air, 'mu')
    ANF_DATA.Air.mu = clDefaults.Air_mu;
end
mu = ANF_DATA.Air.mu;

if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'max_elev')
    ANF_DATA.Interaction.max_elev = clDefaults.Interaction_max_elev;
end
max_elev = ANF_DATA.Interaction.max_elev;
if ~isfield(ANF_DATA.Interaction, 'max_ail')
    ANF_DATA.Interaction.max_ail = clDefaults.Interaction_max_ail;
end
max_ail = ANF_DATA.Interaction.max_ail;
if ~isfield(ANF_DATA.Interaction, 'max_rud')
    ANF_DATA.Interaction.max_rud = clDefaults.Interaction_max_rud;
end
max_rud = ANF_DATA.Interaction.max_rud;
if ~isfield(ANF_DATA.Interaction, 'servo_resolution')
    ANF_DATA.Interaction.servo_resolution = clDefaults.Interaction_servo_resolution;
end
servo_resolution = ANF_DATA.Interaction.servo_resolution;
if ~isfield(ANF_DATA, 'Propulsion')
    ANF_DATA.Propulsion.type = clDefaults.Propulsion_type;
end

% get aerodynamic outputs
has_ail = 1;
has_rud = 1;
% no GE
CGx_ref = ANF_RESULTS_AIR.CGx_ref;
alpha_aero = ANF_RESULTS_AIR.Alpha;
CLa = ANF_RESULTS_AIR.CLa;
CLq = ANF_RESULTS_AIR.CLq;
Cma = ANF_RESULTS_AIR.Cma;
Cmq = ANF_RESULTS_AIR.Cmq;
CLaero = ANF_RESULTS_AIR.CL;
Cmaero = ANF_RESULTS_AIR.Cm;
CLde = ANF_RESULTS_AIR.CLde;
Cmde = ANF_RESULTS_AIR.Cmde;
Cyb = ANF_RESULTS_AIR.Cyb;
Cnb = ANF_RESULTS_AIR.Cnb;
Cnp = ANF_RESULTS_AIR.Cnp;
Clb = ANF_RESULTS_AIR.Clb;
Clp = ANF_RESULTS_AIR.Clp;

try 
    Cyda = ANF_RESULTS_AIR.Cyda;
    Clda = ANF_RESULTS_AIR.Clda;
    Cnda = ANF_RESULTS_AIR.Cnda;
catch ME
    has_ail = 0;
end
try
    Cydr = ANF_RESULTS_AIR.Cydr;
    Cldr = ANF_RESULTS_AIR.Cldr;
    Cndr = ANF_RESULTS_AIR.Cndr;
catch ME
    has_rud = 0;
end

% geometry related calculations
try
    formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
    
    [W CGx CGy CGz] = fnCalcCG(ANF_DATA);
    S = fnCalcPlanformArea(formatted_wing_data);
    MAC = fnCalcMAC(formatted_wing_data);
    b = fnCalcWingSpan(formatted_wing_data);
    rho = fnAtmosphere(hCruise, DISA);
    
    % trimmed CL
    CLe = fnCalcLift(W, S, rho, Ve);
catch ME
    set(handles.lblChanged, 'String', 'Geometry definition incomplete.');
    set(handles.lblChanged, 'Visible', 'on');
    return;
end

% include propulsive effect?
pEff = get(handles.mnuThrust, 'value');
if pEff == 2
    [~, T] = fnAtmosphere(hCruise, DISA);
    [Cmaero, Cma, Cmq, Cmde, Cnb, Cnda, Cndr] = fnCalcThrustEffects(Cmaero, ...
        Cma, Cmq, Cmde, Cnb, Cnda, Cndr, CLaero, CLa, CLq, CLde, Cyb, Cyda, ...
        Cydr, MAC, b, [CGx CGy CGz], ANF_DATA.Propulsion, Ve, W, hCruise, T);
end

%-- cruise values

[alpha_trim de_trim] = fnTrim(CLe, CLa, CLde, Cma, Cmde, CLaero, ...
    alpha_aero/180*pi, Cmaero, CGx, CGx_ref, MAC);
alpha_trim = alpha_trim*180/pi;
de_trim = de_trim*180/pi;

set(handles.txtAoACruise, 'String', sprintf('%1.1f',alpha_trim));
set(handles.txtElevTrim, 'String', sprintf('%1.1f',de_trim));

%-- static margin

NP = fnCalcNeutralPoint(Cma, CLa, MAC, CGx_ref);

sm_0T = fnCalcStaticMargin(CGx, NP, MAC);
% sm_maxT = fnCalcStaticMargin(CGx, NP_maxT, MAC);
set(handles.txtSM, 'String', sprintf('%1.1f',sm_0T*100));

%-- elevator authority

g = clDefaults.g;
[min_AoA_trim max_AoA_trim dedV deG] = fnCalcElevatorAuthority(CGx, CGx_ref, ...
    CLaero, CLe, CLa, CLde, CLq, Cmaero, Cma, Cmde, Cmq, alpha_aero/180*pi, ...
    Ve, W, S, MAC, rho, g, max_elev/180*pi);
min_AoA_trim = min_AoA_trim*180/pi;
max_AoA_trim = max_AoA_trim*180/pi;
dedV = dedV*180/pi;
deG = deG*180/pi;
speed_res = servo_resolution/dedV;

set(handles.txtAoAMin, 'String', sprintf('%1.2f',min_AoA_trim));
set(handles.txtAoAMax, 'String', sprintf('%1.2f',max_AoA_trim));
set(handles.txtdDedG, 'String', sprintf('%1.2f',deG));
set(handles.txtdDedV, 'String', sprintf('%1.2f',dedV));
set(handles.txtMinDV, 'String', sprintf('%1.3f',speed_res));

%-- speed stability

V = (8:0.1:Ve+15);      % range of airspeeds to be analyzed
CL = fnCalcLift(W, S, rho, V);
[~, delta_e] = fnTrim(CL, CLa, CLde, Cma, Cmde, CLaero, alpha_aero/180*pi, ...
    Cmaero, CGx, CGx_ref, MAC);
delta_e = delta_e*180/pi;

cla(handles.figElevSpeed, 'reset');
hold(handles.figElevSpeed, 'all');
plot(handles.figElevSpeed, V, delta_e);
plot(handles.figElevSpeed, Ve, de_trim, 'gs', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
hold(handles.figElevSpeed, 'off');
grid(handles.figElevSpeed);
xlabel(handles.figElevSpeed, 'V (m/s)');
ylabel(handles.figElevSpeed, '\Delta\delta_e (deg)');

%-- lateral directional authority

% aileron authority
if has_ail
    p_max = abs(180/pi*fnCalcAileronAuthority(Clp, Clda, max_ail/180*pi, b, Ve));
    set(handles.txtMaxP, 'String', sprintf('%1.2f',p_max));
else
    set(handles.txtMaxP, 'String', 'N/A');
end

% rudder authority
if has_rud && has_ail
    beta_max = fnCalcRudderAuthority(CGx, CGx_ref, CLe, Cyb, Cyda, Cydr, ...
        Clb, Clda, Cldr, Cnb, Cnda, Cndr, max_rud/180*pi, b)/pi*180;
    set(handles.txtMaxSHSS, 'String', sprintf('%1.2f',beta_max));
else
    set(handles.txtMaxSHSS, 'String', 'N/A');
end

% yaw stiffness
set(handles.txtCnb, 'String', sprintf('%1.3f',Cnb));

% vstab volume
formatted_vstab_data = fnParseVStabData(ANF_DATA.Geometry);
if formatted_vstab_data.nums>0
    VV = fnCalcVTailVolume(CGx, b, S, formatted_vstab_data);
    set(handles.txtVV, 'String', sprintf('%1.3f',VV));
else
    set(handles.txtVV, 'String', 'N/A');
end

%-- hinge moments

Re = fnCalcRe(rho, Ve, MAC, mu);

alphas = [alpha_trim-5 alpha_trim alpha_trim+5 alpha_trim+10]/180*pi;
betas = [-10 -5 0 5 10]/180*pi;
defs = [-20 -10 0 10 20]/180*pi;

[matAlphas matDef_Alpha] = meshgrid(alphas, defs);
[matBetas matDef_Beta] = meshgrid(betas, defs);

cla(handles.figAilHM, 'reset');
cla(handles.figElevHM, 'reset');
cla(handles.figRudHM, 'reset');
if has_ail
    HMail = fnCalcHingeMoments(formatted_wing_data, 'aileron', 1, matAlphas, ...
        matDef_Alpha, CLa, Ve, rho, Re, ANF_DATA.Directory);
    
    [~, h] = contour(handles.figAilHM, matDef_Alpha/pi*180, matAlphas/pi*180, HMail);
    set(h, 'ShowText', 'on');
    xlabel(handles.figAilHM, 'Aileron Deflection (deg)');
    ylabel(handles.figAilHM, 'AoA (deg)');
end

formatted_hstab_data = fnParseHStabData(ANF_DATA.Geometry);
if formatted_hstab_data.nums>0
    HMelev = fnCalcHingeMoments(formatted_hstab_data, 'elevator', 0, matAlphas, ...
        matDef_Alpha, CLa, Ve, rho, Re, ANF_DATA.Directory);
else
    HMelev = fnCalcHingeMoments(formatted_wing_data, 'elevator', 1, matAlphas, ...
        matDef_Alpha, CLa, Ve, rho, Re, ANF_DATA.Directory);
end
[~, h] = contour(handles.figElevHM, matDef_Alpha/pi*180, matAlphas/pi*180, HMelev);
set(h, 'ShowText', 'on');
xlabel(handles.figElevHM, 'Elevator Deflection (deg)');
ylabel(handles.figElevHM, 'AoA (deg)');

formatted_vstab_data = fnParseVStabData(ANF_DATA.Geometry);
if has_rud
    HMrud = fnCalcHingeMoments(formatted_vstab_data, 'rudder', 1, matBetas, ...
        matDef_Beta, Cyb, Ve, rho, Re, ANF_DATA.Directory);
    
    [~, h] = contour(handles.figRudHM, matDef_Beta/pi*180, matBetas/pi*180, HMrud);
    set(h, 'ShowText', 'on');
    xlabel(handles.figRudHM, 'Rudder Deflection (deg)');
    ylabel(handles.figRudHM, 'Beta (deg)');
end


% turn off warning label
set(handles.lblChanged, 'Visible', 'off');


% --- Executes on selection change in mnuThrust.
function mnuThrust_Callback(hObject, eventdata, handles)
% hObject    handle to mnuThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuThrust contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuThrust

updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function mnuThrust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
