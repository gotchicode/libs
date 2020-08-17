clc;
clear all;
close all;

%Parameters
nb_size=2^10;
snr=10^(20/20);
use_seed=1;
display=1;

%Generate input signal
data_in_sequence = 2*(round(rand(1,nb_size))-0.5);

%Add AWGN
data_with_noise=add_awgn(data_in_sequence,snr,use_seed,display);

%Plot
plot(data_with_noise,'.');