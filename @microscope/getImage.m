%% getImage
% Capture an image from the Sensicam camera.
%%

%% Syntax   
% image = getImage(m)
%
%% Description
% Acquire image in the buffer by calling the scREAD_IMAGE-12BIT function.
%
%% Inputs
% * m - a microscope object
%
%% Outputs
% * image - an array containing th 12bit- image data
%
%% Examples
% >> image = getImage(m); 
% capture the actual image
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: September 29, 2008

function image = getImage(m)

% Read the image size
width_ptr = libpointer('int32Ptr', int32(42));
height_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_IMAGE_SIZE', width_ptr, height_ptr);
if error_code ~= 0
    error('microscope:getImage','An error occured while calling GET_IMAGE_SIZE');
end;
width =int32(get(width_ptr, 'Value'));
height = int32(get(height_ptr, 'Value'));

% Read the image in 12 bit
result_image = uint16(zeros(width,height));
result_image_ptr = libpointer('uint16Ptr', result_image);
% calling the pco SDK function READ_IMAGE_12BIT
error_code = calllib('Senntcam','READ_IMAGE_12BIT', int32(0),width, height, result_image_ptr);
if error_code ~= 0
    error('microscope:getImage','An error occured while calling READ_IMAGE_12BIT');
end
image = uint16(get(result_image_ptr, 'Value'))';

clear error_code width_ptr height_ptr result_image result_image_ptr
end