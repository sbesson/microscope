%% isImageready
% Capture an image from the Sensicam camera.
%%

%% Syntax   
% test = isImageready(m)
%
%% Description
% Snapshot mode
%
%% Inputs
% * m - a microscope object
%
%% Outputs
% * image - an array containing th image data
%
%% Examples
% >> test = isImageready(m); 
% capture the actual image
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: June 8, 2008

function test = isImageready(m)

% Check for image status, to be sure 
image_status_ptr = libpointer('int32Ptr', int32(42));
error_code = calllib('Senntcam', 'GET_IMAGE_STATUS', image_status_ptr);
if error_code ~= 0
    error('microscope:isImagereasy','An error occured while calling GET_IMAGE_STATUS')
end
image_status=uint32(get(image_status_ptr, 'Value'));

image_busy = uint32(1);                 
no_image_available = uint32(2);   
lower8bit_mask=uint32(255); 

image_status = bitand(image_status, lower8bit_mask);
image_busy = bitand(image_status, image_busy);
image_available = bitand(image_status, no_image_available);

test = ((image_available == 0) & (image_busy ==0));
    
end