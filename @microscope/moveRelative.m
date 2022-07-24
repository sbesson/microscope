%% moveRelative
% Move the MAC5000 controller to an absolute position
%%

%% Syntax   
% moveRelative(m,dP)
%
%% Description
% Sends an order to the MAC5000 interface to move to the absolute position
% set by the input.
%
%% Inputs
% * m - a microscope object
% * dP - a 2-element vector containing the relative XY position of the motor
%        or a 3-element vector containing the relative XYZ position of the motor
%
%% Outputs
% 
%
%% Examples
% >> moveRelative(m,[10 -20]); 
% >> moveRelative(m,[10 -20 50]);
%
%% See also 
% * move
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: October23, 2008

function moveRelative(m,dP)

error(nargchk(2, 2, nargin))

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:moveRelative','Motor must be initialized first');
    fopen(m.motor);
end

% Test length of input
switch length(dP)
    case 2
        % Send the motion command
        query(m.motor,['MOVREL X=' num2str(dP(1)) ' Y=' num2str(dP(2))]);
    case 3
        % Send the motion command
        query(m.motor,['MOVREL X=' num2str(dP(1)) 'Y=' num2str(dP(2))...
            'B=' num2str(dP(3))]);
    otherwise
    error('Input must contain 2 or 3 elements');
end

% For debugging
%warning('microscope:moveRelative','move motor towards position');
end