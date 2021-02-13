clc;
clear all;
close all;

%--------------------------------------
% Addpath
%--------------------------------------
addpath ("../modulation");
addpath ("../pn");

%--------------------------------------
% Parameters
%--------------------------------------
nb_size=2^12;
modu='QPSK';
interp_factor=8;
filter_mode=1;

%--------------------------------------
% Modulator
%--------------------------------------
%Persistant registers
in_enc_table = zeros(1,nb_size)+1;
in_enc_shift_reg = zeros(1,23);
out_enc_shift_reg = zeros(1,23);

%Generate input signal
data_in_sequence = pn_23_enc_1b(in_enc_table, in_enc_shift_reg, out_enc_shift_reg);

%Modulate
data_modulated=mapper(data_in_sequence,modu);

%Emision filter - from symbol rate to x8 symbol rate
taps=csvread('taps_rrc_rolloff_0_5_over_8.txt');
nb_taps=length(taps);
[data_modulated_filtered,data_modulated_ovr] = up_and_filter(data_modulated,interp_factor,filter_mode,taps);

%Add a gain to balance over sampling
data_modulated_filtered = data_modulated_filtered*interp_factor;

%--------------------------------------
% Channel
%--------------------------------------
data_modulated_filtered_channel=data_modulated_filtered;

%resample
Fin=1e6;
Fout=1e6+600;
debug_param=0;
interp_type=3;
data_modulated_filtered_channel = mu_interp_process(data_modulated_filtered_channel,Fin,Fout,debug_param,interp_type);

%--------------------------------------
% Receiver
%--------------------------------------
data_received=data_modulated_filtered_channel;

%Filter RRC
data_received_filtered=filter(taps,1,data_modulated_filtered_channel);


%--------------------------------------
% Display
%--------------------------------------

%plot received I
figure(1);
plot(real(data_received_filtered));

%Plot eye diagram
data_received_filtered_eye_diagram = data_received_filtered(end/2+1:end);
eyediagram (data_received_filtered_eye_diagram, interp_factor*2)

%Plot constellation
figure(3);
plot(data_received_filtered_eye_diagram);

%Plot FFT
figure(4);
x_axis=linspace(-interp_factor/2,interp_factor/2,length(data_received_filtered_eye_diagram));
plot(x_axis,20*log10(abs(fftshift(fft(data_received_filtered_eye_diagram))))-max(20*log10(abs(fftshift(fft(data_received_filtered_eye_diagram))))));


