function varargout = MainGUI(varargin)
% MAINGUI M-file for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 19-Mar-2018 21:55:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
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

% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.MainGUI);

% initialize variables
mIncludePaths;
clear_data();

% reset these global variables to the default state
function clear_data()
global ANF_DATA ANF_RESULTS_GROUND ANF_RESULTS_AIR;
ANF_DATA = []; ANF_DATA.Directory = './Proj/';
ANF_RESULTS_GROUND = []; ANF_RESULTS_GROUND.NeedUpdate = 1;
ANF_RESULTS_AIR = []; ANF_RESULTS_AIR.NeedUpdate = 1;

% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function density_Callback(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of density as text
%        str2double(get(hObject,'String')) returns contents of density as a double
density = str2double(get(hObject, 'String'));
if isnan(density)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.density = density;
guidata(hObject,handles)

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)

% Update handles structure
guidata(handles.MainGUI, handles);


function Geometry_Callback(hObject,eventdata,handles)
GeometryGUI;

function Mass_Callback(hObject,eventdata,handles)
MassGUI;


% --- Executes during object deletion, before destroying properties.
function me_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to MainGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in New.
function New_Callback(hObject, eventdata, handles)
% hObject    handle to New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.FilePanel, 'Title', 'Project Loaded: NEW');
clear_data();


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
[FileName,PathName] = uigetfile('*.anf', 'Load Aircraft Analyzer Project', ...
    ANF_DATA.Directory);

if FileName==0
    % user has clicked cancel
    return;
end

clear_data();

fid = fopen([PathName, FileName], 'r');

tline = fgets(fid);
counter = 0;
category = '';
while ischar(tline)
    tline = strtrim(tline);

    if counter==0 && ~strcmp(tline, 'Aircraft Analyzer File')
        % check for file header to make sure it's the right file
        break;
    elseif strcmp(tline, '')
        % skip empty line
        continue;
    else
        % start parsing data to workspace
        token = textscan(tline, '%s%s', 'Delimiter', '=');
        if isempty(token{2})
            % this is a category
            category = strtrim(token{1}{1});
        else
            try
                value = textscan(token{2}{1}, '%f', 'Delimiter', ',', 'CollectOutput', 1, 'ReturnOnError', 0);
                ANF_DATA.(category).(strtrim(token{1}{1})) = value{1};
            catch Ex
                % it's a string
                ANF_DATA.(category).(strtrim(token{1}{1})) = strtrim(token{2}{1});
            end
        end
    end
    
    % get next line
    tline = fgets(fid);
    counter = counter + 1;
end

fclose(fid);
ANF_DATA.Directory = PathName;

% mark the file as loaded
set(handles.FilePanel, 'Title', ['Project Loaded: ', FileName]);

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ANF_DATA;
[FileName,PathName] = uiputfile('*.anf', 'Save Aircraft Analyzer Project', ...
    ANF_DATA.Directory);

if FileName==0
    return;
end

fid = fopen([PathName, FileName], 'w');

fprintf(fid, 'Aircraft Analyzer File\n');
recurSave(fid, ANF_DATA);

fclose(fid);

% write additional data to memory
ANF_DATA.Directory = PathName;
set(handles.FilePanel, 'Title', ['Project Loaded: ', FileName]);

% recursively go through the data structure and save each parameter
function recurSave(fid, data)
fields = fieldnames(data);
for i = 1:numel(fields)
    fieldname = fields{i};
    if strcmp(fieldname, 'Directory')
        % skip these special fields
        continue;
    end

    if isstruct(data.(fieldname))
        % print out field name
        fprintf(fid, [fieldname '\n']);
        % delve into this field
        recurSave(fid, data.(fieldname));
    else
        str = data.(fieldname);
        
        if isnumeric(str)
            % convert vector to string format, and do some massaging
            str = mat2str(str);
            str = strrep(str, ';', ', ');
            str = strrep(str, '[', '');
            str = strrep(str, ']', '');
        end
        
        fprintf(fid, sprintf('%s = %s\n', fieldname, str));
    end
end
    

% --- Executes on button press in Propulsion.
function Propulsion_Callback(hObject, eventdata, handles)
% hObject    handle to Propulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PropulsionGUI;

% --- Executes on button press in Performance.
function Performance_Callback(hObject, eventdata, handles)
% hObject    handle to Performance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PerformanceGUI;

% --- Executes on button press in SnC.
function SnC_Callback(hObject, eventdata, handles)
% hObject    handle to SnC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SnCGUI;

% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RunGUI;


% --- Executes when user attempts to close MainGUI.
function MainGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MainGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% confirmation for closing
res = questdlg('Confirm to exit Aircraft Analyzer? Any change to the project will be discarded',...
    'Confirm to Close','Yes','No', 'Yes');
if strcmp(res, 'Yes')
    delete(hObject);
    close all;
end


% --- Executes on button press in cmdGroundHandling.
function cmdGroundHandling_Callback(hObject, eventdata, handles)
% hObject    handle to cmdGroundHandling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GroundHandlingGUI;


% --- Executes on button press in cmdCalculator.
function cmdCalculator_Callback(hObject, eventdata, handles)
% hObject    handle to cmdCalculator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CalcGUI;


% --- Executes on button press in btnConditions.
function btnConditions_Callback(hObject, eventdata, handles)
% hObject    handle to btnConditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AirGUI;
