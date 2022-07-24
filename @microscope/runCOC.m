%% runCOC
% Set camera parameters to the microscope object.
%%

%% Syntax   
% runCOC(m)
%
%% Description
%
%
%% Inputs
% * m - a microscope object
%
%% Outputs
%
%
%% Examples
% >> runCOC(m); 
% initialize the microscope object
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: September 29, 2008

function runCOC(m)

if m.isinitialized ~= 1
    error('microscope:runCOC','The microscope is not initialized');
end

error_code = calllib('Senntcam', 'RUN_COC', int32(m.run_mode));
if error_code ~= 0
    error('microscope:runCOC','An error occured while calling RUN_COC');
end

end