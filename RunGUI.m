function varargout = RunGUI(varargin)
% RUNGUI MATLAB code for RunGUI.fig
%      RUNGUI, by itself, creates a new RUNGUI or raises the existing
%      singleton*.
%
%      H = RUNGUI returns the handle to a new RUNGUI or the handle to
%      the existing singleton*.
%
%      RUNGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNGUI.M with the given input arguments.
%
%      RUNGUI('Property','Value',...) creates a new RUNGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RunGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RunGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RunGUI

% Last Modified by GUIDE v2.5 15-Mar-2014 15:06:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RunGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RunGUI_OutputFcn, ...
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


% --- Executes just before RunGUI is made visible.
function RunGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RunGUI (see VARARGIN)

% Choose default command line output for RunGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RunGUI wait for user response (see UIRESUME)
% uiwait(handles.RunGUI);

global ANF_DATA sec_elapsed;
sec_elapsed = 0;

ANF_DATA.Setup.run_HM = 0;

updateAeroFig(handles);


function timerCallback(obj, event, handles)
global sec_elapsed;

if sec_elapsed >= 0
    sec_elapsed = sec_elapsed + 1;

    % update gui
    sec = mod(sec_elapsed, 60);
    min = floor(sec_elapsed/60);
    set(handles.txtTime, 'String', sprintf('%02i:%02i', min, sec));
    drawnow
else
    stop(obj);
    delete(obj);
end

% --- Outputs from this function are returned to the command line.
function varargout = RunGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lstStatus.
function lstStatus_Callback(hObject, eventdata, handles)
% hObject    handle to lstStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstStatus contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstStatus


% --- Executes during object creation, after setting all properties.
function lstStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cmdAbort.
function cmdAbort_Callback(hObject, eventdata, handles)
% hObject    handle to cmdAbort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sec_elapsed ANF_DATA ANF_RESULTS_AIR ANF_RESULTS_GROUND ANF_RESULTS_HM;

if sec_elapsed == 0
    %-- run
    
    set(hObject, 'String', 'Abort');
    
    t = timer('Period', 1.0, 'ExecutionMode', 'fixedDelay', 'StartDelay', 1.0);
    t.TimerFcn = {@timerCallback, handles};
    start(t);
    
    addStatus(handles, 'Analysis started');
    
    % check for geometry
    try
        formatted_wing_data = fnParseWingData(ANF_DATA.Geometry);
        
        W = fnCalcCG(ANF_DATA);
        S = fnCalcPlanformArea(formatted_wing_data);
    catch ME
        addStatus(handles, 'Aircraft definition incomplete.');
        killAnalysis(handles);
    end
    
    % check for air data/flight conditions
    try
        DISA = ANF_DATA.Air.DISA;
        hRunway = ANF_DATA.Air.runway_alt;
        hCruise = hRunway + ANF_DATA.Air.cruise_height;
        rho = fnAtmosphere(hCruise, DISA);
        Ve = ANF_DATA.Air.cruise_speed;
        CL = W/(1/2*rho*Ve^2*S);
    catch ME
        addStatus(handles, 'Flight conditions definition incomplete.');
        killAnalysis(handles);
    end
    
    % execute main code
    if isvalid(t) && sec_elapsed>=0
        addStatus(handles, 'Running in-air aerodynamics...');
        try
            ANF_RESULTS_AIR = fnRunAVL(ANF_DATA.Directory, 0, CL, 0, 0, 0, ANF_DATA);
            updateAeroFig(handles);
        catch ME
            addStatus(handles, [ME.identifier ': ' ME.message])
            killAnalysis(handles);
        end
    end
    
    if isvalid(t) && sec_elapsed>=0
        addStatus(handles, 'Running ground effect aerodynamics...');
        try
            ANF_RESULTS_GROUND = fnRunAVL(ANF_DATA.Directory, 1, CL, 0, 0, 0, ANF_DATA);
            updateAeroFig(handles);
        catch ME
            addStatus(handles, [ME.identifier ': ' ME.message])
            killAnalysis(handles);
        end
    end
    
    ANF_RESULTS_HM = [];
    if isvalid(t) && sec_elapsed>=0 && ANF_DATA.Setup.run_HM
        addStatus(handles, 'Running hinge moment cases...');
        
        if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'max_elev')
            ANF_DATA.Interaction.max_elev = clDefaults.Interaction_max_elev;
        end
        if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'max_rud')
            ANF_DATA.Interaction.max_rud = clDefaults.Interaction_max_rud;
        end
        if ~isfield(ANF_DATA, 'Interaction') || ~isfield(ANF_DATA.Interaction, 'max_aileron')
            ANF_DATA.Interaction.max_aileron = clDefaults.Interaction_max_ail;
        end
        
        try
            AVLResults = fnRunAVL(ANF_DATA.Directory, 0, CL, ...
                ANF_DATA.Interaction.max_elev/180*pi, 0, 0, ANF_DATA);
            ANF_RESULTS_HM.elev_dn = AVLResults.hm_elev;
            
            AVLResults = fnRunAVL(ANF_DATA.Directory, 0, CL, ...
                -ANF_DATA.Interaction.max_elev/180*pi, 0, 0, ANF_DATA);
            ANF_RESULTS_HM.elev_up = AVLResults.hm_elev;
            
            AVLResults = fnRunAVL(ANF_DATA.Directory, 0, CL, ...
                0, ANF_DATA.Interaction.max_ail/180*pi, 0, ANF_DATA);
            ANF_RESULTS_HM.ail_dn = AVLResults.hm_ail;
            
            AVLResults = fnRunAVL(ANF_DATA.Directory, 0, CL, ...
                0, -ANF_DATA.Interaction.max_ail/180*pi, 0, ANF_DATA);
            ANF_RESULTS_HM.ail_up = AVLResults.hm_ail;
            
            % vtail is symmetric (should be symmetric)
            AVLResults = fnRunAVL(ANF_DATA.Directory, 0, CL, ...
                0, 0, ANF_DATA.Interaction.max_rud/180*pi, ANF_DATA);
            ANF_RESULTS_HM.rud = AVLResults.hm_rud;
        catch ME
            addStatus(handles, [ME.identifier ': ' ME.message])
            killAnalysis(handles);
        end
    end
    
    addStatus(handles, 'Analysis finished');
    
    %-- finished execution

    % destroy timer object normally
    if isvalid(t)
        stop(t);
        delete(t);
    end
    
    resetGUI(handles);
else
    % abort
    killAnalysis(handles);
end

function addStatus(handles, msg)
status = get(handles.lstStatus, 'String');
status{numel(status)+1} = msg;
set(handles.lstStatus, 'String', status);


function resetGUI(handles)
global sec_elapsed;
sec_elapsed = 0;
set(handles.cmdAbort, 'String', 'Run');

function killAnalysis(handles)
global sec_elapsed;
sec_elapsed = -100;

status = get(handles.lstStatus, 'String');
status{numel(status)+1} = 'Interrupting analysis...';
set(handles.lstStatus, 'String', status);


function txtTime_Callback(hObject, eventdata, handles)
% hObject    handle to txtTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTime as text
%        str2double(get(hObject,'String')) returns contents of txtTime as a double


% --- Executes during object creation, after setting all properties.
function txtTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function RunGUI_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to RunGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global time_elapsed;
killAnalysis(handles);
clear time_elapsed;


function updateAeroFig(handles)

global ANF_RESULTS_AIR ANF_RESULTS_GROUND ANF_DATA;

cla(handles.figAero, 'reset');
hold(handles.figAero, 'on');

if ~ANF_RESULTS_AIR.NeedUpdate
    AoA0 = ANF_RESULTS_AIR.Alpha/180*pi;
    CL0 = ANF_RESULTS_AIR.CL;
    CLa = ANF_RESULTS_AIR.CLa;
    Cm0 = ANF_RESULTS_AIR.Cm;
    Cma = ANF_RESULTS_AIR.Cma;
    
    AoA = -5:0.5:16;
    CL = (AoA/180*pi-AoA0)*CLa + CL0;
    Cm = (AoA/180*pi-AoA0)*Cma + Cm0;
    
    % plot CLmax
    if ~isfield(ANF_DATA, 'Air') || ~isfield(ANF_DATA.Air, 'CL_max')
        ANF_DATA.Air.CL_max = clDefaults.Air_CL_max;
    end
    CLmax = ANF_DATA.Air.CL_max;
    plot([-5 16], [CLmax CLmax], 'LineStyle', '-.', 'Color', 'r', 'LineWidth', 2);
    
    % plot analysis results
    [h_axes l1 l2] = plotyy(AoA, CL, AoA, Cm);
    set(l1, 'LineWidth', 2);
    set(l2, 'LineWidth', 2);
    
    % labeling
    xlabel(handles.figAero, '\alpha (deg)');
    ylabel(h_axes(1), 'CL (\delta_{e}=0)');
    ylabel(h_axes(2), 'Cm (\delta_{e}=0)');
    
    xlim(h_axes(1), [-5 16]); xlim(h_axes(2), [-5 16]);
    ylim(h_axes(1), [0, 2]); ylim(h_axes(2), [-0.25, 0.25]);
    set(h_axes(2),'YTick', -0.4:0.1:0.4);
    
    hold(h_axes(1), 'all'); hold(h_axes(2), 'all');
    
    grid on;
    legend('CL_{max}','CL','Cm');
end

if ~ANF_RESULTS_GROUND.NeedUpdate
    AoA0 = ANF_RESULTS_GROUND.Alpha/180*pi;
    CL0 = ANF_RESULTS_GROUND.CL;
    CLa = ANF_RESULTS_GROUND.CLa;
    Cm0 = ANF_RESULTS_GROUND.Cm;
    Cma = ANF_RESULTS_GROUND.Cma;
    
    AoA = -5:0.5:16;
    CL = (AoA/180*pi-AoA0)*CLa + CL0;
    Cm = (AoA/180*pi-AoA0)*Cma + Cm0;
    
    % plot analysis results
    plot(h_axes(1), AoA, CL, 'b--', 'LineWidth', 2);
    plot(h_axes(2), AoA, Cm, '--', 'Color',[0 0.5 0], 'LineWidth', 2);
    
    xlim(h_axes(1), [-5 16]); xlim(h_axes(2), [-5 16]);
    ylim(h_axes(1), [0, 2]); ylim(h_axes(2), [-0.25, 0.25]);
    set(h_axes(1),'YTick', -1:0.25:3);
    set(h_axes(2),'YTick', -0.4:0.1:0.4);
    
    grid on;
    legend('CL_{max}','CL','CL (Ground)','Cm','Cm (Ground)');
end

hold(handles.figAero, 'off');
