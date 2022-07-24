%% getSpeed
% Return the actual speed of the MAC5000 controller
%%

%% Syntax   
% v = getSpeed(m)
%
%% Description
% Sends a query to the MAC5000 controller and reads the speed as
% a double array.
%
%% Inputs
% * m - a microscope object
%
%% Outputs
% * V - a 2-element vector containing the XY speed of the motor
%       or a 3-element vector containing the XYZ speed of the motor
%
%% Examples
% >> V = getSpeed(m); 
% return the actual position of the motor
%
%% See also 
% * setSpeed
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: October 23, 2008

function V = getSpeed(m)

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:getSpeed','Motor must be initialized first');
    fopen(m.motor);
end

% Query the motor for actual speed
a = query(m.motor,'SPEED X Y B');

% Convert ASCII answer into double vector
index = findstr(a,' ');
vx = str2double(a(index(1)+1:index(2)-1));
vy = str2double(a(index(2)+1:index(3)-1));
vz = str2double(a(index(3)+1:index(4)-1));
V = [vx vy vz];

% For debugging
%warning('microscope::getSpeed','Get motor speed');
end