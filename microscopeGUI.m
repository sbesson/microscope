function varargout = microscopeGUI(varargin)
% MICROSCOPEGUI M-file for microscopeGUI.fig
% This application is a simple application to show the control of the
% sensicam, dicam pro, hsfc pro camera systems of PCO AG - www.pco.de. 
% It shows the use of the corresponding Matlab-M files, which enable 
% access to the sensicam SDK functions, which in turn control the
% camera functions. Please see the help information of each M-file as well
% as the manual for the SDK for further detailed information.
% PCO AG, www.pco.de, 22.09.2003, G. Holst


%      MICROSCOPEGUI, by itself, creates a new MICROSCOPEGUI or raises the existing
%      singleton*.
%
%      H = MICROSCOPEGUI returns the handle to a new MICROSCOPEGUI or the handle to
%      the existing singleton*.
%
%      MICROSCOPEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICROSCOPEGUI.M with the given input arguments.
%
%      MICROSCOPEGUI('Property','Value',...) creates a new MICROSCOPEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before microscopeGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to microscopeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help microscopeGUI

% Last Modified by GUIDE v2.5 13-Oct-2008 18:14:34

% revision history:
% September 2004 - added type cast to uint32 in "bitand" calls

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @microscopeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @microscopeGUI_OutputFcn, ...
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

function microscopeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for microscopeGUI
handles.output = hObject;

clc
delete(timerfind);
% Create and intializes a microscope object
handles.microscope = initialize(microscope());
    
% Initialize the image
axes(handles.display_axes);
handles.image = imshow(255*ones(handles.microscope.dimensions)',handles.microscope.scale);
hold on
handles.ruler = plot([80 140],[30 30],'-r','Linewidth',2,'Visible','Off');
handles.rulertext = text(80,10,'100 \mum','Color',[1 0 0],'Visible','Off');
handles.objective = text(15,15,'','Color',[1 0 0],'FontName','Georgia','FontSize',16,'Visible','Off');

% Read the initial position of the motor
P = getPosition(handles.microscope);
V = getSpeed(handles.microscope);
set([handles.Xposition handles.X_edit],'String',num2str(P(1)/5));
set([handles.Yposition handles.Y_edit],'String',num2str(P(2)/5));
set(handles.velocity_edit,'String',num2str(V(2)/5));
set(handles.display_axes,'Visible','off','Units','pixels');

% Initialize various constants
handles.pathname ='./';
handles.filename = '';
handles.sequencename = '';
handles.extension = '';
handles.displaysequence =1;
handles.XYTable =[];
% Constants for acquisition
handles.nimages = 5;
handles.acquisitiontime =10;
handles.npoints =0;

% Update handles structure
guidata(hObject, handles);

function varargout = microscopeGUI_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Saveas_Callback(hObject, eventdata, handles)

[handles.filename, handles.pathname, filterindex] = uiputfile(...
    {'*.tif', 'TIFF-files (*.tif)';'*.jpg', 'JPEG-files (*.jpg)';...
    '*.png', 'PNG-files (*.png)';'*.bmp', 'Bitmap-files (*.bmp)'},...
    'Save as');

% If file has been selected
if handles.filename ~= 0
    % Retrieve lower and upper scales and convert the image into 8-bit
    clim = get(handles.display_axes, 'CLim');
    write_image = im2uint8(mat2gray(get(handles.image, 'CData'),[clim(1) clim(2)]));
    
   % Save the extension
    switch filterindex
        case 1 % *.tif
            handles.extension = 'tif';
        case 2 % *.jpg
            handles.extension = 'jpg';
        case 3 % *.png
            handles.extension = 'png';
        case 4 % *.bmp
           handles.extension = 'bmp';
    end

    % Get the generic filename
    find_str_result = findstr(handles.filename, '.');
    if isempty(find_str_result)
        handles.filename = handles.filename;
    else
        last_occur = size(find_str_result);
        copy_index = find_str_result(last_occur(2))-1;
        str_buffer = handles.filename(1:copy_index);
        handles.filename = str_buffer;
    end
    % Write the image
    handles.filename = [handles.filename '.' handles.extension];
    write_name = [handles.pathname handles.filename];
    imwrite(write_image, write_name, handles.extension)
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)

% Launch a dialog box
if strcmp(questdlg('Really quit?','Quit microscope UI'),'Yes')
    if ~isempty(timerfind) 
        stop(timerfind);
        delete(timerfind);
    end
    % Close the microscope object
    if  isfield(handles,microscope), close(handles.microscope);  end
    % Prevent double call of the quit function  
    set(gcbf,'DeleteFcn','');
    % Delete the figure
    delete([findobj(0,'tag','microscopeGUI') gcbf]); 
end

function about_Callback(hObject, eventdata, handles)
helpdlg(char('Microscope user interface program','Version 0.2.',...
    'Last modification: 08/10/13'),'About');

% --- Executes on button press in snapshot.
function snapshot_Callback(hObject, eventdata, handles)

set(handles.display_axes,'CLim',handles.microscope.scale);
% Set the camera in single exposure mode
handles.microscope = set(handles.microscope,'run_mode',4);
% Start the exposure
runCOC(handles.microscope);
% Wait for an image to be available
while (~isImageready(handles.microscope)), end
% Display the grayscale image
set(handles.image,'CData',getImage(handles.microscope));
set(handles.title,'String','snapshot')
% Stop the exposure
stopCOC(handles.microscope)
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in preview_togglebutton.
function preview_Callback(hObject, eventdata, handles)

set(handles.display_axes,'CLim',handles.microscope.scale);
if (hObject ~= handles.preview_button), set(handles.preview_button, 'Value',1); end;
set(handles.snapshot,'Enable','off');

if get(handles.preview_button, 'Value') ==1
    set(handles.title,'String','Real-time')
    % Set the camera in continuous exposure mode and start the exposure
    handles.microscope = set(handles.microscope,'run_mode',0);
    runCOC(handles.microscope);
    % Test if toggle button is still pressed
    while get(handles.preview_button, 'Value') == 1
        % Wait for an image to be available
        while (~isImageready(handles.microscope)), end
        % Display the grayscale image
        set(handles.image,'CData',getImage(handles.microscope));
        drawnow;
        if ~ishandle(hObject), return; end
    end
    stopCOC(handles.microscope);
end
set(handles.title,'String','')
set(handles.snapshot,'Enable','on');
% Update handles structure
%guidata(hObject, handles);

% --------------------------------------------------------------------
function acquiresequence_Callback(hObject, eventdata, handles)
    

% Set the camera in continuous exposure mode and start the exposure
[handles.sequencename, handles.pathname] = uiputfile({'*.tif'},'Save as');

if handles.sequencename ~= 0
    set(handles.preview_button, 'Value',0,'Enable','off');
    set(handles.snapshot,'Enable','on');
    find_str_result = findstr(handles.sequencename, '.');
    % Get the generic name for the images to write
    if isempty(find_str_result)
        handles.sequencename = handles.sequencename;
    else
        last_occur = size(find_str_result);
        copy_index = find_str_result(last_occur(2))-1;
        str_buffer = handles.sequencename(1:copy_index);
        handles.sequencename = str_buffer;
    end
    
    if isempty(handles.XYTable)
        P = getPosition(handles.microscope);
        handles.XYTable = P/5;
    end

    % Move to the next position
    moveXY(handles.microscope,5*round(handles.XYTable(1,:)));
    trackmotion(hObject,handles)
    
    handles.npoints = size(handles.XYTable,1);
    % Initialize a timer
    handles.sequencetimer = timer('Period', handles.acquisitiontime/handles.npoints,...
        'TasksToExecute',handles.npoints*handles.nimages,...
        'ExecutionMode','fixedDelay');
    set(handles.sequencetimer, 'TimerFcn', @acquiresequenceimage)
    set(handles.sequencetimer, 'StopFcn', @endacquisition);
    set(handles.display_axes,'CLim',handles.microscope.scale);
    
    % Update handles structure
    guidata(hObject, handles);
    % Start a timer
    start(handles.sequencetimer)
end

function acquiresequenceimage(timerObject,eventdata)

hObject=findall(0,'tag','microscopeGUI');
% Retrieve handles structure
handles = guidata(hObject);

% Set the camera in single exposure mode and start the exposure
handles.microscope = set(handles.microscope,'run_mode',4);
runCOC(handles.microscope);
% Wait for an image to be available
while (~isImageready(handles.microscope)), end
image = getImage(handles.microscope);
% Display the grayscale image
if handles.displaysequence == 1,  set(handles.image,'CData',image); end
% Stop the exposure
stopCOC(handles.microscope);

ni = get(timerObject,'TasksExecuted');
ntot = get(timerObject,'TasksToExecute');
nseq = floor((ni-1)/handles.npoints)+1;
nseqtot = ntot/handles.npoints;
pos = mod((ni-1),handles.npoints)+1;

set(handles.title,'String',['Position ' num2str(pos) '/' num2str(handles.npoints)...
    ' image ' num2str(nseq) '/' num2str(nseqtot) ' ' datestr(now)]);

% Save the acquired image
clim = get(handles.display_axes, 'CLim');
write_image = im2uint8(mat2gray(image,[clim(1) clim(2)]));
savename = [handles.sequencename num2str(pos) '-' num2str(nseq) '.tif'];
write_name = [handles.pathname savename];
imwrite(write_image, write_name, 'tif');

% Move to the next position
nextpos = mod(ni,handles.npoints)+1;
moveXY(handles.microscope,5*round(handles.XYTable(nextpos,:)));
%trackmotion(hObject,handles);

% Update handles structure
%guidata(hObject, handles);

function endacquisition(timerObject,eventdata)

hObject=findall(0,'tag','microscopeGUI');
% Retrieve handles structure
handles = guidata(hObject);
set(handles.preview_button,'Enable','on');

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function cameracontrol_Callback(hObject, eventdata, handles)

% Launch the camera control GUI
cameracontrol(handles.microscopeGUI);

%--------------------------------------------------------------------
function sequencesettings_Callback(hObject, eventdata, handles)
% Launch the acquiresequence control GUI
sequencecontrol(handles.microscopeGUI);

% --------------------------------------------------------------------
function convertcontrol_Callback(hObject, eventdata, handles)

% Launch the convert control GUI
convertcontrol(handles.microscopeGUI);

% --------------------------------------------------------------------
function readsequence_Callback(hObject, eventdata, handles)

% Launch the convert control GUI
readsequence(handles.microscopeGUI);

% --------------------------------------------------------------------
function loadsequence_Callback(hObject, eventdata, handles)

% Set the camera in continuous exposure mode and start the exposure
[handles.sequencename, handles.pathname] = uigetfile({'*.tif'},'Open a sequence file');
if handles.sequencename ~= 0
    find_str_result = findstr(handles.sequencename, '-');
    % Get the generic name for the images to write
    if isempty(find_str_result)
        handles.sequencename = handles.sequencename;
    else
        last_occur = size(find_str_result);
        copy_index = find_str_result(last_occur(2))-1;
        str_buffer = handles.sequencename(1:copy_index);
        handles.sequencename = str_buffer;
    end
    files = dir([handles.pathname handles.sequencename '*.tif']);
    handles.nimages = length(files);
    % Update handles structure
    guidata(hObject, handles);
    % Launch the convert control GUI
    readsequence(handles.microscopeGUI);
end

function changeobjective_Callback(hObject, eventdata, handles)

%Uncheck menus
set([handles.noobjective handles.objective4 handles.objective6...
    handles.objective16 handles.objective24],'Checked','off');
% If no objective menu is selected
if strcmp(get(hObject,'tag'),'noobjective')
    set([handles.ruler handles.rulertext handles.objective],'Visible','Off');
else
    % Determine the size of the objective
    obj_tag = get(hObject,'tag');
    obj_power = str2double(obj_tag(length('objective')+1:end));
    set(handles.ruler,'Visible','On','XData',[80 80+100/6.45*obj_power]);
    set(handles.rulertext,'Visible','On','Position',[80 10]);
    set(handles.objective,'Visible','On','String',['x ' num2str(obj_power)]);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in updateposition.
function updateposition_Callback(hObject, eventdata, handles)

P = getPosition(handles.microscope);
set([handles.Xposition handles.X_edit],'String',num2str(P(1)/5));
set([handles.Yposition handles.Y_edit],'String',num2str(P(2)/5));

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

setPosition(handles.microscope,[0 0]);
set(handles.Xposition,'String',num2str(0));
set(handles.Yposition,'String',num2str(0));

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in setvelocity.
function setvelocity_Callback(hObject, eventdata, handles)

V=round(5*str2double(get(handles.velocity_edit,'String')));
setSpeed(handles.microscope,[V V]);

% --- Executes on button press in absolutemove.
function absolutemove_Callback(hObject, eventdata, handles)

X=round(5*str2double(get(handles.X_edit,'String')));
Y=round(5*str2double(get(handles.Y_edit,'String')));
moveXY(handles.microscope,[X Y]);
trackmotion(hObject,handles)

% --- Executes on button press in relativemove.
function relativemove_Callback(hObject, eventdata, handles)

X=round(5*str2double(get(handles.dX_edit,'String')));
Y=round(5*str2double(get(handles.dY_edit,'String')));
moveRelativeXY(handles.microscope,[X Y]);
trackmotion(hObject,handles)

function trackmotion(hObject,handles)
while ~isMoving(handles.microscope), end;
set(handles.isMoving,'Value',1);
% Update handles structure
%guidata(hObject, handles);

while isMoving(handles.microscope)
    %P = getPosition(handles.microscope);
    %set(handles.Xposition,'String',num2str(P(1)/5));
    %set(handles.Yposition,'String',num2str(P(2)/5));
    drawnow
    % Update handles structure
    %guidata(hObject, handles);
end
set(handles.isMoving,'Value',0);
P = getPosition(handles.microscope);
set([handles.Xposition handles.X_edit],'String',num2str(P(1)/5));
set([handles.Yposition handles.Y_edit],'String',num2str(P(2)/5));
drawnow

% --- Executes on button press ien SavePosition.
function SavePosition_Callback(hObject, eventdata, handles)

P = getPosition(handles.microscope);
set([handles.Xposition handles.X_edit],'String',num2str(P(1)/5));
set([handles.Yposition handles.Y_edit],'String',num2str(P(2)/5));
handles.XYTable =[handles.XYTable;P/5];
% Update pop-up menu
string = get(handles.savedpositions,'String');
if ~iscell(string), string ={string}; end;
string{length(string)+1} = ['Position ' num2str(length(string))];
set(handles.savedpositions,'String', string);
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Removeposition.
function Removeposition_Callback(hObject, eventdata, handles)
val = get(handles.savedpositions,'Value');
if val > 1
    handles.XYTable(val-1,:) =[];
    string = get(handles.savedpositions,'String');
    string(length(string)) = [];
    set(handles.savedpositions,'String',string);
    set(handles.savedpositions,'Value',1);
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on selection change in savedpositions.
function savedpositions_Callback(hObject, eventdata, handles)
val = get(hObject,'Value');
if val > 1
    position = handles.XYTable(val-1,:);
    set(handles.X_edit,'String',num2str(position(1)));
    set(handles.Y_edit,'String',num2str(position(2)));
    x = str2double(get(handles.Xposition,'String'));
    y = str2double(get(handles.Yposition,'String'));
    set(handles.dX_edit,'String',num2str(position(1)-x));
    set(handles.dY_edit,'String',num2str(position(2)-y));
    % Update handles structure
    guidata(hObject, handles);
end



