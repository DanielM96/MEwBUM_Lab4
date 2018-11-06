function varargout = GUI_PropellerBlade(varargin)
% GUI_PROPELLERBLADE MATLAB code for GUI_PropellerBlade.fig
%      GUI_PROPELLERBLADE, by itself, creates a new GUI_PROPELLERBLADE or raises the existing
%      singleton*.
%
%      H = GUI_PROPELLERBLADE returns the handle to a new GUI_PROPELLERBLADE or the handle to
%      the existing singleton*.
%
%      GUI_PROPELLERBLADE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROPELLERBLADE.M with the given input arguments.
%
%      GUI_PROPELLERBLADE('Property','Value',...) creates a new GUI_PROPELLERBLADE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PropellerBlade_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PropellerBlade_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PropellerBlade

% Last Modified by GUIDE v2.5 06-Nov-2018 07:17:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PropellerBlade_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PropellerBlade_OutputFcn, ...
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


% --- Executes just before GUI_PropellerBlade is made visible.
function GUI_PropellerBlade_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PropellerBlade (see VARARGIN)

% Choose default command line output for GUI_PropellerBlade
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PropellerBlade wait for user response (see UIRESUME)
% uiwait(handles.figure1);
evalin('base','clear; clc');
% import plików z danymi
global frfData rawData hammerData selectedPoint isPointSelected;
tic;

% Uzyskane FRF
[ data1, data2, data3 ] = importFRFData('s123.unv');
[ data4, data5, data6 ] = importFRFData('s456.unv');
[ data7, data8, data9 ] = importFRFData('s789.unv');
frfData = { data1 data2 data3 data4 data5 data6 data7 data8 data9 };

% Surowe dane
[ hammer1, data1, data2, data3 ] = importRawData('r123.unv');
[ hammer2, data4, data5, data6 ] = importRawData('r456.unv');
[ hammer3, data7, data8, data9 ] = importRawData('r789.unv');
rawData = { data1 data2 data3 data4 data5 data6 data7 data8 data9 };
hammerData = { hammer1 hammer1 hammer1 hammer2 hammer2 hammer2 hammer3 hammer3 hammer3 };
loadTime = toc;
statusBar = sprintf('Wczytano dane (%.2f s).',loadTime);
set(handles.text2_status,'String',statusBar);
selectedPoint = 1;
isPointSelected = false;

% --- Outputs from this function are returned to the command line.
function varargout = GUI_PropellerBlade_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Menu_CalculateFRF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_CalculateFRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Matlab_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
statusBar = sprintf('Otwiera pomoc œrodowiska MATLAB.');
set(handles.text2_status,'String',statusBar);
doc;

% --------------------------------------------------------------------
function Help_About_Callback(hObject, eventdata, handles)
% hObject    handle to Help_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
statusBar = sprintf('Otwiera informacje o tym GUI.');
set(handles.text2_status,'String',statusBar);
msgbox({'GUI_PropellerBlade','','Funkcje:','',...
    '- wyœwietlanie otrzymanej FRF i porównywanie jej z uzyskan¹ za pomoc¹ estymaty H1,',...
    '- porównywanie otrzymanej FRF z obliczonymi przy u¿yciu estymatorów H1 i H2 (tfestimate).'},...
    'GUI_PropellerBlade - informacje','help');


% --------------------------------------------------------------------
function Analysis_h1_h2_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis_h1_h2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedPoint currentRaw hammerInput isPointSelected;
if ~isPointSelected
    msgbox('Aby porównaæ wyniki z u¿yciem estymatorów H1 i H2, najpierw wyœwietl je tutaj.','B³¹d','warn');
else
    assignin('base','selectedPoint',selectedPoint);
    assignin('base','currentRaw',currentRaw);
    assignin('base','hammerInput',hammerInput);
    GUI_EstimationContainer;
end


% --- Executes on button press in pushbutton1_exit.
function pushbutton1_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);


% --- Executes on selection change in popupmenu1_points.
function popupmenu1_points_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1_points contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1_points
global selectedPoint;
selectedPoint = get(hObject,'Value');
statusBar = sprintf('Wybrano punkt pomiarowy %d.',selectedPoint);
set(handles.text2_status,'String',statusBar);

% --- Executes during object creation, after setting all properties.
function popupmenu1_points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2_draw.
function pushbutton2_draw_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedPoint frfData rawData hammerData isPointSelected currentRaw hammerInput;
isPointSelected = true;
currentFRF = frfData{selectedPoint};
currentRaw = rawData{selectedPoint};
hammerInput = hammerData{selectedPoint};

% wykresy
% FRF otrzymana z danych
axes(handles.axes1_frf);
semilogy(0:1025,abs(currentFRF));
xlabel('Czêstotliwoœæ [Hz]');
ylabel('Amplituda [dB]');
xlim([ 0 512 ]);
zoom on;
grid on;
title([ 'FRF otrzymana dla punktu ',num2str(selectedPoint) ]);

% faza otrzymana z danych
axes(handles.axes4_phase);
plot(angle(currentFRF));
title([ 'Faza otrzymana dla punktu ',num2str(selectedPoint) ]);
xlabel('Czêstotliwoœæ [Hz]');
ylabel('K¹t fazowy [rad]');
xlim([ 0 512 ]);
ylim([ -pi pi ]);
zoom on;
grid on;

% FRF obliczona z danych surowych
axes(handles.axes2_raw);
% tfestimate(hammerInput,currentRaw,[],[],[],1025);
[ H, coh, f ] = frfestimator(hammerInput,currentRaw,2050,'H1');
semilogy(f,abs(H));
zoom on;
grid on;
xlabel('Czêstotliwoœæ [Hz]');
ylabel('Amplituda [dB]');
xlim([ 0 512 ]);
% Zapisz dla wykresu fazowego
% Txy = tfestimate(hammerInput,currentRaw,[],[],[],1025);
title([ 'FRF obliczona z danych surowych dla punktu ',num2str(selectedPoint) ]);

% faza FRF z danych surowych
axes(handles.axes3_phase_raw);
plot(f,angle(H));
xlim([ 0 512 ]);
ylim([ -pi pi ]);
zoom on;
grid on;
title([ 'Faza obliczona z danych surowych dla punktu ',num2str(selectedPoint) ]);
xlabel('Czêstotliwoœæ [Hz]');
ylabel('K¹t fazowy [rad]');

statusBar = sprintf('Wygenerowano wykresy dla punktu pomiarowego %d.',selectedPoint);
set(handles.text2_status,'String',statusBar);
