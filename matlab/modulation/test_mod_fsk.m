clc;
clear all;
close all;

%Initialize a rand seed
rand('state',1);

%Test parameters
nb_size=2^12;

%Modulation parameters
ovr=8; %oversampliing factor
fsk_deviation=0.35

%Data generation
data_in = round(rand(1,nb_size));

%Modulate in FSK
phase_in=0;
[mod_signal,mod_signal_phase_out]=mod_fsk(data_in,phase_in,ovr,fsk_deviation);

%Prepare Display
x_axis=linspace(-ovr/2,ovr/2,nb_size*ovr);
fft_done=20*log10(abs(fftshift(fft(mod_signal))));
max_fft_done=max(fft_done);
fft_done=fft_done-max_fft_done;

%Display
figure(1);
plot(x_axis,fft_done);