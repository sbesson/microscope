function varargout = cameracontrol(varargin)
% CAMERACONTROL M-file for cameracontrol.fig
%      CAMERACONTROL, by itself, creates a new CAMERACONTROL or raises the existing
%      singleton*.
%
%      H = CAMERACONTROL returns the handle to a new CAMERACONTROL or the handle to
%      the existing singleton*.
%
%      CAMERACONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERACONTROL.M with the given input arguments.
%
%      CAMERACONTROL('Property','Value',...) creates a new CAMERACONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cameracontrol_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cameracontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cameracontrol

% Last Modified by GUIDE v2.5 29-Sep-2008 20:45:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cameracontrol_OpeningFcn, ...
                   'gui_OutputFcn',  @cameracontrol_OutputFcn, ...
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


% --- Executes just before cameracontrol is made visible.
function cameracontrol_OpeningFcn(hObject, eventdata, handles, varargin)

% Retrieve the handles of the main microscope GUI
if nargin == 3
    handles.microscopeGUIHandle = microscopeGUI;
else
    handles.microscopeGUIHandle = varargin{1};
end
microscopeData = guidata(handles.microscopeGUIHandle); 

% Attributes names to the editable objects
exposure_edit(1) = handles.delay_edit;
exposure_edit(2) = handles.exposure_edit;
handles.exposure_edit = exposure_edit;
roi_edit(1) = handles.roix1_edit;
roi_edit(2) = handles.roix2_edit;
roi_edit(3) = handles.roiy1_edit;
roi_edit(4) = handles.roiy2_edit;
handles.roi_edit = roi_edit;

% Set the boxes to their initial values
exposure = microscopeData.microscope.exposure;
set(handles.exposure_edit(1),'String',num2str(exposure(1)));
set(handles.exposure_edit(2),'String',num2str(exposure(2)));
roi = microscopeData.microscope.roi;
set(handles.roi_edit(1),'String',num2str(roi(1)));
set(handles.roi_edit(2),'String',num2str(roi(2)));
set(handles.roi_edit(3),'String',num2str(roi(3)));
set(handles.roi_edit(4),'String',num2str(roi(4)));
set(handles.camera_status,'String',camera_status(microscopeData.microscope))
bin = microscopeData.microscope.bin;
set(handles.hbin_listbox, 'Value', log(bin(1))/log(2)+1);
set(handles.vbin_listbox, 'Value', log(bin(2))/log(2)+1);

% Draws the exposure table
axes(handles.exposure_axes);
handles.exposurezone(1) = fill([0 exposure(1) exposure(1) 0],[0 0 1 1],'b');
hold on;
handles.exposurezone(2) = fill([exposure(1) sum(exposure) sum(exposure) exposure(1)],[0 0 1 1],'g');
n0=fix(log10(sum(exposure)));
axis([0 11*10^(n0) 0 1]);
handles.exposurepoints(1) = plot(exposure(1),0,'^r',...
    'MarkerSize',10,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@exposurePoint_Start);
handles.exposurepoints(2) = plot(sum(exposure),1,'vr',...
    'MarkerSize',10,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@exposurePoint_Start);
 
% Draws the roi zone
axes(handles.roi_axes);
handles.roizone = fill([roi(1) roi(2) roi(2) roi(1)],[roi(3) roi(3) roi(4) roi(4)],'b');
hold on
handles.roipoints(1) = plot(roi(1),roi(3),'or',...
    'MarkerSize',8,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@roiPoint_Start);
handles.roipoints(2) = plot(roi(2),roi(3),'or',...
    'MarkerSize',8,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@roiPoint_Start);
handles.roipoints(3) = plot(roi(2),roi(4),'or',...
    'MarkerSize',8,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@roiPoint_Start);
handles.roipoints(4) = plot(roi(1),roi(4),'or',...
    'MarkerSize',8,'MarkerFaceColor',[1 0 0],...
    'ButtonDownFcn',@roiPoint_Start);
axis([0 1376 0 1056]);
set(gca,'XTick',[0 344 688 1032 1376])
set(gca,'YTick',[0 528 1056])
 
clear exposure bin roi n0
% Choose default command line output for cameracontrol
handles.output = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cameracontrol wait for user response (see UIRESUME)
% uiwait(handles.cameracontrol_figure);

% --- Outputs from this function are returned to the command line.
function varargout = cameracontrol_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

function exposure_edit_Callback(hObject, eventdata, handles)

% Get the value for the exposure table
exposure = str2double(get(handles.exposure_edit(:),'String'));
exposure(1) = max(exposure(1),0.0);
exposure(2) = max(exposure(2),1.0);

% Retrieve the handles of the main microscope GUI
microscopeData = guidata(handles.microscopeGUIHandle);
microscopeData.microscope = set(microscopeData.microscope,'exposure',exposure);
microscopeData.microscope = setCOC(microscopeData.microscope);
exposure = microscopeData.microscope.exposure;

% Update strings and exposure table
set(handles.exposurezone(1) ,'XData',[0 exposure(1) exposure(1) 0]);
set(handles.exposurezone(2),'XData',[exposure(1) sum(exposure) sum(exposure) exposure(1)]);
set(handles.exposurepoints(1),'XData',exposure(1));
set(handles.exposurepoints(2),'XData',sum(exposure));
set(handles.exposure_edit(1) ,'String',num2str(exposure(1)));
set(handles.exposure_edit(2) ,'String',num2str(exposure(2)));
    
% Update axes range
axes(handles.exposure_axes);
axlim = axis;
n0=fix(log10(sum(exposure)));
if n0 ~= floor(log10(axlim(2)))-1;
    axis([0 11*10^(n0) 0 1]);
    currentpos = get(handles.exposure_axes,'CurrentPoint');
    axlim = get(handles.exposure_axes,'XLim');
    axpos = get(handles.exposure_axes,'Position');
    deltax = (sum(exposure)-currentpos(1))/axlim(2)*axpos(3);
    currentpos = get(0,'PointerLocation');
    set(0,'PointerLocation',[currentpos(1)+.98*deltax currentpos(2)]);
end

clear exposure

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

function roi_edit_Callback(hObject, eventdata, handles)

roi = str2double(get(handles.roi_edit(:),'String'));
roi = round(roi/32)*32;
roi(1:2) = min(max(sort(roi(1:2)),0),1376);
roi(3:4) = min(max(sort(roi(3:4)),0),1040);
roi([1 3]) = roi([1 3])+1;

% Retrieve the handles of the main microscope GUI
microscopeData = guidata(handles.microscopeGUIHandle); 
microscopeData.microscope = set(microscopeData.microscope,'roi',roi);
microscopeData.microscope = setCOC(microscopeData.microscope);
roi = microscopeData.microscope.roi;

% Update strings and roi table
set(handles.roi_edit(1), 'String', num2str(roi(1),'%12u'));
set(handles.roi_edit(2), 'String', num2str(roi(2),'%12u'));
set(handles.roi_edit(3), 'String', num2str(roi(3),'%12u'));
set(handles.roi_edit(4), 'String', num2str(roi(4),'%12u'));
set(handles.roizone ,'XData',[roi(1) roi(2) roi(2) roi(1)],'YData',...
    [roi(3) roi(3) roi(4) roi(4)]);
set(handles.roipoints(1),'XData',roi(1),'YData',roi(3));
set(handles.roipoints(2),'XData',roi(2),'YData',roi(3));
set(handles.roipoints(3),'XData',roi(2),'YData',roi(4));
set(handles.roipoints(4),'XData',roi(1),'YData',roi(4));
set(handles.xsize_text,'String',num2str(roi(2)-roi(1)+1));
set(handles.ysize_text,'String',num2str(roi(4)-roi(3)+1));
% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

clear roi

% --- Executes on selection change in hbin_listbox.
function bin_listbox_Callback(hObject, eventdata, handles)

hbin_list_index = get(handles.hbin_listbox,'Value');
hbin = 2^(hbin_list_index-1);
vbin_list_index = get(handles.vbin_listbox,'Value');
vbin = 2^(vbin_list_index-1);

% Retrieve the handles of the main microscope GUI
microscopeData = guidata(handles.microscopeGUIHandle);
microscopeData.microscope = set(microscopeData.microscope,'bin',[hbin vbin]);
microscopeData.microscope = setCOC(microscopeData.microscope);

bin = get(microscopeData.microscope,'bin');
set(handles.hbin_listbox, 'Value', log(bin(1))/log(2)+1);
set(handles.vbin_listbox, 'Value', log(bin(2))/log(2)+1);

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

function exposurePoint_Start(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);
handles.dataselected = find(get(gcf,'currentobj') == handles.exposurepoints);

% Update motion properties
set(handles.cameracontrol_figure,'WindowButtonMotion',@exposurePoint_Motion)
set(handles.cameracontrol_figure,'WindowButtonUp',@exposurePoint_Finish)

set(handles.exposurepoints,'EraseMode','xor');
set(handles.exposurezone,'EraseMode','xor');
% Update handles structure
guidata(hObject, handles);

function exposurePoint_Motion(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);

% Get position of the pointer
P = get(handles.exposure_axes,'CurrentPoint');
P = P(1,1:2);
axlim = axis;

% Read old values of exposure
exposure(1) = get(handles.exposurepoints(1),'XData');
exposure(2) = get(handles.exposurepoints(2),'XData')-exposure(1);
% Read new value
exposure(handles.dataselected) = round(min(max(P(1),axlim(1)), axlim(2)))...
    -(handles.dataselected-1)*exposure(1);
% Normalize exposure time
exposure(2) = max(exposure(2),1);

% Update strings and position on the axes
set(handles.exposurezone(1) ,'XData',[0 exposure(1) exposure(1) 0]);
set(handles.exposurezone(2),'XData',[exposure(1) sum(exposure) sum(exposure) exposure(1)]);
set(handles.exposurepoints(1),'XData',exposure(1));
set(handles.exposurepoints(2),'XData',sum(exposure));
set(handles.exposure_edit(1) ,'String',num2str(exposure(1)));
set(handles.exposure_edit(2) ,'String',num2str(exposure(2)));
    
% Update axes range
axes(handles.exposure_axes);
n0=fix(log10(sum(exposure)));
if n0 ~= floor(log10(axlim(2)))-1;
    axis([0 11*10^(n0) 0 1]);
    currentpos = get(handles.exposure_axes,'CurrentPoint');
    axlim = get(handles.exposure_axes,'XLim');
    axpos = get(handles.exposure_axes,'Position');
    deltax = (sum(exposure)-currentpos(1))/axlim(2)*axpos(3);
    currentpos = get(0,'PointerLocation');
    set(0,'PointerLocation',[currentpos(1)+.98*deltax currentpos(2)]);
end

% Update handles structure
guidata(hObject, handles);

function exposurePoint_Finish(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);
microscopeData = guidata(handles.microscopeGUIHandle); 

% Get position of the pointer
P = get(handles.exposure_axes,'CurrentPoint');
P = P(1,1:2);
axlim = axis;

% Read old values of exposure
exposure(1) = get(handles.exposurepoints(1),'XData');
exposure(2) = get(handles.exposurepoints(2),'XData')-exposure(1);
% Read new value
exposure(handles.dataselected) = round(min(max(P(1),axlim(1)), axlim(2)))...
    -(handles.dataselected-1)*exposure(1);
% Normalize exposure time
exposure(2) = max(exposure(2),1);

% Set acquisition parameters 
microscopeData.microscope = set(microscopeData.microscope,'exposure', exposure);
microscopeData.microscope = setCOC(microscopeData.microscope);
exposure = get(microscopeData.microscope,'exposure');

% Update strings and position on the axes
set(handles.exposurezone(1) ,'XData',[0 exposure(1) exposure(1) 0]);
set(handles.exposurezone(2),'XData',[exposure(1) sum(exposure) sum(exposure) exposure(1)]);
set(handles.exposurepoints(1),'XData',exposure(1));
set(handles.exposurepoints(2),'XData',sum(exposure));
set(handles.exposure_edit(1) ,'String',num2str(exposure(1)));
set(handles.exposure_edit(2) ,'String',num2str(exposure(2)));

% Update axes range
axes(handles.exposure_axes);
n0=fix(log10(sum(exposure)));
if n0 ~= floor(log10(axlim(2)))-1;
    axis([0 11*10^(n0) 0 1]);
    currentpos = get(handles.exposure_axes,'CurrentPoint');
    axlim = get(handles.exposure_axes,'XLim');
    axpos = get(handles.exposure_axes,'Position');
    deltax = (sum(exposure)-currentpos(1))/axlim(2)*axpos(3);
    currentpos = get(0,'PointerLocation');
    set(0,'PointerLocation',[currentpos(1)+.98*deltax currentpos(2)]);
end

% Set graphic parameters back to normal
handles.dataselected = 0;
set(handles.exposurepoints(:),'EraseMode','normal');
set(handles.exposurezone(:),'EraseMode','normal');

% Remove the motion events
set(handles.cameracontrol_figure,'WindowButtonMotion','')
set(handles.cameracontrol_figure,'WindowButtonUp','')

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);


function roiPoint_Start(hObject, eventdata)

% % Retrieve handles structure
% handles = guidata(hObject);
% handles.dataselected = find(get(gcf,'currentobj') == handles.roipoints);
% 
% % Update motion properties
% set(handles.cameracontrol_figure,'WindowButtonMotion',@roiPoint_Motion)
% set(handles.cameracontrol_figure,'WindowButtonUp',@roiPoint_Finish)
% 
% set(handles.exposurepoints,'EraseMode','xor');
% set(handles.exposurezone,'EraseMode','xor');
% % Update handles structure
% guidata(hObject, handles);

function roiPoint_Motion(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);

% Get position of the pointer
P = get(handles.roiy2_edit_axes,'CurrentPoint');
P = P(1,1:2);
%axlim = axis;
P(1) = round(min(max(P(1),0), 1376));
P(2) = round(min(max(P(2),0), 1052));

% Read old values of exposure
roix = get(handles.roizone,'XData');
roiy = get(handles.roizone,'YData');
roi = [roix(1:2) roiy(2:3)];

% Read new value
roi(round(handles.dataselected/2)) = P(1);
%roi(4-round(handles.dataselected/2)) = P(2);

%exposure(handles.dataselected) = round(min(max(P(1),axlim(1)), axlim(2)))...
%    -(handles.dataselected-1)*exposure(1);


% Update strings and roi table
set(handles.roi_edit(1), 'String', num2str(roi(1),'%12u'));
set(handles.roi_edit(2), 'String', num2str(roi(2),'%12u'));
set(handles.roi_edit(3), 'String', num2str(roi(3),'%12u'));
set(handles.roi_edit(4), 'String', num2str(roi(4),'%12u'));
set(handles.roizone ,'XData',[roi(1) roi(2) roi(2) roi(1)],'YData',...
    [roi(3) roi(3) roi(4) roi(4)]);
set(handles.roipoints(1),'XData',roi(1),'YData',roi(3));
set(handles.roipoints(2),'XData',roi(2),'YData',roi(3));
set(handles.roipoints(3),'XData',roi(2),'YData',roi(4));
set(handles.roipoints(4),'XData',roi(1),'YData',roi(4));

% Update handles structure
guidata(hObject, handles);

function roiPoint_Finish(hObject, eventdata)

% Retrieve handles structure
handles = guidata(hObject);
microscopeData = guidata(handles.microscopeGUIHandle); 
% Get position of the pointer
P = get(handles.roiy2_edit_axes,'CurrentPoint');
P = P(1,1:2);
axlim = axis;
if handles.Pointselected == 1 % delay
    delay = get(handles.exposurepoints(1),'XData');
    exposure = get(handles.exposurepoints(2),'XData')-delay;
    delay = round(min(max(P(1),axlim(1)), axlim(2)));
    if (exposure+delay)>=axlim(2), 
        n=round(log10(axlim(2))*3);
        axis([axlim(1) 10^((n+1)/3) axlim(3) axlim(4)]); 
    end
        
    microscopeData.microscope = set(microscopeData.microscope,'delay',delay);
    microscopeData.microscope = setCOC(microscopeData.microscope);
    exposure = get(microscopeData.microscope,'exposure');
    delay = get(microscopeData.microscope,'delay');  
    
    set(handles.exposurezone(1) ,'XData',[0 delay delay 0]);
    set(handles.exposurezone(2),'XData',[delay exposure+delay exposure+delay delay]);
    set(handles.exposurepoints(1),'XData',delay);
    set(handles.exposurepoints(2),'XData',delay+exposure);
    set(handles.delay_edit ,'String',num2str(delay));

else % exposure
    delay = get(handles.exposurepoints(1),'XData');
    exposure = round(min(max(P(1),axlim(1)), axlim(2)))-delay;
    exposure = max(exposure,1);
    if (exposure+delay)>=axlim(2), 
        n=round(log10(axlim(2))*3);
        axis([axlim(1) 10^((n+1)/3) axlim(3) axlim(4)]); 
    end
    microscopeData.microscope = set(microscopeData.microscope,'exposure',exposure);
    microscopeData.microscope = setCOC(microscopeData.microscope);
    exposure = get(microscopeData.microscope,'exposure');
    delay = get(microscopeData.microscope,'delay');  
    
    set(handles.exposurezone(1) ,'XData',[0 delay delay 0]);
    set(handles.exposurezone(2),'XData',[delay exposure+delay exposure+delay delay]);
    set(handles.exposurepoints(1),'XData',delay);
    set(handles.exposurepoints(2),'XData',delay+exposure);
    set(handles.exposure_edit ,'String',num2str(exposure));

end

set(handles.exposurepoints(:),'EraseMode','normal');
set(handles.exposurezone(:),'EraseMode','normal');

% Remove the motion events
set(handles.cameracontrol_figure,'WindowButtonMotion','')
set(handles.cameracontrol_figure,'WindowButtonUp','')

% Update handles structure
guidata(hObject, handles);
guidata(handles.microscopeGUIHandle,microscopeData);

