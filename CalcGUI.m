function varargout = CalcGUI(varargin)
% CALCGUI MATLAB code for CalcGUI.fig
%      CALCGUI, by itself, creates a new CALCGUI or raises the existing
%      singleton*.
%
%      H = CALCGUI returns the handle to a new CALCGUI or the handle to
%      the existing singleton*.
%
%      CALCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCGUI.M with the given input arguments.
%
%      CALCGUI('Property','Value',...) creates a new CALCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalcGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalcGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalcGUI

% Last Modified by GUIDE v2.5 10-Mar-2018 10:40:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalcGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CalcGUI_OutputFcn, ...
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


function content = ValidateOrZero(hObject)
content = str2double(get(hObject, 'String'));
if isnan(content)
    content = 0;
    set(hObject,'String',content);
elseif content < 0
    content = -content;
    set(hObject,'String',content);
end


function Update(handles)
unit = get(handles.mnuUnits, 'Value') - 1;

% Default take delta (pressure ratio)
delta = str2double(get(handles.txtDelta, 'String'));
h = fnAcalcPresAlt(delta, unit); set(handles.txtH, 'String', sprintf('%.2f',h));
P = fnAcalcStaticPres(delta, unit); set(handles.txtP, 'String', sprintf('%.2f',P));

% Take last temp change
if strcmp(get(handles.txtLastTemp,'String'), 'DISA')
    DISA = str2double(get(handles.txtDISA, 'String'));
    theta = fnAcalcTheta(delta, DISA);
else
    OAT = str2double(get(handles.txtOAT, 'String'));
    DISA = fnAcalcOAT2DISA(OAT, delta);
    theta = fnAcalcTheta(delta, DISA);
end
set(handles.txtTheta, 'String', sprintf('%.5f',theta));
[DISA, OAT] = fnAcalcTemperature(theta, delta);
set(handles.txtDISA, 'String', sprintf('%.3f',DISA));
set(handles.txtOAT, 'String', sprintf('%.3f',OAT));

% Density
sigma = fnAcalcSigma(delta, theta); set(handles.txtSigma, 'String', sprintf('%.5f',sigma));
rho = fnAcalcDensity(sigma, unit); set(handles.txtRho, 'String', sprintf('%.5f',rho));

% Take last speed change
if strcmp(get(handles.txtLastSpeed,'String'), 'CAS')
    CAS = str2double(get(handles.txtCAS, 'String'));
    q = fnAcalcCAS2DynPres(CAS, delta, unit);
elseif strcmp(get(handles.txtLastSpeed,'String'), 'EAS')
    EAS = str2double(get(handles.txtEAS, 'String'));
    q = fnAcalcEAS2DynPres(EAS, unit);
elseif strcmp(get(handles.txtLastSpeed,'String'), 'TAS')
    TAS = str2double(get(handles.txtTAS, 'String'));
    q = fnAcalcTAS2DynPres(TAS, sigma, unit);
else
    % Mach
    Mach = str2double(get(handles.txtMach, 'String'));
    q = fnAcalcMach2DynPres(Mach, delta, unit);
end
set(handles.txtQ, 'String', sprintf('%.2f',q));
EAS = fnAcalcDynPres2EAS(q, unit); set(handles.txtEAS, 'String', sprintf('%.2f',EAS));
TAS = fnAcalcDynPres2TAS(q, sigma, unit); set(handles.txtTAS, 'String', sprintf('%.2f',TAS));
Mach = fnAcalcDynPres2Mach(q, delta, unit); set(handles.txtMach, 'String', sprintf('%.4f',Mach));
qc = fnAcalcDynPres2ImpactPres(q, delta, unit); set(handles.txtQc, 'String', sprintf('%.2f',qc));
a = fnAcalcSpeedOfSound(theta, unit); set(handles.txtA, 'String', sprintf('%.2f',a));
CAS = fnAcalcImpactPres2CAS(qc, unit); set(handles.txtCAS, 'String', sprintf('%.2f',CAS));
Pt = fnAcalcTotalPres(P, qc); set(handles.txtPt, 'String', sprintf('%.2f',Pt));

% Viscosity
mu = fnAcalcMu(theta, unit); set(handles.txtMu, 'String', sprintf('%.4e',mu));
nu = fnAcalcNu(delta, theta, unit); set(handles.txtNu, 'String', sprintf('%.4e',nu));


% --- Executes just before CalcGUI is made visible.
function CalcGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalcGUI (see VARARGIN)

% Choose default command line output for CalcGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initial values
mnuUnits_Callback(handles.mnuUnits, eventdata, handles);
Update(handles)

% UIWAIT makes CalcGUI wait for user response (see UIRESUME)
% uiwait(handles.CalcGUI);


% --- Outputs from this function are returned to the command line.
function varargout = CalcGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function txtCAS_Callback(hObject, eventdata, handles)
% hObject    handle to txtCAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCAS as text
%        str2double(get(hObject,'String')) returns contents of txtCAS as a double
ValidateOrZero(hObject);
set(handles.txtLastSpeed,'String','CAS');
Update(handles);


% --- Executes during object creation, after setting all properties.
function txtCAS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse motion over figure - except title and menu.
function CalcGUI_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to CalcGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function txtEAS_Callback(hObject, eventdata, handles)
% hObject    handle to txtEAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtEAS as text
%        str2double(get(hObject,'String')) returns contents of txtEAS as a double
ValidateOrZero(hObject);
set(handles.txtLastSpeed,'String','EAS');
Update(handles);

% --- Executes during object creation, after setting all properties.
function txtEAS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtEAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtTAS_Callback(hObject, eventdata, handles)
% hObject    handle to txtTAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTAS as text
%        str2double(get(hObject,'String')) returns contents of txtTAS as a double
ValidateOrZero(hObject);
set(handles.txtLastSpeed,'String','TAS');
Update(handles);

% --- Executes during object creation, after setting all properties.
function txtTAS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtA_Callback(hObject, eventdata, handles)
% hObject    handle to txtA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtA as text
%        str2double(get(hObject,'String')) returns contents of txtA as a double


% --- Executes during object creation, after setting all properties.
function txtA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtA (see GCBO)
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



function txtNu_Callback(hObject, eventdata, handles)
% hObject    handle to txtNu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNu as text
%        str2double(get(hObject,'String')) returns contents of txtNu as a double


% --- Executes during object creation, after setting all properties.
function txtNu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtMach_Callback(hObject, eventdata, handles)
% hObject    handle to txtMach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMach as text
%        str2double(get(hObject,'String')) returns contents of txtMach as a double
ValidateOrZero(hObject);
set(handles.txtLastSpeed,'String','Mach');
Update(handles);


% --- Executes during object creation, after setting all properties.
function txtMach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRho_Callback(hObject, eventdata, handles)
% hObject    handle to txtRho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRho as text
%        str2double(get(hObject,'String')) returns contents of txtRho as a double


% --- Executes during object creation, after setting all properties.
function txtRho_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSigma_Callback(hObject, eventdata, handles)
% hObject    handle to txtSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSigma as text
%        str2double(get(hObject,'String')) returns contents of txtSigma as a double


% --- Executes during object creation, after setting all properties.
function txtSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSigma (see GCBO)
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
ValidateOrZero(hObject);
set(handles.txtLastTemp, 'String', 'DISA');
Update(handles);


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



function txtOAT_Callback(hObject, eventdata, handles)
% hObject    handle to txtOAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtOAT as text
%        str2double(get(hObject,'String')) returns contents of txtOAT as a double
ValidateOrZero(hObject);
set(handles.txtLastTemp, 'String', 'OAT');
Update(handles);

% --- Executes during object creation, after setting all properties.
function txtOAT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtOAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtTheta_Callback(hObject, eventdata, handles)
% hObject    handle to txtTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTheta as text
%        str2double(get(hObject,'String')) returns contents of txtTheta as a double


% --- Executes during object creation, after setting all properties.
function txtTheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtH_Callback(hObject, eventdata, handles)
% hObject    handle to txtH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtH as text
%        str2double(get(hObject,'String')) returns contents of txtH as a double
h = ValidateOrZero(hObject);
unit = get(handles.mnuUnits, 'Value') - 1;
if unit==1
    % Convert to ft
    h = h*3.28084;
end
delta = fnAcalcDelta(h);
set(handles.txtDelta,'String',sprintf('%.5f', delta));

Update(handles);


% --- Executes during object creation, after setting all properties.
function txtH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtDelta_Callback(hObject, eventdata, handles)
% hObject    handle to txtDelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDelta as text
%        str2double(get(hObject,'String')) returns contents of txtDelta as a double


% --- Executes during object creation, after setting all properties.
function txtDelta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtP_Callback(hObject, eventdata, handles)
% hObject    handle to txtP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtP as text
%        str2double(get(hObject,'String')) returns contents of txtP as a double


% --- Executes during object creation, after setting all properties.
function txtP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtQ_Callback(hObject, eventdata, handles)
% hObject    handle to txtQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtQ as text
%        str2double(get(hObject,'String')) returns contents of txtQ as a double


% --- Executes during object creation, after setting all properties.
function txtQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtQc_Callback(hObject, eventdata, handles)
% hObject    handle to txtQc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtQc as text
%        str2double(get(hObject,'String')) returns contents of txtQc as a double


% --- Executes during object creation, after setting all properties.
function txtQc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtQc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtPt_Callback(hObject, eventdata, handles)
% hObject    handle to txtPt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPt as text
%        str2double(get(hObject,'String')) returns contents of txtPt as a double


% --- Executes during object creation, after setting all properties.
function txtPt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuUnits.
function mnuUnits_Callback(hObject, eventdata, handles)
% hObject    handle to mnuUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuUnits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuUnits
unit = get(hObject,'Value') - 1;
if unit == 0
    set(handles.lblCAS, 'String', 'kts');
    set(handles.lblEAS, 'String', 'kts');
    set(handles.lblTAS, 'String', 'kts');
    set(handles.lblA, 'String', 'kts');
    set(handles.lblRho, 'String', 'slug/ft^3');
    set(handles.lblH, 'String', 'ft');
    set(handles.lblP, 'String', 'lb/ft^2');
    set(handles.lblPt, 'String', 'lb/ft^2');
    set(handles.lblQ, 'String', 'lb/ft^2');
    set(handles.lblQc, 'String', 'lb/ft^2');
    set(handles.lblMu, 'String', 'slug/ft/s');
    set(handles.lblNu, 'String', 'ft^2/s');
else
    set(handles.lblCAS, 'String', 'm/s');
    set(handles.lblEAS, 'String', 'm/s');
    set(handles.lblTAS, 'String', 'm/s');
    set(handles.lblA, 'String', 'm/s');
    set(handles.lblRho, 'String', 'kg/m^3');
    set(handles.lblH, 'String', 'm');
    set(handles.lblP, 'String', 'N/m^2');
    set(handles.lblPt, 'String', 'N/m^2');
    set(handles.lblQ, 'String', 'N/m^2');
    set(handles.lblQc, 'String', 'N/m^2');
    set(handles.lblMu, 'String', 'Pa*s');
    set(handles.lblNu, 'String', 'm^2/s');
end

% Change the relevant values
% Speed
if strcmp(get(handles.txtLastSpeed,'String'), 'CAS')
    CAS = str2double(get(handles.txtCAS,'String'));
    if unit==0
        CAS = CAS*1.94384;
    else
        CAS = CAS/1.94384;
    end
    set(handles.txtCAS,'String',CAS);
elseif strcmp(get(handles.txtLastSpeed,'String'), 'EAS')
    EAS = str2double(get(handles.txtEAS,'String'));
    if unit==0
        EAS = EAS*1.94384;
    else
        EAS = EAS/1.94384;
    end
    set(handles.txtEAS,'String',EAS);
elseif strcmp(get(handles.txtLastSpeed,'String'), 'TAS')
    TAS = str2double(get(handles.txtTAS,'String'));
    if unit==0
        TAS = TAS*1.94384;
    else
        TAS = TAS/1.94384;
    end
    set(handles.txtTAS,'String',TAS);
end
% Alt
h = str2double(get(handles.txtH,'String'));
if unit==0
    h = h*3.28084;
else
    h = h/3.28084;
end
set(handles.txtH,'String',h);

Update(handles);


% --- Executes during object creation, after setting all properties.
function mnuUnits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtLastSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to txtLastSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLastSpeed as text
%        str2double(get(hObject,'String')) returns contents of txtLastSpeed as a double


% --- Executes during object creation, after setting all properties.
function txtLastSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLastSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtLastTemp_Callback(hObject, eventdata, handles)
% hObject    handle to txtLastTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLastTemp as text
%        str2double(get(hObject,'String')) returns contents of txtLastTemp as a double


% --- Executes during object creation, after setting all properties.
function txtLastTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLastTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
