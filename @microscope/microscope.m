%% microscope
% microscope class constuctor
%%

%% Syntax   
% s = microscope()
%
%% Description
% Create a new object of the type microscope.
%
%% Inputs
% *
%
%% Outputs
% * m - a microscope object 
%
%% Examples
% >> m =  microscope();
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% May 2008; Last revision: June 8, 2008

function m = microscope(varargin)

switch nargin
    case 0
        % if no input arguments, create a default object
        delete(instrfind);
        m.motor=serial('COM1','StopBits',2,'Terminator',{10 13},...
            'Timeout',.2);
        m.isinitialized = 0;
        m.ismotorconnected = 0;
        m.ismoving = 0;
        m.isacquiring = 0;
        m.CCDtype = 0;
        m.camtype = 0;
        m.CCDsize = 0;
        m.cam_type = 0;
        m.temp_ele = 0;
        m.temp_ccd = 0;
        m.set_type = int32(0);
        m.set_gain = int32(0);
        m.set_submode = int32(0);
        m.run_mode = 0;
        m.trig = 0;
        m.roi = [1 1 1 1];
        m.bin = [1 1];
        m.dimensions= [0 0];
        m.scale = [1 4095];
        m.exposure = [0 100];
        m = class(m,'microscope');
    case 1
        % if single argument of class cellNetwork, return it 
        if (isa(varargin{1},'microscope')) 
            m = varargin{1};
        else
            error('Wrong argument type')  
        end 
    otherwise
         error('Wrong number of arguments') 
end

end