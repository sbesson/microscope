%% close
% Microscope closing
%%

%% Syntax   
% close(m)
%
%% Description
% Close the serial connection with the MAC5000 controller. Destroy the
% microscope object
%
%% Inputs
%  * m - a microscope object 
%
%% Outputs
%
%
%% Examples
% >> close(m);
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: Setpember 29, 2008

function close(m)

% Imf motor object is valid
if isobject(m.motor)
    fclose(m.motor);
    delete(m.motor);
end

% Stops the camera
error_code = calllib('Senntcam', 'SET_INIT', int32(0));
if error_code ~= 0
    error('microscope:close','SET_INIT(0) failed...');
end

% Unload of library to free memory
unloadlibrary('Senntcam');

end