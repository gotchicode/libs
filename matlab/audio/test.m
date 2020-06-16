clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%First part no interpolation (96KHz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Read the file
filename='audio.wav';
fileinfo=audioinfo(filename);
dataraw = audioread(filename);

%Sample to cancel
data = dataraw(110*96000:115*96000);

%This is the inverse
data_inv=-1*data;

%Data to sum
data_to_sum=[0 data_inv(1:end-1)];

%Data compensated without resampling
data_comp = data+data_to_sum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Second part with interpolation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Data stuff with zero by 10
data_stuffed = zeros(1,length(data)*10);
index=1;
for k=1:length(data)
  data_stuffed(index)=data(k);
  index=index+10;
end

%Load filter parameter
fir_tap=csvread('ovr10_taps.txt');

%Filter
data_stuffed_filtered=filter(fir_tap,1,data_stuffed);

%Inv
data_stuffed_filtered_inv=-1*data_stuffed_filtered;
%Data to sum
data_to_sum_ovr10=[0 data_stuffed_filtered_inv(1:end-1)];
%Data compensated without resampling
data_comp_ovr10 = data_stuffed_filtered+data_to_sum_ovr10;

%Filter another time
data_comp_filtered=filter(fir_tap,1,data_comp_ovr10);

%Downsample
data_decim_back=data_comp_filtered(1:10:end);


##data_fft=20*log10(abs(fftshift(fft(data))));
##x_data_fft=linspace(-96000/2,96000/2,length(data_fft));
##plot(x_data_fft,data_fft);

player = audioplayer (data_decim_back, 96000, 16);
play (player);
printf('end\n');