%% stopCOC
% Stops an exposure.
%%

%% Syntax   
% stopCOC(m)
%
%% Description
%This program interrupts a running exposure (execution of the COC program)
%
%% Inputs
% * m - a microscope object
%
%% Outputs
%
%
%% Examples
% >> stopCOC(m); 
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: September 29, 2008

function m = stopCOC(m)

error_code = calllib('Senntcam', 'STOP_COC', int32(0));
if error_code ~= 0
    error('microscope:stopCOC','An error occured while calling STOP_COC');
end
m.isacquiring = 0;
end