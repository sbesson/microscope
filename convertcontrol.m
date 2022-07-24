function varargout = convertcontrol(varargin)
% CONVERTCONTROL M-file for convertcontrol.fig
%      CONVERTCONTROL, by itself, creates a new CONVERTCONTROL or raises the existing
%      singleton*.
%
%      H = CONVERTCONTROL returns the handle to a new CONVERTCONTROL or the handle to
%      the existing singleton*.
%
%      CONVERTCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVERTCONTROL.M with the given input arguments.
%
%      CONVERTCONTROL('Property','Value',...) creates a new CONVERTCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before convertcontrol_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to convertcontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help convertcontrol

% Last Modified by GUIDE v2.5 22-Sep-2008 16:14:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @convertcontrol_OpeningFcn, ...
                   'gui_OutputFcn',  @convertcontrol_OutputFcn, ...
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


% --- Executes just before convertcontrol is made visible.
function convertcontrol_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for convertcontrol
handles.output = hObject;

% Retrieve the handles of the main microscope GUI
if nargin == 3
    handles.microscopeGUIHandle = microscopeGUI;
else
    handles.microscopeGUIHandle = varargin{1};
end
microscopeData = guidata(handles.microscopeGUIHandle); 

% Set the camera settings to their actual value
scale_edit(1) = handles.lowscale_edit;
scale_edit(2) = handles.uppscale_edit;
handles.scale_edit = scale_edit; 

scale = microscopeData.microscope.scale;
set(handles.scale_edit(1),'String',num2str(scale(1)));
set(handles.scale_edit(2),'String',num2str(scale(2)));

axes(handles.table_axes);
handles.table = plot([0 scale 2^12],[0 0 255 255],'-b','Linewidth',2);
hold on;
handles.scalepoints(1) = plot(scale(1),0,'^r',...
    'MarkerSize',10,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@movePoint_Start);
handles.scalepoints(2) = plot(scale(2),255,'vr',...
    'MarkerSize',10,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@movePoint_Start);
uistack(handles.scalepoints(:),'top');
axis([-100 2^12+100 -10 255+10]);
set(gca,'YTick',[0 128 255])
clear scale
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes convertcontrol wait for user response (see UIRESUME)
% uiwait(handles.convertcontrol_figure);

% --- Outputs from this function are returned to the command line.
function varargout = convertcontrol_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

function scale_edit_Callback(hObject, eventdata, handles)

scale = str2double(get(handles.scale_edit(:),'String'));

if ~issorted(scale) || scale(1) == scale(2)
    handles.Pointselected = find(get(gcf,'currentobj') == handles.scalepoints);
else
    scale = min(max(sort(scale),1),4095)';
end

microscopeData = guidata(handles.microscopeGUIHandle); 
microscopeData.microscope = set(microscopeData.microscope,'scale',scale);
set(microscopeData.display_axes,'CLim',microscopeData.microscope.scale);

set(handles.table,'XData',[0 scale 2^12]);
set(handles.scalepoints(1),'XData',scale(1));
set(handles.scalepoints(2),'XData',scale(2));

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

function movePoint_Start(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);

handles.dataselected = find(get(gcf,'currentobj') == handles.scalepoints);

% Update motion properties
set(handles.convertcontrol_figure,'WindowButtonMotion',@movePoint_Motion)
set(handles.convertcontrol_figure,'WindowButtonUp',@movePoint_Finish)

set(handles.scalepoints,'EraseMode','xor');
set(handles.table,'EraseMode','xor');
% Update handles structure
guidata(hObject, handles);

function movePoint_Motion(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);
microscopeData = guidata(handles.microscopeGUIHandle); 

% Get position of the pointer
P = get(handles.table_axes,'CurrentPoint');
P = P(1,1:2);
scale = get(microscopeData.display_axes,'CLim');
if handles.dataselected == 1,
    scale(handles.dataselected) = min(max(round(P(1)),1),scale(2)-1);
else
    scale(handles.dataselected) = min(max(round(P(1)),scale(1)+1),4095);
end
set(microscopeData.display_axes,'CLim', scale);

set(handles.scale_edit(1),'String',num2str(scale(1)));
set(handles.scale_edit(2),'String',num2str(scale(2)));
set(handles.scalepoints(1),'XData',scale(1));
set(handles.scalepoints(2),'XData',scale(2));
set(handles.table,'XData',[0 scale 2^12]);

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

function movePoint_Finish(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);
microscopeData = guidata(handles.microscopeGUIHandle); 

% Get position of the pointer
P = get(handles.table_axes,'CurrentPoint');
P = P(1,1:2);
scale = get(microscopeData.display_axes,'CLim');
if handles.dataselected == 1,
    scale(handles.dataselected) = min(max(round(P(1)),1),scale(2)-1);
else
    scale(handles.dataselected) = min(max(round(P(1)),scale(1)+1),4095);
end

set(microscopeData.display_axes,'CLim', scale);
microscopeData.microscope = set(microscopeData.microscope,'scale', scale);

set(handles.scale_edit(1),'String',num2str(scale(1)));
set(handles.scale_edit(2),'String',num2str(scale(2)));
set(handles.scalepoints(1),'XData',scale(1),'EraseMode','normal');
set(handles.scalepoints(2),'XData',scale(2),'EraseMode','normal');
set(handles.table,'XData',[0 scale 2^12],'EraseMode','normal');

% Remove the motion events
set(handles.convertcontrol_figure,'WindowButtonMotion','')
set(handles.convertcontrol_figure,'WindowButtonUp','')
handles.dataselected =0;
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

