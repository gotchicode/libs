clc;
clear all;
close all;

%Parameters
nb_size = 2^10;
fsamp = 96e3;
fsig = 5000;
delay=1;

%Create samples
t=(1/fsamp:1/fsamp:nb_size/fsamp);
sig=sin(2*pi*fsig*t);

%Cancel
sig_d1=[zeros(1,delay) sig(1:end-delay)];
total_sig= sig - sig_d1;

mean(abs(sig)) / mean(abs(total_sig))