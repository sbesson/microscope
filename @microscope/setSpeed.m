%% setSpeed
% Set the speed of the MAC5000 controller
%%

%% Syntax   
% setSpeed(m,V)
%
%% Description
% Sends a query to the MAC5000 controller and sets the speed as
% a double array.
%
%% Inputs
% * m - a microscope object
% * V - a 2-element vector containing the XY speed of the motor
%       or a 3-element vector containing the XYZ speed of the motor
%
%% Outputs
% * 
%
%% Examples
% >> setSpeed(m,[10000,10000]); 
% set the actual speed of the motor to [10000,10000]
% >> setSpeed(m,[10000,10000,2000]); 
%
%% See also 
% * getSpeed
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: October 23, 2008

function setSpeed(m,V)

error(nargchk(2, 2, nargin))

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:setSpeed','Motor must be initialized first');
    fopen(m.motor);
end

% Test length of input
switch length(V)
    case 2
        query(m.motor,['SPEED X=' num2str(V(1)) 'Y=' num2str(V(2))]);
    case 3
        query(m.motor,['SPEED X=' num2str(V(1)) 'Y=' num2str(V(2))...
            'B=' num2str(V(3))]);
    otherwise
        error('Input must contain 2 or 3 elements');
end
% For debugging
%warning('microscope::setSpeed','Set motor speed');
end