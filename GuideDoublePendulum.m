function varargout = GuideDoublePendulum(varargin)
% GUIDEDOUBLEPENDULUM MATLAB code for GuideDoublePendulum.fig
%      GUIDEDOUBLEPENDULUM, by itself, creates a new GUIDEDOUBLEPENDULUM or raises the existing
%      singleton*.
%
%      H = GUIDEDOUBLEPENDULUM returns the handle to a new GUIDEDOUBLEPENDULUM or the handle to
%      the existing singleton*.
%
%      GUIDEDOUBLEPENDULUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDEDOUBLEPENDULUM.M with the given input arguments.
%
%      GUIDEDOUBLEPENDULUM('Property','Value',...) creates a new GUIDEDOUBLEPENDULUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuideDoublePendulum_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuideDoublePendulum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuideDoublePendulum

% Last Modified by GUIDE v2.5 02-Oct-2017 14:56:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuideDoublePendulum_OpeningFcn, ...
                   'gui_OutputFcn',  @GuideDoublePendulum_OutputFcn, ...
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

% --- Executes just before GuideDoublePendulum is made visible.
function GuideDoublePendulum_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuideDoublePendulum (see VARARGIN)

% Choose default command line output for GuideDoublePendulum
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
global s;
s = serial('COM1');
%Update available comPorts on your computer
set(handles.popPorts,'String',getAvailableComPort);

% UIWAIT makes GuideDoublePendulum wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GuideDoublePendulum_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popPorts.
function popPorts_Callback(hObject, eventdata, handles)
% hObject    handle to popPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popPorts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popPorts


% --- Executes during object creation, after setting all properties.
function popPorts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushexit.
function pushexit_Callback(hObject, eventdata, handles)
% hObject    handle to pushexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in btnconnect.
function btnconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btnconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
%Com ports
portList = get(handles.popPorts,'String');
portIndex = get(handles.popPorts,'Value');
port = portList(portIndex,:);
port = char(port);
s = serial(port);
%Baud rates
brcase = get(handles.popBaudrates,'Value');
switch brcase
    case 1
        set(s,'BaudRate',1200);
    case 2
        set(s,'BaudRate',1800);
    case 3
        set(s,'BaudRate',2400);
    case 4
        set(s,'BaudRate',9600);
    case 5
        set(s,'BaudRate',14400);
    case 6
        set(s,'BaudRate',19200);
    case 7
        set(s,'BaudRate',38400);
    case 8
        set(s,'BaudRate',57600);
    case 9
        set(s,'BaudRate',115200);
    case 10
        set(s,'BaudRate',128000); 
end

s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcnCount = 1;
s.BytesAvailableFcn = {@mycallback, handles};
fopen(s);
% i = 0;
% while( i < 500 )
%     i = i + 1;
%     theta(i) = fscanf(s,'%d');
% %     theta(i) = fread(s,'%d');
%     drawnow;
%     axes(handles.axes1);
%     plot(theta,'r','LineWidth',1.5);
%     pause(0.2);
% end
% t1 = limspace(0,60,120);
% plot(handles.axes1,t1,data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.btnconnect,'Enable','off');
set(handles.btndisconnect,'Enable','on');
set(handles.popPorts,'Enable','off');
set(handles.popBaudrates,'Enable','off');
set(handles.popParity,'Enable','off');
set(handles.popDataBits,'Enable','off');
set(handles.popStopBits,'Enable','off');
set(handles.btn_reset,'Enable','on');
set(handles.btn_swingup,'Enable','on');
set(handles.btn_balance,'Enable','on');
t = linspace(0,60,433);
phi = load('phi1');
plot(handles.axes3,t,phi);
ylabel(handles.axes3,'Cart Positon (cm)');
grid(handles.axes3, 'on')
plot(t,phi);

%%%%%%%%%%%%%%%%%%
theta = load('theta1');
plot(handles.axes2,t,theta);
ylabel(handles.axes2,'Pendulum1 Angle (rad)');
grid(handles.axes2, 'on')
plot(t,theta);
%%%%%%%%%%%%%%%%%%
gamma = load('gamma1');
plot(handles.axes4,t,gamma);
ylabel(handles.axes4,'Pendulum2 Angle (rad)');
grid(handles.axes4, 'on')
plot(t,gamma);
%%%%%%%%%%%%%%%%%%
% output = load('output1');
% plot(handles.axes1,t,output);
% ylabel(handles.axes1,'Energy (PWM)');
% grid(handles.axes1, 'on')
% plot(t,PWM);
axes(handles.axes8);
imshow('calab.png');
axes(handles.axes5);
imshow('bkhcm.png');

% --- Executes on button press in btndisconnect.
function btndisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btndisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fclose(s);
set(handles.btnconnect,'Enable','on');
set(handles.btndisconnect,'Enable','off');
set(handles.popPorts,'Enable','on');
set(handles.popBaudrates,'Enable','on');
set(handles.popParity,'Enable','on');
set(handles.popDataBits,'Enable','on');
set(handles.popStopBits,'Enable','on');
set(handles.btn_reset,'Enable','off');
set(handles.btn_swingup,'Enable','off');
set(handles.btn_balance,'Enable','off');


% --- Executes on selection change in popBaudrates.
function popBaudrates_Callback(hObject, eventdata, handles)
% hObject    handle to popBaudrates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBaudrates contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBaudrates
% --- Executes during object creation, after setting all properties.

function popBaudrates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBaudrates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
%Status are Open or Close
%If Com are open then close
if(strcmp(get(s,'Status'),'open'))
    fclose(s);
end
delete(s);
clear s;


% --- Executes on selection change in popParity.
function popParity_Callback(hObject, eventdata, handles)
% hObject    handle to popParity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popParity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popParity


% --- Executes during object creation, after setting all properties.
function popParity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popParity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popDataBits.
function popDataBits_Callback(hObject, eventdata, handles)
% hObject    handle to popDataBits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popDataBits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDataBits


% --- Executes during object creation, after setting all properties.
function popDataBits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popDataBits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popStopBits.
function popStopBits_Callback(hObject, eventdata, handles)
% hObject    handle to popStopBits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popStopBits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popStopBits


% --- Executes during object creation, after setting all properties.
function popStopBits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popStopBits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%read data from comPorts
function mycallback(obj, even, handles)
%data = fread(obj,1) %fscanf()
%data = fscanf(obj,'%f');


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fwrite(s,[1]);

% --- Executes on button press in btn_swingup.
function btn_swingup_Callback(hObject, eventdata, handles)
% hObject    handle to btn_swingup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fwrite(s,[2]);

% --- Executes on button press in btn_balance.
function btn_balance_Callback(hObject, eventdata, handles)
% hObject    handle to btn_balance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fwrite(s,[3]);
