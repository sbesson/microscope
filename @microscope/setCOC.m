%% setCOC
% Set camera parameters to the microscope object.
%%

%% Syntax   
% m = setCOC(m)
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
% >> m = setCOC(m); 
%
%% See also 
% * 
%
%% Author 
% Sebastien Besson.
% email address : sbesson@oeb.harvard.edu
% June 2008; Last revision: September 9, 2008

function m = setCOC(m)

type = uint32(m.set_type); % long exposure also used for QE
gain = uint32(m.set_gain); % 0=normal analog gain, 1=extended analog gain, 3=low light modes
gain = bitshift(gain, 8);
submode = uint32(m.set_submode); % sequential, busy out for more see Manual p.11
submode = bitshift(submode, 16);
mode = uint32(0);
mode = bitor(mode, type);
mode = bitor(mode, gain);
mode = bitor(mode, submode);
mode = int32(mode);
mode_ptr = libpointer('int32Ptr', mode);
trig_ptr = libpointer('int32Ptr', m.trig);
roix1_ptr = libpointer('int32Ptr', floor(m.roi(1)/32)+1);
roix2_ptr = libpointer('int32Ptr', floor(m.roi(2)/32));
roiy1_ptr = libpointer('int32Ptr', floor(m.roi(3)/32)+1);
roiy2_ptr = libpointer('int32Ptr', floor(m.roi(4)/32));
hbin_ptr = libpointer('int32Ptr', m.bin(1));
vbin_ptr = libpointer('int32Ptr', m.bin(2));
exposure_table = [num2str(m.exposure(1)) ',' num2str(m.exposure(2)) ', -1, -1'];
table = char(exposure_table);
table_ptr = libpointer('cstring', table); 
table_length = int32(length(table)+1);
table_length_ptr = libpointer('int32Ptr', table_length);

error_code = calllib('Senntcam', 'TEST_COC', mode_ptr, trig_ptr, roix1_ptr,...
         roix2_ptr, roiy1_ptr, roiy2_ptr, hbin_ptr, vbin_ptr, table_ptr, table_length_ptr);

switch error_code
    case 103
        r_mode = uint32(get(mode_ptr, 'Value'));
        m.set_type = int32(bitand(r_mode, uint32(bin2dec('11111111'))));
        r_gain = uint32(bitand(r_mode, uint32(bin2dec('1111111100000000'))));
        m.set_gain = int32(bitshift(r_gain,-8));
        r_submode = uint32(bitand(r_mode, uint32(bin2dec('11111111111111110000000000000000'))));
        m.set_submode = int32(bitshift(r_submode,-16));
        m.trig = int32(get(trig_ptr, 'Value'));
        roix1 = int32(get(roix1_ptr, 'Value'))*32-31;
        roix2 = int32(get(roix2_ptr, 'Value'))*32;
        roiy1 = int32(get(roiy1_ptr, 'Value'))*32-31;
        roiy2 = int32(get(roiy2_ptr, 'Value'))*32;
        m.roi = [roix1 roix2 roiy1 roiy2];
        m.bin = [int32(get(hbin_ptr, 'Value')) int32(get(vbin_ptr, 'Value'))];
        table = get(table_ptr, 'Value');
        index = findstr(table,',');
        m.exposure = [str2double(table(1:index(1)-1)) str2double(table(index(1)+1:index(2)-1))];
        warning('microscope:setCOC','One or more values changed');
    case 104
        warning('microscope:setCOC','Buffer too short for internal built string');
    case 0
    otherwise  
    error('microscope:setCOC','TEST_COC(%g,%g,%g,%g,%g,%g,%g,%g,%s) failed...',...
        mode, m.trig, floor(m.roi(1)/32)+1,...
        floor(m.roi(2)), floor(m.roi(3)/32)+1, floor(m.roi(4)/32), m.bin(1), m.bin(2),...
        [num2str(m.exposure(1)) ',' num2str(m.exposure(2)) ', -1, -1']);
end

error_code = calllib('Senntcam', 'SET_COC', mode, m.trig, floor(m.roi(1)/32)+1,...
    floor(m.roi(2))/32, floor(m.roi(3)/32)+1, floor(m.roi(4)/32), m.bin(1), m.bin(2),...
    [num2str(m.exposure(1)) ',' num2str(m.exposure(2)) ', -1, -1']);

if error_code ~= 0
    error('microscope:setCOC','SET_COC(%g,%g,%g,%g,%g,%g,%g,%g,%s) failed...',...
        mode, m.trig, floor(m.roi(1)/32)+1, floor(m.roi(2))/32, floor(m.roi(3)/32)+1,...
        floor(m.roi(4)/32),m.bin(1), m.bin(2),...
        [num2str(m.exposure(1)) ',' num2str(m.exposure(2)) ', -1, -1']);
end

end