%% initialize
% Initialize the microscope object.
%%

%% Syntax   
% initialize(m)
%
%% Description
% This program opens the connection with the MAC5000 controller.
% After initializing the camera, it sends a series of queries to receive
% the basic informations about it (CCD type, size, image dimensions...)
%
%% Inputs
% * m - a microscope object
%
%% Outputs
%
%
%% Examples
% >> initialize(m); 
% initialize the microscope object
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: Ocotboer 2, 2008

function m = initialize(m)

% Open the connection with the MAC5000 controller
fopen(m.motor)

% Check if library is loaded
if not(libisloaded('Senntcam'))
    [notfound,warnings]=loadlibrary('senntcam','Sencam.h','alias','Senntcam');
end

% clear command window and change to compact output format
format compact;

% In case a process is running, stop everything by scSET_INIT(0)
error_code = calllib('Senntcam', 'SET_INIT', int32(0));
if error_code ~= 0
    error('microscope:initialize','An error occured while calling SET_INIT(0)');
end

% Initialize camera and PCI board
error_code = calllib('Senntcam', 'SET_INIT', int32(1));
if error_code ~= 0
    error('microscope:initialize','The camera must be switched on');
end;

board_number=0;

% Read out the CCD type
CCDtype_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_CAMERA_CCD', board_number, CCDtype_ptr);
%[m.CCDtype, error_code] = scGET_CAMERA_CCD(board_number);
if error_code ~= 0
    error('microscope:initialize','An error occured while calling GET_CAMERA_CCD');
end;
m.CCDtype = int32(get(CCDtype_ptr, 'Value'));

% Read out the camera type
camtype_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_CAMERA_TYP', board_number, camtype_ptr);
if error_code ~= 0
    error('microscope:initialize','An error occured while calling GET_CAMERA_TYP');
end;
m.camtype = int32(get(camtype_ptr, 'Value'));

% Read the status of the camera
cam_type_ptr = libpointer('int32Ptr', int32(42));
temp_ele_ptr = libpointer('int32Ptr', int32(42));
temp_ccd_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_STATUS', cam_type_ptr, temp_ele_ptr, temp_ccd_ptr);
if error_code ~= 0
    error('microscope:initialize','An error occured while calling GET_STATUS');
end;
m.cam_type = int32(get(cam_type_ptr, 'Value'));
m.temp_ele = int32(get(temp_ele_ptr, 'Value'));
m.temp_ccd = int32(get(temp_ccd_ptr, 'Value'));

% Read CCD size for proper dimensions
CCDsize_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_CCD_SIZE', CCDsize_ptr);
if error_code ~= 0
    error('microscope:initialize','An error occured while calling GET_CCD_SIZE');
end;
m.CCDsize = int32(get(CCDsize_ptr, 'Value'));

% Read image dimensions
width_ptr = libpointer('int32Ptr', int32(42));
height_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_IMAGE_SIZE', width_ptr, height_ptr);
if error_code ~= 0
    error('microscope:initialize','An error occured while calling GET_IMAGE_SIZE');
end;
m.dimensions = [int32(get(width_ptr, 'Value')) int32(get(height_ptr, 'Value'))];
% Update ROI given the dimensions of the image
m.roi = [1 m.dimensions(1) 1  m.dimensions(2)];
% Send camera parameters
m = setCOC(m);

clear error_code board_number CCDsize_ptr CCDtype_ptr camtype_ptr cam_type_ptr temp_ele_ptr temp_ccd_ptr width_ptr height_ptr
% Set speed equal to 10microns/s
setSpeed(m,[5000 5000]);
m.isinitialized = 1;

end