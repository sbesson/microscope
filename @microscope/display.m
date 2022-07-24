%% display
% display method for microscope object
%%

%% Syntax   
% l = display(m)
%
%% Description
% Displays the properties of a microscope object.
%
%% Inputs
% * m - a microscope object 
%
%% Outputs
% * l - a string
%
%% Examples
% >> l = display(m);
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: June 8, 2008

function l = display(m)

l=sprintf('Camera specifications\n');
% CCD type
l= [l 'CCD type: '];
switch m.CCDtype
    case 1
        l = [l sprintf('VGA black&white\n')];
    case 2
        l = [l sprintf('VGA color\n')];
    case 3
        l = [l sprintf('SVGA black&white\n')];
    case 4
        l = [l sprintf('SVGA color\n')];
    case 17
        l = [l sprintf('QE black&white\n')];
    case 23
        l = [l sprintf('Standard black&white\n')];
    case 25
        l = [l sprintf('Double black&white\n')];
    case 32
        l = [l sprintf('EM black&white\n')];
    otherwise
        l = [l sprintf('not specified\n')];
end

% Camera type
l= [l 'Camera type: '];
switch m.camtype
    case 1
        l = [l sprintf('FAST SHUTTER\n')];
    case 2
        l = [l sprintf('LONG_EXPOSURE\n')];
    case 5
        l = [l sprintf('DICAM-PRO\n')];
    case 7
        l = [l sprintf('LONG EXPOSURE QE\n')];
    case 8
        l = [l sprintf('FAST EXPOSURE QE\n')];
    otherwise
        l = [l sprintf('not specified\n')];
end

% Camera type
l= [l sprintf('Status information\n')];
b = dec2bin(m.cam_type);
l= [l sprintf('Gain: ')];
if all(b(17:18) == '00')
    l = [l sprintf('normal gain\n')];
elseif all(b(17:18) == '01')
    l = [l sprintf('extended gain normal\n')];
elseif all(b(17:18) == '02')
    l = [l sprintf('extended gain invers\n')];
else
    l = [l sprintf('not specified\n')];
end

l= [l sprintf('CCD-type: ')];
if all(b(15:16) == '00')
    l = [l sprintf('640 x 480\n')];
elseif all(b(15:16) == '01')
    l = [l sprintf('640 x 480\n')];
elseif all(b(15:16) == '10')
    l = [l sprintf('1280 x 1024 or extended CCD\n')];
else
    l = [l sprintf('not specified\n')];
end

l= [l sprintf('Camera-type: ')];
if all(b(13:14) == '00')
    l = [l sprintf('LongExposure\n')];
elseif all(b(13:14) == '01')
    l = [l sprintf('FastShutter / DoubleShutter\n')];
elseif all(b(13:14) == '10')
    l = [l sprintf('special version\n')];
elseif all(b(13:14) == '11')
    l = [l sprintf('DiCAM-PRO\n')];
else
    l = [l sprintf('not specified\n')];
end

l= [l sprintf('SensiCam - version of camera: ')];
if all(b(10:12) == '000')
    l = [l sprintf('1.0\n')];
elseif all(b(10:12) == '001')
    l = [l sprintf('1.5\n')];
elseif all(b(10:12) == '010')
    l = [l sprintf('2.0\n')];
elseif all(b(10:12) == '011')
    l = [l sprintf('2.5\n')];
elseif all(b(10:12) == '100')
    l = [l sprintf('3.0\n')];
elseif all(b(10:12) == '111')
    l = [l sprintf('3.5\n')];
else
    l = [l sprintf('not specified\n')];
end

l= [l sprintf('CCD-color: ')];
if (b(9) == '0')
    l = [l sprintf('black/white CCD\n')];
else
    l = [l sprintf('RGB CCD\n')];
end
    
l= [l sprintf('Temperature of camera electronic: %g C\n',m.temp_ele)];
l= [l sprintf('Temperature of CCD-chip: %g C\n',m.temp_ccd)];

if nargout == 0, disp(l); end
    
