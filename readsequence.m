function varargout = readsequence(varargin)
% READSEQUENCE M-file for readsequence.fig
%      READSEQUENCE, by itself, creates a new READSEQUENCE or raises the existing
%      singleton*.
%
%      H = READSEQUENCE returns the handle to a new READSEQUENCE or the handle to
%      the existing singleton*.
%
%      READSEQUENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in READSEQUENCE.M with the given input arguments.
%
%      READSEQUENCE('Property','Value',...) creates a new READSEQUENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before readsequence_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to readsequence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help readsequence

% Last Modified by GUIDE v2.5 17-Sep-2008 12:30:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @readsequence_OpeningFcn, ...
                   'gui_OutputFcn',  @readsequence_OutputFcn, ...
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


% --- Executes just before readsequence is made visible.
function readsequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to readsequence (see VARARGIN)

% Choose default command line output for readsequence
handles.output = hObject;

% Retrieve handles to the main window
handles.microscopeGUIHandle = varargin{1};
microscopeData = guidata(handles.microscopeGUIHandle); 

handles.pathname = microscopeData.pathname;
handles.sequencename = microscopeData.sequencename;

if ~isempty(handles.sequencename)
    handles.currentimage =1;
    set(handles.currentimage_edit,'String',num2str(handles.currentimage));
    set(handles.nimages_text,'String',num2str(microscopeData.nimages));
    set(microscopeData.display_axes,'CLim',[0 255]);
    set(microscopeData.image,'CData',...
        imread([handles.pathname handles.sequencename '-' num2str(handles.currentimage) '.tif']));
    % Update handles structure
    guidata(hObject, handles);
    guidata(handles.microscopeGUIHandle, microscopeData);
end


% UIWAIT makes readsequence wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = readsequence_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)

microscopeData = guidata(handles.microscopeGUIHandle);

handles.currentimage =min(handles.currentimage+1,microscopeData.nimages);
set(handles.currentimage_edit,'String',num2str(handles.currentimage));
set(microscopeData.image,'CData',...
    imread([handles.pathname handles.sequencename '-' num2str(handles.currentimage) '.tif']));
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle, microscopeData);

% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)

microscopeData = guidata(handles.microscopeGUIHandle);

handles.currentimage =max(handles.currentimage-1,1);
set(handles.currentimage_edit,'String',num2str(handles.currentimage));
set(microscopeData.image,'CData',...
    imread([handles.pathname handles.sequencename '-' num2str(handles.currentimage) '.tif']));
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle, microscopeData);

% --- Executes on button press in First.
function first_Callback(hObject, eventdata, handles)

microscopeData = guidata(handles.microscopeGUIHandle);

handles.currentimage =1;
set(handles.currentimage_edit,'String',num2str(handles.currentimage));
set(microscopeData.image,'CData',...
    imread([handles.pathname handles.sequencename '-' num2str(handles.currentimage) '.tif']));
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle, microscopeData);

% --- Executes on button press in last.
function last_Callback(hObject, eventdata, handles)

microscopeData = guidata(handles.microscopeGUIHandle);

handles.currentimage =microscopeData.nimages;
set(handles.currentimage_edit,'String',num2str(handles.currentimage));
set(microscopeData.image,'CData',...
    imread([handles.pathname handles.sequencename '-' num2str(handles.currentimage) '.tif']));
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle, microscopeData);

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)

handles.sequencetimer = timer('Period', .25,...
    'TasksToExecute',str2double(get(handles.nimages_text,'String')),...
    'ExecutionMode','fixedDelay');
set(handles.sequencetimer, 'TimerFcn', {@readsequenceimage, hObject})

% Update handles structure
guidata(hObject, handles);

% Start a timer
start(handles.sequencetimer)

function readsequenceimage(timerObject,eventdata,hObject,handles)

handles =guidata(hObject);
microscopeData = guidata(handles.microscopeGUIHandle);

ni = get(timerObject,'TasksExecuted');
set(handles.currentimage_edit,'String',num2str(ni));
set(microscopeData.image,'CData',...
        imread([handles.pathname handles.sequencename '-' num2str(ni) '.tif']));
drawnow;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.sequencetimer)

