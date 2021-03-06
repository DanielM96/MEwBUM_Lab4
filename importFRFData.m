function [data1, data2, data3] = importFRFData(filename, startRow, endRow)
%IMPORTFRFDATA Import numeric data from a text file as column vectors.
%   [DATA1,DATA2,DATA3] = IMPORTFRFDATA(FILENAME) Reads data from
%   text file FILENAME for the default selection.
%
%   [DATA1,DATA2,DATA3] = IMPORTFRFDATA(FILENAME, STARTROW,
%   ENDROW) Reads data from rows STARTROW through ENDROW of text file
%   FILENAME.
%
% Example:
%   [data1,data2,data3] = importFRFData('P123.unv',[58,414,770], [399,755,1111]);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/11/03 16:16:45

%% Initialize variables.
delimiter = {'  ',' '};
if nargin<=2
    startRow = [59,415,771];
    endRow = [400,756,1112];
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
a1 = dataArray{:, 1};
a2 = dataArray{:, 2};
a3 = dataArray{:, 3};
a4 = dataArray{:, 4};
a5 = dataArray{:, 5};
a6 = dataArray{:, 6};

%% Get complex numbers from input data.
% To simplify GUI_PropellerBlade OpeningFcn code, the following
% calculations will be conducted as a last stage of data import procedure.

frf = cell(3,6);
for i = 1:3
    frf{i,1} = a1(342*(i-1)+1:342*i);
    frf{i,2} = a2(342*(i-1)+1:342*i);
    frf{i,3} = a3(342*(i-1)+1:342*i);
    frf{i,4} = a4(342*(i-1)+1:342*i);
    frf{i,5} = a5(342*(i-1)+1:342*i);
    frf{i,6} = a6(342*(i-1)+1:342*i);
end

daneR = zeros(1,1026);
daneI = zeros(1,1026);

% Punkt 1
for i = 1:342
    daneR(3*(i-1)+1) = frf{1,1}(i);
    daneR(3*(i-1)+2) = frf{1,3}(i);
    daneR(3*(i-1)+3) = frf{1,5}(i);
    daneI(3*(i-1)+1) = frf{1,2}(i);
    daneI(3*(i-1)+2) = frf{1,4}(i);
    daneI(3*(i-1)+3) = frf{1,6}(i);
end
dataP1 = complex(daneR,daneI);

% Punkt 2
for i = 1:342
    daneR(3*(i-1)+1) = frf{2,1}(i);
    daneR(3*(i-1)+2) = frf{2,3}(i);
    daneR(3*(i-1)+3) = frf{2,5}(i);
    daneI(3*(i-1)+1) = frf{2,2}(i);
    daneI(3*(i-1)+2) = frf{2,4}(i);
    daneI(3*(i-1)+3) = frf{2,6}(i);
end
dataP2 = complex(daneR,daneI);

% Punkt 3
for i = 1:342
    daneR(3*(i-1)+1) = frf{3,1}(i);
    daneR(3*(i-1)+2) = frf{3,3}(i);
    daneR(3*(i-1)+3) = frf{3,5}(i);
    daneI(3*(i-1)+1) = frf{3,2}(i);
    daneI(3*(i-1)+2) = frf{3,4}(i);
    daneI(3*(i-1)+3) = frf{3,6}(i);
end
dataP3 = complex(daneR,daneI);

%% Allocate processed data to column variable names
data1 = dataP1;
data2 = dataP2;
data3 = dataP3;