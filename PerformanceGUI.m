function varargout = PerformanceGUI(varargin)
% PERFORMANCEGUI MATLAB code for PerformanceGUI.fig
%      PERFORMANCEGUI, by itself, creates a new PERFORMANCEGUI or raises the existing
%      singleton*.
%
%      H = PERFORMANCEGUI returns the handle to a new PERFORMANCEGUI or the handle to
%      the existing singleton*.
%
%      PERFORMANCEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERFORMANCEGUI.M with the given input arguments.
%
%      PERFORMANCEGUI('Property','Value',...) creates a new PERFORMANCEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PerformanceGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PerformanceGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PerformanceGUI

% Last Modified by GUIDE v2.5 14-May-2014 22:34:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PerformanceGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PerformanceGUI_OutputFcn, ...
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


% --- Executes just before PerformanceGUI is made visible.
function PerformanceGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PerformanceGUI (see VARARGIN)

% Choose default command line output for PerformanceGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PerformanceGUI wait for user response (see UIRESUME)
% uiwait(handles.PerformanceGUI);

updateVars(handles);

% --- Outputs from this function are returned to the command line.
function varargout = PerformanceGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtRotAngle_Callback(hObject, eventdata, handles)
% hObject    handle to txtRotAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRotAngle as text
%        str2double(get(hObject,'String')) returns contents of txtRotAngle as a double

global ANF_DATA;
ANF_DATA.Interaction.rotation_alpha = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtRotAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRotAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtTakeoffDist_Callback(hObject, eventdata, handles)
% hObject    handle to txtTakeoffDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTakeoffDist as text
%        str2double(get(hObject,'String')) returns contents of txtTakeoffDist as a double


% --- Executes during object creation, after setting all properties.
function txtTakeoffDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTakeoffDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtFlareAngle_Callback(hObject, eventdata, handles)
% hObject    handle to txtFlareAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFlareAngle as text
%        str2double(get(hObject,'String')) returns contents of txtFlareAngle as a double

global ANF_DATA;
ANF_DATA.Interaction.flare_alpha = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtFlareAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFlareAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtLandingDist_Callback(hObject, eventdata, handles)
% hObject    handle to txtLandingDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLandingDist as text
%        str2double(get(hObject,'String')) returns contents of txtLandingDist as a double


% --- Executes during object creation, after setting all properties.
function txtLandingDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLandingDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse motion over figure - except title and menu.
function PerformanceGUI_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to PerformanceGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function txtMuBrake_Callback(hObject, eventdata, handles)
% hObject    handle to txtMuBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMuBrake as text
%        str2double(get(hObject,'String')) returns contents of txtMuBrake as a double

global ANF_DATA;
ANF_DATA.Interaction.mu_brake = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtMuBrake_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMuBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMuTire_Callback(hObject, eventdata, handles)
% hObject    handle to txtMuTire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMuTire as text
%        str2double(get(hObject,'String')) returns contents of txtMuTire as a double

global ANF_DATA;
ANF_DATA.Interaction.mu_tire = str2double(get(hObject, 'String'));
updateCalcs(handles);


% --- Executes during object creation, after setting all properties.
function txtMuTire_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMuTire (see GCBO)
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
    if isfield(ANF_DATA.Interaction, 'rotation_alpha')
        rotation_alpha = ANF_DATA.Interaction.rotation_alpha;
    else
        rotation_alpha = clDefaults.Interaction_rotation_alpha;
        ANF_DATA.Interaction.rotation_alpha = rotation_alpha;
    end
    if isfield(ANF_DATA.Interaction, 'flare_alpha')
        flare_alpha = ANF_DATA.Interaction.flare_alpha;
    else
        flare_alpha = clDefaults.Interaction_flare_alpha;
        ANF_DATA.Interaction.flare_alpha = flare_alpha;
    end
    if isfield(ANF_DATA.Interaction, 'mu_tire')
        mu_tire = ANF_DATA.Interaction.mu_tire;
    else
        mu_tire = clDefaults.Interaction_mu_tire;
        ANF_DATA.Interaction.mu_tire = mu_tire;
    end
    if isfield(ANF_DATA.Interaction, 'mu_brake')
        mu_brake = ANF_DATA.Interaction.mu_brake;
    else
        mu_brake = clDefaults.Interaction_mu_brake;
        ANF_DATA.Interaction.mu_brake = mu_brake;
    end
else
    % set up default if values don't exist
    rotation_alpha = clDefaults.Interaction_rotation_alpha;
    ANF_DATA.Interaction.rotation_alpha = rotation_alpha;
    flare_alpha = clDefaults.Interaction_flare_alpha;
    ANF_DATA.Interaction.flare_alpha = flare_alpha;
    mu_brake = clDefaults.Interaction_mu_brake;
    ANF_DATA.Interaction.mu_brake = mu_brake;
    mu_tire = clDefaults.Interaction_mu_tire;
    ANF_DATA.Interaction.mu_tire = mu_tire;
end

% update textboxes
set(handles.txtRotAngle, 'String', rotation_alpha);
set(handles.txtFlareAngle, 'String', flare_alpha);
set(handles.txtMuTire, 'String', mu_tire);
set(handles.txtMuBrake, 'String', mu_brake);

% update calculations
updateCalcs(handles);


function updateCalcs(handles)

global ANF_RESULTS_AIR ANF_RESULTS_GROUND ANF_DATA;

% "need update" label
if ANF_RESULTS_AIR.NeedUpdate==1 || ANF_RESULTS_GROUND.NeedUpdate==1
    set(handles.lblChanged, 'String', 'Geometry changed. Rerun analysis.');
    set(handles.lblChanged, 'Visible', 'on');
    return;
end

% proceed to calculate a/c performance

% get inputs
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'runway_alt')
    ANF_DATA.Air.runway_alt = clDefaults.Air_runway_alt;
end
hRunway = ANF_DATA.Air.runway_alt;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'cruise_height')
    ANF_DATA.Air.cruise_height = clDefaults.Air_cruise_height;
end
hCruise = hRunway + ANF_DATA.Air.cruise_height;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'DISA')
    ANF_DATA.Air.DISA = clDefaults.Air_DISA;
end
DISA = ANF_DATA.Air.DISA;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'CD0')
    ANF_DATA.Air.CD0 = clDefaults.Air_CD0;
end
CD0 = ANF_DATA.Air.CD0;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'cruise_speed')
    ANF_DATA.Air.cruise_speed = clDefaults.Air_cruise_speed;
end
Ve = ANF_DATA.Air.cruise_speed;
if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'CL_max')
    ANF_DATA.Air.CL_max = clDefaults.Air_CLa_max;
end
CLmax = ANF_DATA.Air.CL_max;
if ~isfield(ANF_DATA, 'Propulsion') || ~isfield(ANF_DATA.Propulsion, 'type')
    ANF_DATA.Propulsion.type = clDefaults.Propulsion_type;
end
rotation_alpha = ANF_DATA.Interaction.rotation_alpha;
if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'flare_alpha')
    ANF_DATA.Interaction.flare_alpha = clDefaults.Interaction_flare_alpha;
end
flare_alpha = ANF_DATA.Interaction.flare_alpha;
if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'mu_brake')
    ANF_DATA.Interaction.mu_brake = clDefaults.Interaction_mu_brake;
end
mu_brake = ANF_DATA.Interaction.mu_brake;
if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'mu_tire')
    ANF_DATA.Interaction.mu_tire = clDefaults.Interaction_mu_tire;
end
mu_tire = ANF_DATA.Interaction.mu_tire;

% get aerodynamic outputs
% no GE
CGx_ref = ANF_RESULTS_AIR.CGx_ref;
e = ANF_RESULTS_AIR.e;
alpha_aero = ANF_RESULTS_AIR.Alpha;
CLa = ANF_RESULTS_AIR.CLa;
Cma = ANF_RESULTS_AIR.Cma;
CLaero = ANF_RESULTS_AIR.CL;
Cmaero = ANF_RESULTS_AIR.Cm;
CLde = ANF_RESULTS_AIR.CLde;
Cmde = ANF_RESULTS_AIR.Cmde;
% with GE
CLag = ANF_RESULTS_GROUND.CLa;
CLg = ANF_RESULTS_GROUND.CL;
CDi_g = ANF_RESULTS_GROUND.CD;
AoAg = ANF_RESULTS_GROUND.Alpha;

% geometry related calculations
try
    formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
    
    b = fnCalcWingSpan(formatted_wing_data);
    S = fnCalcPlanformArea(formatted_wing_data);
    AR = fnCalcAspectRatio(b, S);
    MAC = fnCalcMAC(formatted_wing_data);
    [W CGx] = fnCalcCG(ANF_DATA);
    [rho temp] = fnAtmosphere(hCruise, DISA);
    jig_theta = fnJigTheta(ANF_DATA.Geometry);
catch ME
    set(handles.lblChanged, 'String', 'Geometry definition incomplete.');
    set(handles.lblChanged, 'Visible', 'on');
    return;
end

%-- calculate drag polar

CL = (-0.2:0.1:2.2);
CD = fnCalcDrag(CL, CD0, e, AR);
AoAs = 180/pi*fnTrim(CL, CLa, CLde, Cma, Cmde, CLaero, alpha_aero/180*pi, ...
    Cmaero, CGx, CGx_ref, MAC);

% cruise condition
CLe = fnCalcLift(W, S, rho, Ve);
CDe = fnCalcDrag(CLe, CD0, e, AR);

% overlay plot of CL, CD and Alpha
cla(handles.figDrag, 'reset');
hold(handles.figDrag, 'all');
[h_ax, ~, h_line2] = plotyy(handles.figDrag, CD, CL, CD, AoAs);
set(h_ax(2), 'YColor', 'black'); set(h_ax(1), 'YColor', 'black');
set(h_line2, 'color', 'b');
ylim(h_ax(1), [CL(1), CL(length(CL))]);
ylim(h_ax(2), [AoAs(1), AoAs(length(AoAs))]);
plot(handles.figDrag, CDe, CLe, 'gs', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
set(h_ax(1),'YTick', -2:0.2:5); set(h_ax(2),'YTick', -20:5:20);
grid(handles.figDrag);
xlabel(handles.figDrag, 'CD_{trim}');
ylabel(h_ax(1), 'CL_{trim}');
ylabel(h_ax(2), '\alpha_{cruise}', 'color', 'black');

hold(handles.figDrag, 'on');
plot(handles.figDrag, [0 2], CLmax*[1 1], 'r--');
hold(handles.figDrag, 'off');

legend('Trimmed Polar', 'CL_{cruise}', 'CL_{max}', 'Location', 'SouthEast');

%-- calculate rate of climb and descent

alts = [hRunway, hCruise];

cla(handles.figClimb, 'reset'); cla(handles.figDescent, 'reset');
hold(handles.figClimb, 'all');
hold(handles.figDescent, 'all');
maxRC = 1;
maxRD = 1;
V = (8:0.1:Ve+15);      % range of airspeeds to be analyzed

for i=1:length(alts)
    h = alts(i);
    rho = fnAtmosphere(h, DISA);

    CL = fnCalcLift(W, S, rho, V);
    CD = fnCalcDrag(CL, CD0, e, AR);
    RC = fnCalcMaxClimbRate(W, V, h, temp, CD, S, rho, ANF_DATA.Propulsion);
    maxRC = max([RC maxRC]);
    RD = fnCalcMaxSinkRate(W, V, CD, S, rho);
    maxRD = max([RD maxRD]);
    
    plot(handles.figClimb, V, RC);
    plot(handles.figDescent, V, RD);
end

% cruise values
[rho temp] = fnAtmosphere(hCruise, DISA);
RCe = fnCalcMaxClimbRate(W, Ve, hCruise, temp, CDe, S, rho, ANF_DATA.Propulsion);
RDe = fnCalcMaxSinkRate(W, Ve, CDe, S, rho);
plot(handles.figClimb, Ve, RCe, 'gs', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
plot(handles.figDescent, Ve, RDe, 'gs', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

hold(handles.figClimb, 'off');
hold(handles.figDescent, 'off');
legend(handles.figClimb, 'Runway Alt', 'Cruise Alt');
legend(handles.figDescent, 'Runway Alt', 'Cruise Alt');
grid(handles.figClimb); grid(handles.figDescent);
xlabel(handles.figClimb, 'V (m/s)'); xlabel(handles.figDescent, 'V (m/s)');
ylabel(handles.figClimb, 'Max Rate of Climb (m/s)'); 
ylabel(handles.figDescent, 'Max Sink Rate (m/s)');
ylim(handles.figClimb, [0, maxRC]); ylim(handles.figDescent, [0, maxRD]);
xlim(handles.figClimb, [V(1) V(length(V))]);

%-- calculate turning performance

[rho temp] = fnAtmosphere(hCruise, DISA);
g = clDefaults.g;
[Rmin n_max] = fnCalcTurnPerformance(W, S, AR, V, e, rho, g, hCruise, temp, ...
    CD0, CLmax, ANF_DATA.Propulsion);
cla(handles.figTurn, 'reset');

% find out the 1G turning limits (stall limit and thrust limit)
% there's no catch statement, by design
try
    ix = find(n_max>=0.95);
    i0 = ix(1);
    i1 = ix(length(ix));

    h_ax = plotyy(handles.figTurn, V(i0:i1), Rmin(i0:i1), V(i0:i1), n_max(i0:i1));

    % cruise values
    hold(h_ax(1), 'on'); hold(h_ax(2), 'on');
    [Rmin_e n_max_e] = fnCalcTurnPerformance(W, S, AR, Ve, e, rho, g, ...
        hCruise, temp, CD0, CLmax, ANF_DATA.Propulsion);
    plot(h_ax(1), Ve, Rmin_e, 'gs', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    plot(h_ax(2), Ve, n_max_e, 'gs', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
    hold(h_ax(1), 'off'); hold(h_ax(2), 'off');

    ylabel(h_ax(1), 'Minimum Turn Radius (m)');
    ylabel(h_ax(2), 'Max Steady Turn Load Factor');
    xlabel(handles.figTurn, 'V (m/s)');
    xlim(h_ax(1), [V(i0) V(i1)]);
    xlim(h_ax(2), [V(i0) V(i1)]);
    ylim(h_ax(1), [0, 100]);
    ylim(h_ax(2), [1, ceil(max(n_max))]);
    set(h_ax(1),'YTick', 0:20:100, 'XTick', 0:2:50)
    set(h_ax(2),'YTick', 1:0.5:4, 'XTick', 0:2:50);
    grid(h_ax(1)); grid(h_ax(2));
    
    % redo the limit on the climb fig
    xlim(handles.figClimb, [V(i0) V(i1)]);
end

%-- calculate range and endurance

[rho temp] = fnAtmosphere(hCruise, DISA); 
try
    [R tE] = fnCalcEndurance(Ve, W, hCruise, temp, rho, g, CD0, e, AR, S, ...
        ANF_DATA.Propulsion);
    
    set(handles.txtRange, 'String', sprintf('%1.2f', R));
    set(handles.txtEndurance, 'String', sprintf('%1.1f', tE));
catch EX
    set(handles.txtRange, 'String', sprintf('%1.2f', 0));
    set(handles.txtEndurance, 'String', sprintf('%1.1f', 0));
end

%-- calculate takeoff and landing distances

[rho temp] = fnAtmosphere(hRunway, DISA);
CDg = CDi_g + CD0;
Sg_to = fnCalcTakeOffDistance(W, S, CLg, CLag, CLmax, CDg, jig_theta, ...
    AoAg/180*pi, rotation_alpha/180*pi, mu_tire, rho, g, hRunway, temp, ...
    ANF_DATA.Propulsion);
Sg_l = fnCalcLandingDistance(W, S, CLg, CLag, CLmax, CDg, jig_theta, ...
    AoAg/180*pi, flare_alpha/180*pi, mu_brake, rho, g);
set(handles.txtTakeoffDist, 'String', sprintf('%1.2f',Sg_to));
set(handles.txtLandingDist, 'String', sprintf('%1.2f',Sg_l));

% set warning label off
set(handles.lblChanged, 'Visible', 'off');


% --- Executes on button press in cmdRefresh.
function cmdRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateCalcs(handles);



function txtRange_Callback(hObject, eventdata, handles)
% hObject    handle to txtRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRange as text
%        str2double(get(hObject,'String')) returns contents of txtRange as a double


% --- Executes during object creation, after setting all properties.
function txtRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtEndurance_Callback(hObject, eventdata, handles)
% hObject    handle to txtEndurance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtEndurance as text
%        str2double(get(hObject,'String')) returns contents of txtEndurance as a double


% --- Executes during object creation, after setting all properties.
function txtEndurance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtEndurance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
