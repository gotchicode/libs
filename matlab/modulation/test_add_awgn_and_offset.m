clc;
clear all;
close all;

%Parameters
nb_size=2^13;
snr_dB=100;
snr=10^(snr_dB/10);
use_seed=0;
display=1;

%Generate input signal
data_in_sequence = 2*(round(rand(1,nb_size))-0.5);

%generate and offsset frequency
t=(1:nb_size);
delta_f=1/1;
offset=cos(2*pi*delta_f*t)+j*sin(2*pi*delta_f*t);

%Add AWGN and offset
data_with_noise=add_awgn(data_in_sequence,snr,use_seed,display);
data_with_noise=data_with_noise.*offset;

%Argument
data_with_noise_phase=diff(mod(angle(data_with_noise),pi));

%Measure
mean_of=mean(abs(data_with_noise));
std_of=std(abs(data_with_noise));
snr_measured=mean_of.^2/std_of.^2;
snr_measured_dB=10*log10(snr_measured);

%Plot
figure(1)
plot(data_with_noise,'o');
axis([-1.5 1.5 -1.5 1.5])

##figure(2)
##plot(data_with_noise_phase);