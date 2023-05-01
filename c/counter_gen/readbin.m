clc;
clear all;
close all;;

filename = '131072';  % Replace with the name of your binary file

% Open the file and read in the data
fid = fopen(filename, 'rb');
data = fread(fid, Inf, 'uint16');
fclose(fid);

hexdata=dec2hex(data,4);
