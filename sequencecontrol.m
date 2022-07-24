
function varargout = sequencecontrol(varargin)
% SEQUENCECONTROL M-file for sequencecontrol.fig
%      SEQUENCECONTROL, by itself, creates a new SEQUENCECONTROL or raises the existing
%      singleton*.
%
%      H = SEQUENCECONTROL returns the handle to a new SEQUENCECONTROL or the handle to
%      the existing singleton*.
%
%      SEQUENCECONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEQUENCECONTROL.M with the given input arguments.
%
%      SEQUENCECONTROL('Property','Value',...) creates a new SEQUENCECONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sequencecontrol_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sequencecontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sequencecontrol

% Last Modified by GUIDE v2.5 11-Oct-2008 19:09:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sequencecontrol_OpeningFcn, ...
                   'gui_OutputFcn',  @sequencecontrol_OutputFcn, ...
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


% --- Executes just before sequencecontrol is made visible.
function sequencecontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sequencecontrol (see VARARGIN)

% Choose default command line output for sequencecontrol
handles.output = hObject;

% Retrieve handles to the main window
if nargin == 3
    handles.microscopeGUIHandle = microscopeGUI;
else
    handles.microscopeGUIHandle = varargin{1};
end
microscopeData = guidata(handles.microscopeGUIHandle);

% Set the initial number of images
set(handles.nimages_edit,'String',num2str(microscopeData.nimages));
% Set the time interval between two images
acquisitiontime_str =time_conversion(microscopeData.acquisitiontime);
set(handles.h_edit,'String',num2str(acquisitiontime_str(1)));
set(handles.min_edit,'String',num2str(acquisitiontime_str(2)));
set(handles.s_edit,'String',num2str(acquisitiontime_str(3)));
% Set the total acquisition time
totaltime_str = time_conversion(microscopeData.acquisitiontime*microscopeData.nimages);
set(handles.h_text,'String',num2str(totaltime_str(1)));
set(handles.min_text,'String',num2str(totaltime_str(2)));
set(handles.s_text,'String',num2str(totaltime_str(3)));

% Set the initial position of the microscope
Xposition=get(microscopeData.Xposition,'String');
Yposition=get(microscopeData.Yposition,'String');
set(handles.Xmin_edit,'String',Xposition);
set(handles.Xmax_edit,'String',Xposition);
set(handles.Ymin_edit,'String',Yposition);
set(handles.Ymax_edit,'String',Yposition);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sequencecontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = sequencecontrol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function time_edit_Callback(hObject, eventdata, handles)

% Read the number of images and the time interval between two images
nimages = str2double(get(handles.nimages_edit,'String'));
time_s = str2double(get(handles.s_edit,'String'));
time_min = str2double(get(handles.min_edit,'String'));
time_h = str2double(get(handles.h_edit,'String'));
% Convert the time interval between two images into seconds
acquisitiontime = time_conversion(time_h,time_min,time_s);
% Calculate and display the total acquisition time
totaltime = nimages*acquisitiontime;
totaltime_str =time_conversion(totaltime);
set(handles.h_text,'String',num2str(totaltime_str(1)));
set(handles.min_text,'String',num2str(totaltime_str(2)));
set(handles.s_text,'String',num2str(totaltime_str(3)));

% Retrieve main window data
microscopeData = guidata(handles.microscopeGUIHandle); 
% Updates the number of image and the time interval between two images
microscopeData.nimages=nimages;
microscopeData.acquisitiontime=acquisitiontime;

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle, microscopeData);

function time = time_conversion(varargin)

if nargin ==1
    hrs=varargin{1}/3600;     %  Work in absolute value.  Signvec will set sign later
    h   = fix(hrs);           %  Hours
    ms  = 60*(hrs - h);       %  Minutes and seconds
    min   = fix(ms);            %  Minutes
    s   = round(60*(ms - min));        %  Seconds
    time = [h min s];
elseif nargin == 3
    time = 3600*varargin{1}+60*varargin{2}+varargin{3};
else
    error('Number arguments must be either 1 or 3');
end
    

function Xmin_edit_Callback(hObject, eventdata, handles)

function Ymin_edit_Callback(hObject, eventdata, handles)

function Xmax_edit_Callback(hObject, eventdata, handles)

function Ymax_edit_Callback(hObject, eventdata, handles)

function deltaX_edit_Callback(hObject, eventdata, handles)

function scanwindow_edit_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton2.
function radiobutton1_Callback(hObject, eventdata, handles)

set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
set([handles.Xmin_edit,handles.Xmax_edit,handles.deltaX_edit,...
    handles.Ymin_edit,handles.Ymax_edit,handles.deltaY_edit],...
    'Enable','off');


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)

% Retrieve main window data
microscopeData = guidata(handles.microscopeGUIHandle); 

set(handles.radiobutton1,'Value',0);
set(handles.radiobutton3,'Value',0);
set([handles.Xmin_edit,handles.Xmax_edit,handles.deltaX_edit,...
    handles.Ymin_edit,handles.Ymax_edit,handles.deltaY_edit],...
    'Enable','off');
microscopeData.acquisitiontable = microscopeData.XYTable;
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle, microscopeData);

% --- Executes on button press in radiobutton2.
function radiobutton3_Callback(hObject, eventdata, handles)

set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set([handles.Xmin_edit,handles.Xmax_edit,handles.deltaX_edit,...
    handles.Ymin_edit,handles.Ymax_edit,handles.deltaY_edit],...
    'Enable','on');
