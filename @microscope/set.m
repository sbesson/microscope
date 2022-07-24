%% set
% microscope class set method
%%

%% Syntax   
% set(m,PropName,value)
%
%% Description
% Return the property of a microscope object.
%
%% Inputs
% * m - a microscope object 
% * PropName - a string containing the Information
% * val - the corresponding property 
%
%% Outputs
%
%
%% Examples
% >> set(m,'CCDtype',1)
% >> set(m,'width',1024)
%
%% See also 
% * set
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: June 8, 2008

function m = set(m,varargin)
propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
   PropName = propertyArgIn{1};
   val = propertyArgIn{2};
   propertyArgIn = propertyArgIn(3:end);
    switch PropName
        case 'CCDtype'
            m.CCDtype = val;
        case 'camtype'
            m.camtype = val;
        case 'dimensions'
            m.dimensions = val;
        case 'exposure'
            m.exposure = val;
        case 'bin'
            m.bin = val;
        case 'scale'
            m.scale = val;
        case 'run_mode'
            m.run_mode = val;
        case 'roi'
            m.roi = val;
        otherwise
            error([PropName,' is not a valid property']);
    end
end
end