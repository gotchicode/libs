clc;
clear all;
close all;

%Parameters
Fsamp = 6400;
nb_size = 2^14;

%Read file
taps = csvread('taps.txt');

%Frequency response
h_taps = 20*log10(abs(freqz(taps,1,nb_size)));

figure(1);
x_axis =(0:Fsamp/2/length(h_taps):Fsamp/2-Fsamp/2/length(h_taps)).';
plot(x_axis,h_taps);
xlabel('MHz')
ylabel('dB')