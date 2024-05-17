clc;
clear all;
close all;

%Parameters
nb_size=2^13;
snr_dB=42;
snr=10^(snr_dB/10);
use_seed=0;
display=1;

%Generate input signal
data_in_sequence = 2*(round(rand(1,nb_size))-0.5);
data_in_sequence = zeros(1,nb_size)+1024;

%Add AWGN
##data_with_noise=add_awgn(data_in_sequence,snr,use_seed,display);
data_with_noise = add_awgn_noise(data_in_sequence,snr_dB);

%Round the noise to quantify it
data_with_noise = round(data_with_noise);

%Measure
mean_of=mean(abs(data_with_noise));
std_of=std(abs(data_with_noise));
snr_measured=mean_of.^2/std_of.^2;
snr_measured_dB=10*log10(snr_measured);

##Plot
plot(real(data_with_noise),'.');