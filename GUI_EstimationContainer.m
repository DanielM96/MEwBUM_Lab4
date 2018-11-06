function varargout = GUI_EstimationContainer(varargin)
% GUI_ESTIMATIONCONTAINER MATLAB code for GUI_EstimationContainer.fig
%      GUI_ESTIMATIONCONTAINER, by itself, creates a new GUI_ESTIMATIONCONTAINER or raises the existing
%      singleton*.
%
%      H = GUI_ESTIMATIONCONTAINER returns the handle to a new GUI_ESTIMATIONCONTAINER or the handle to
%      the existing singleton*.
%
%      GUI_ESTIMATIONCONTAINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ESTIMATIONCONTAINER.M with the given input arguments.
%
%      GUI_ESTIMATIONCONTAINER('Property','Value',...) creates a new GUI_ESTIMATIONCONTAINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_EstimationContainer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_EstimationContainer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_EstimationContainer

% Last Modified by GUIDE v2.5 05-Nov-2018 20:53:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_EstimationContainer_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_EstimationContainer_OutputFcn, ...
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


% --- Executes just before GUI_EstimationContainer is made visible.
function GUI_EstimationContainer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_EstimationContainer (see VARARGIN)

% Choose default command line output for GUI_EstimationContainer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_EstimationContainer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global currentRaw hammerInput selectedPoint selectedEstimator;
isRaw = evalin('base','exist(''currentRaw'',''var'') == 1');
isHammer = evalin('base','exist(''hammerInput'',''var'') == 1');
isPoint = evalin('base','exist(''selectedPoint'',''var'') == 1');

isOk = isRaw && isHammer && isPoint;
if ~isOk
    msgbox('To GUI mo¿na uruchomiæ tylko z poziomu GUI_PropellerBlade.','B³¹d','warn');
    delete(handles.figure1);
else
    currentRaw = evalin('base','currentRaw');
    hammerInput = evalin('base','hammerInput');
    selectedPoint = evalin('base','selectedPoint');
    selectedEstimator = 'H1';
    statusBar = sprintf('Gotowy do estymacji FRF dla punktu %d z u¿yciem estymatora %s.',selectedPoint,selectedEstimator);
    set(handles.text1_status,'String',statusBar);
end

% --- Outputs from this function are returned to the command line.
function varargout = GUI_EstimationContainer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2_exit.
function pushbutton2_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','clear');
delete(handles.figure1);

% --- Executes on button press in pushbutton1_draw.
function pushbutton1_draw_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedEstimator currentRaw hammerInput selectedPoint;

[ H, coh, f ] = frfestimator(hammerInput,currentRaw,2050,selectedEstimator);
axes(handles.axes1_frf);
% tfestimate(hammerInput,currentRaw,[],[],[],1025,'Est',selectedEstimator);
semilogy(f,abs(H));
grid on;
xlabel('Czêstotliwoœæ [Hz]');
ylabel('Amplituda [dB]');
xlim([ 0 512 ]);
title([ 'FRF dla punktu ',num2str(selectedPoint),' z u¿yciem estymatora ',selectedEstimator ]);
zoom on;

axes(handles.axes2_phase);
% Txy = tfestimate(hammerInput,currentRaw,[],[],[],1025,'Est',selectedEstimator);
plot(angle(H));
xlim([ 0 512 ]);
ylim([ -pi pi ]);
zoom on;
grid on;
title([ 'Faza dla punktu ',num2str(selectedPoint),' z u¿yciem estymatora ',selectedEstimator ]);
xlabel('Czêstotliwoœæ [Hz]');
ylabel('K¹t fazowy [rad]');

statusBar = sprintf('Wygenerowano wykresy dla punktu pomiarowego %d z u¿yciem estymatora %s.',selectedPoint,selectedEstimator);
set(handles.text1_status,'String',statusBar);

% --- Executes when selected object is changed in uibuttongroup1_est.
function uibuttongroup1_est_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1_est 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedEstimator selectedPoint;
switch eventdata.NewValue
    case handles.radiobutton1_h1
        selectedEstimator = 'H1';
        
    case handles.radiobutton2_h2
        selectedEstimator = 'H2';
        
    case handles.radiobutton3_hv
        selectedEstimator = 'Hv';
end
statusBar = sprintf('Wybrano estymator %s.',selectedEstimator);
set(handles.text1_status,'String',statusBar);
pause(0.25);
statusBar = sprintf('Gotowy do estymacji FRF dla punktu %d z u¿yciem estymatora %s.',selectedPoint,selectedEstimator);
set(handles.text1_status,'String',statusBar);
