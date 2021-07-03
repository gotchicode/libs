clc;
clear all;
close all;

%Initialize a rand seed
rand('state',1);

%Test parameters
nb_size=2^12;

%Modulation parameters
ovr=16; %oversampliing factor 2bit per ovr in MSK
msk_deviation=0.5;

%Data generation
data_in = round(rand(1,nb_size));

%Modulate in MSK
phase_init_I=0;
phase_init_Q=0;
[mod_signal,phase_store_I,phase_store_Q]=mod_msk(data_in,phase_init_I,phase_init_Q,ovr,msk_deviation);

%Prepare Display
x_axis=linspace(-ovr/2,ovr/2,length(mod_signal));
fft_done=20*log10(abs(fftshift(fft(mod_signal))));
max_fft_done=max(fft_done);
fft_done=fft_done-max_fft_done;

%Display
figure(1);
plot(x_axis,fft_done);