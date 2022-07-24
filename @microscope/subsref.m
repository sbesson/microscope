%% subsred
% microscope class subsref method
%%

%% Syntax   
% val = subsref(m,field)
%
%% Description
% Return the property of a microscope object.
%
%% Inputs
% * m - a microscope object 
% * field - a string containing the field
%
%% Outputs
% * val - the corresponding property 
%
%% Examples
% >> m.dimensions
% >> roi = m.roi
%
%% See also 
% * get
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: September 29, 2008

function val = subsref(m,field)
% SUBSREF 
switch field.type
    case '.'
        switch field.subs
            case 'exposure'
                val = m.exposure;
            case 'roi'
                val = m.roi;
            case 'dimensions'
                val = m.dimensions;
            case 'scale'
                val = m.scale;
            case 'bin'
                val = m.bin;
        end

    otherwise
        error('You do not have access to this field')
end
end