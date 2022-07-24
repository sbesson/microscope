%% move
% Move the microscope XYZ motor to an absolute position
%%

%% Syntax   
% moveXYZ(m,P)
%
%% Description
% Sends an order to the MAC5000 interface to move to the absolute position
% set by the input.
%
%% Inputs
% * m - a microscope object
% * P - a 2-element vector containing the XY position of the motor
%       or a 3-element vector containing the XYZ position of the motor
%
%% Outputs
% 
%
%% Examples
% >> move(m,[1000 1000]); 
% >> move(m,[1000 1000 -1000]); 
%
%% See also 
% * moveRelative
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: October 23, 2008

function move(m,P)

error(nargchk(2, 2, nargin))

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:move','Motor must be initialized first');
    fopen(m.motor);
end

% Test length of input
switch length(P)
    case 2
        % Send the motion command
        query(m.motor,['MOVE X=' num2str(P(1)) 'Y=' num2str(P(2))]);
    case 3
        % Send the motion command
        query(m.motor,['MOVE X=' num2str(P(1)) 'Y=' num2str(P(2))...
            'B=' num2str(P(3))]);
    otherwise
    error('Input must contain 2 or 3 elements');
end

% For debugging
%warning('microscope::move','move motor to position');
end