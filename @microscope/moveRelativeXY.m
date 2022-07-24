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
% * dP - a vector of relative position 
%
%% Outputs
% 
%
%% Examples
% >> moveRelativeXY(m,[1000 1000]); 
% return the actual position of the motor
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: May 20, 2008

function moveRelativeXY(m,dP)

error(nargchk(2, 2, nargin))

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:moveRelative','Motor must be initialized first');
    fopen(m.motor);
end

% Test length of input
if (length(dP) ~= 2)
    error('Input must contain 2 elements');
end

% Send the motion command
fprintf(m.motor,['MOVREL X=' num2str(dP(1)) 'Y=' num2str(dP(2))]);

% For debugging
%warning('microscope:moveRelativeXY','move motor towards position');
end