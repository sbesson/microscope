%% getPosition
% Return the position of the MAC5000 controller
%%

%% Syntax   
% P = getPosition(m)
%
%% Description
% Sends a query to the MAC5000 interface and reads the position as
% a double array.
%
%% Inputs
% * m - a microscope object
%
%% Outputs
% * P - a 2-element vector containing the XY position of the motor
%       or a 3-element vector containing the XYZ position of the motor
%
%% Examples
% >> P = getPosition(s); 
% return the actual position of the motor
%
%% See also 
% * setPosition
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: October 23, 2008

function P = getPosition(m)

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:getPosition','Motor must be initialized first');
    fopen(m.motor);
end

% Query the motor for actual position
a = query(m.motor,'WHERE X Y B');

% Convert ASCII answer into double vector
index = findstr(a,' ');
x = str2double(a(index(1)+1:index(2)-1));
y = str2double(a(index(2)+1:index(3)-1));
z = str2double(a(index(3)+1:index(4)-1));
P = [x y z];

% For debugging
%warning('microscope::getPosition','Get motor position');
end