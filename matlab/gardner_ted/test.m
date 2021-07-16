clc;
clear all;
close all;


addpath('../modulation');

%Parameters
nb_size = 2^11;
modu='BPSK';
modu_fact=1/modu_bps(modu);

%Interp param
mod_ovr=128;

%Data in generation
##data_in = round(rand(1,nb_size));
tmp = [1 0];
data_in= repmat(tmp,1,nb_size/2);
##data_in=round(rand(1,nb_size));

%Modulate
data_modulated=mapper(data_in,modu);

%Emision filter - from symbol rate to x128 symbol rate
taps_x128=csvread('taps_x128.txt');
nb_taps=length(taps_x128);
[data_modulated_filtered,data_modulated_ovr] = up_and_filter(data_modulated,mod_ovr,1,taps_x128);
data_modulated_filtered_transmit = data_modulated_filtered;

%Downsample by 2 to x64 symbol rate
sample_offset=1; %Offset=1 is default %128 is half symbol
data_modulated_filtered_transmit_x64=data_modulated_filtered_transmit(sample_offset:2:end);

%Reception filter - at symbol rate  x64 symbol rate
taps_x64=csvread('taps_x64.txt');
nb_taps=length(taps_x64);
data_modulated_filtered_reception = filter(taps_x64,1,data_modulated_filtered_transmit_x64);

%Decimate at symbol rate x2
data_modulated_filtered_frontend=data_modulated_filtered_reception(1:32:end);

%Select data for Gardner from start bitand
data_TED_in=data_modulated_filtered_frontend(1:end);

%Perform the Gardner TID
TED_error=zeros(1,length(data_TED_in));
for k=1:2:length(data_TED_in)-3
  TED_error_real(k) = [real(data_TED_in(k+2))-real(data_TED_in(k))]*real(data_TED_in(k+1));
end

##%Eye diagram at Emision filter x128
##eyediagram_in=data_modulated_filtered_transmit(end/2+1:end);
##eyediagram(eyediagram_in, mod_ovr*2);

##%Eye diagram at Emision filter x64
##eyediagram_in=data_modulated_filtered_transmit_x64(end/2+1:end);
##eyediagram(eyediagram_in, mod_ovr/2);

%Eye diagram at Reception x64
##eyediagram_in=data_modulated_filtered_reception(end/2+1:end);
##eyediagram(eyediagram_in, mod_ovr);

%Eye diagram at Reception x2
eyediagram_in=data_modulated_filtered_frontend(end/2+1:end);
eyediagram(eyediagram_in, mod_ovr/16);

##plot(TED_error_real,'.');