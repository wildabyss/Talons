function varargout = GroundHandlingGUI(varargin)
% GROUNDHANDLINGGUI MATLAB code for GroundHandlingGUI.fig
%      GROUNDHANDLINGGUI, by itself, creates a new GROUNDHANDLINGGUI or raises the existing
%      singleton*.
%
%      H = GROUNDHANDLINGGUI returns the handle to a new GROUNDHANDLINGGUI or the handle to
%      the existing singleton*.
%
%      GROUNDHANDLINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUNDHANDLINGGUI.M with the given input arguments.
%
%      GROUNDHANDLINGGUI('Property','Value',...) creates a new GROUNDHANDLINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GroundHandlingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GroundHandlingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GroundHandlingGUI

% Last Modified by GUIDE v2.5 16-Mar-2014 23:56:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GroundHandlingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GroundHandlingGUI_OutputFcn, ...
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


% --- Executes just before GroundHandlingGUI is made visible.
function GroundHandlingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GroundHandlingGUI (see VARARGIN)

% Choose default command line output for GroundHandlingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GroundHandlingGUI wait for user response (see UIRESUME)
% uiwait(handles.GroundHandlingGUI);

update(handles);


% --- Outputs from this function are returned to the command line.
function varargout = GroundHandlingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cmdRefresh.
function cmdRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update(handles);


function update(handles)

global ANF_RESULTS_AIR ANF_RESULTS_GROUND ANF_DATA;

% "need update" label
if ANF_RESULTS_AIR.NeedUpdate==1 || ANF_RESULTS_GROUND.NeedUpdate==1
    set(handles.lblChanged, 'String', 'Geometry changed. Rerun analysis.');
    set(handles.lblChanged, 'Visible', 'on');
    return;
end

% get inputs
g = clDefaults.g;
if ~isfield(ANF_DATA, 'Geometry') || ~isfield(ANF_DATA.Geometry, 'MLG_height')
    ANF_DATA.Geometry.MLG_height = clDefaults.Geometry_MLG_height;
end
MLG_height = ANF_DATA.Geometry.MLG_height;
if ~isfield(ANF_DATA, 'Geometry') || ~isfield(ANF_DATA.Geometry, 'MLG_width')
    ANF_DATA.Geometry.MLG_width = clDefaults.Geometry_MLG_width;
end
MLG_width = ANF_DATA.Geometry.MLG_width;
if ~isfield(ANF_DATA, 'Geometry') || ~isfield(ANF_DATA.Geometry, 'MLG_X')
    ANF_DATA.Geometry.MLG_X = clDefaults.Geometry_MLG_X;
end
MLG_X = ANF_DATA.Geometry.MLG_X;
if ~isfield(ANF_DATA, 'Geometry') || ~isfield(ANF_DATA.Geometry, 'NG_height')
    ANF_DATA.Geometry.NG_height = clDefaults.Geometry_NG_height;
end
NG_height = ANF_DATA.Geometry.NG_height;
if ~isfield(ANF_DATA, 'Geometry') || ~isfield(ANF_DATA.Geometry, 'NG_X')
    ANF_DATA.Geometry.NG_X = clDefaults.Geometry_NG_X;
end
NG_X = ANF_DATA.Geometry.NG_X;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'runway_alt')
    ANF_DATA.Air.runway_alt = clDefaults.Air_runway_alt;
end
hRunway = ANF_DATA.Air.runway_alt;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'DISA')
    ANF_DATA.Air.DISA = clDefaults.Air_DISA;
end
DISA = ANF_DATA.Air.DISA;
if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'rotation_alpha')
    ANF_DATA.Interaction.rotation_alpha = clDefaults.Interaction_rotation_alpha;
end
rotation_alpha = ANF_DATA.Interaction.rotation_alpha/180*pi;

% get aerodynamic outputs
% with GE
CLag = ANF_RESULTS_GROUND.CLa;
CLg = ANF_RESULTS_GROUND.CL;
AoAg = ANF_RESULTS_GROUND.Alpha/180*pi;

% geometry related calculations
try
    formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
    
    S = fnCalcPlanformArea(formatted_wing_data);
    [W CGx CGy CGz] = fnCalcCG(ANF_DATA); m = W/g;
    rho = fnAtmosphere(hRunway, DISA);
    jig_theta = fnJigTheta(ANF_DATA.Geometry);
catch ME
    set(handles.lblChanged, 'String', 'Geometry definition incomplete.');
    set(handles.lblChanged, 'Visible', 'on');
    return;
end

% static tipback angle
if MLG_X >= NG_X
    % tricycle
    x_wheel = MLG_X;
    z_wheel = -MLG_height;
else
    x_wheel = NG_X;
    z_wheel = -NG_height;
end
static_tipback_angle = fnTipBackAnalysis(x_wheel, z_wheel, CGx, CGz)/pi*180;
set(handles.txtTipback, 'String', sprintf('%1.2f', static_tipback_angle));

% overturn radius/speed
% calculate Vmu (liftoff speed)
Vmu = sqrt(W/(1/2*rho*S*((rotation_alpha-AoAg)*CLag+CLg)));
Vt = 0.1:1:Vmu;
L = 1/2*rho*Vt.^2*S*((jig_theta-AoAg)*CLag + CLg);
rc = fnOverturnAnalysis(MLG_width, MLG_height, CGy, CGz, m, g, L, Vt);

cla(handles.figOverturn, 'reset');
plot(handles.figOverturn, Vt, rc);
grid on;
xlabel('Ground Speed (m/s)');
ylabel('Minimum Turn Radius (m)');

% set warning label off
set(handles.lblChanged, 'Visible', 'off');


function txtTipback_Callback(hObject, eventdata, handles)
% hObject    handle to txtTipback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTipback as text
%        str2double(get(hObject,'String')) returns contents of txtTipback as a double


% --- Executes during object creation, after setting all properties.
function txtTipback_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTipback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
