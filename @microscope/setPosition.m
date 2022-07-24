%% setPosition
% Write the current position of the MAC5000 controller
%%

%% Syntax   
% setPosition(M,P)
%
%% Description
% Sends a vecotr to the MAC5000 interface to write the position as
% a double array.
%
%% Inputs
% * s - a MAC5000 serial object
% * P - a 2-element vector containing the XY position of the motor
%       or a 3-element vector containing the XYZ position of the motor
%
%% Outputs
%
%
%% Examples
% >> getPosition(s,[100,200]); 
% set the actual position of the motor
%
%% See also 
% * getPosition
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: May 20, 2008

function setPosition(m,P)

error(nargchk(2, 2, nargin))

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:setPosition','Motor must be initialized first');
    fopen(m.motor);
end

% Test length of input
switch length(P)
    case 2
        fprintf(m.motor,['HERE X=' num2str(P(1)) 'Y=' num2str(P(2))]);
    case 3
        fprintf(m.motor,['HERE X=' num2str(P(1)) 'Y=' num2str(P(2))...
            'B=' num2str(P(3))]);
    otherwise
        error('Input must contain 2 or 3 elements');
end

% For debugging
%warning('microscope::setPosition','Set motor position');
end