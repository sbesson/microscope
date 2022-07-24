%% isMoving
% Test if the MAC5000 controller is moving.
%%

%% Syntax   
% test = isMoving(m)
%
%% Description
% Sends a query to the MAC5000 controller to know if the motor is running.
%
%% Inputs
% * m - a microscope object
%
%% Outputs
%
%
%% Examples
% >> test = isMoving(m); 
% set the actual position of the motor
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: May 20, 2008

function ismoving = isMoving(m)

% Test if motor is running
fprintf(m.motor,'%s\r','STATUS');
status = fscanf(m.motor,'%c',1);
%status= query(m.motor,'STATUS','%s\r','%c');
% Reads the answer as a logical number
ismoving = (status == 'B');

% For debugging
%warning('microscope::isrunning','Test if motor is running');
end