%% moveXY
% Move the microscope XY motor to an absolute position
%%

%% Syntax   
% moveXY(m,P)
%
%% Description
% Sends an order to the MAC5000 interface to move to the absolute position
% set by the input.
%
%% Inputs
% * m - a microscope object
% * P - a 2-element vector containing the X and Y position of the motor
%
%% Outputs
% 
%
%% Examples
% >> moveXY(m,[1000 1000]); 
% return the actual position of the motor
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: May 9, 2008

function moveXY(m,P)

error(nargchk(2, 2, nargin))

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:move','Motor must be initialized first');
    fopen(m.motor);
end

% Test length of input
if (length(P) ~= 2)
    error('If a single input is specified, ir must contain 2 elements');
end

% Send the motion command
query(m.motor,['MOVE X=' num2str(P(1)) 'Y=' num2str(P(2))]);

% For debugging
%warning('microscope::moveXY','move motor to position');
end