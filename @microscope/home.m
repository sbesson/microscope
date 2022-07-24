%% home
% Move the MAC5000 controller to its home position.
%%

%% Syntax   
% home(m)
%
%% Description
% Sends an order
%
%% Inputs
% * m - a microscope object
%
%% Outputs
%
%
%% Examples
% >> home(m); 
% set the actual position of the motor
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: May 20, 2008

function home(m)

% Test if connection is initalized
if (strcmp(m.motor.status,'closed'))
    warning('microscope:setPosition','Motor must be initialized first');
    fopen(m.motor);
end

% Send the motion command
fprintf(m.motor,'HOME X Y');

% For debugging
%warning('microscope::home','Send axes homes');

end