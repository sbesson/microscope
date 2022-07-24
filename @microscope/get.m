%% get
% microscope class get method
%%

%% Syntax   
% val = get(m,PropName)
%
%% Description
% Return the property of a microscope object.
%
%% Inputs
% * m - a microscope object 
% * PropName - a string containing the Information
%
%% Outputs
% * val - the corresponding property 
%
%% Examples
% >> get(m,'CCDtype')
% >> get(m,'width')
%
%% See also 
% * set
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: September 29, 2008

function val = get(m,PropName)

switch PropName
    case 'CCDtype'
        val = m.CCDtype;
    case 'camtype'
        val = m.camtype;
    case 'image_dimensions'
        val = m.image_dimensions;
    case 'exposure'
        val = m.exposure;
    case 'bin'
        val = m.bin;
    case 'scale'
        val = m.scale;
    case 'roi'
        val = m.roi;
    otherwise
        error([PropName,' is not a valid property']);
end
end