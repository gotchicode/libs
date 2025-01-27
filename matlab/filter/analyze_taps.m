clc;
clear all;
close all;

%Fsamp
Fsamp=2e6;
nb_samp=1024;

%File
taps=csvread("taps.txt");

%Normalize
taps_max=sum(taps);
taps=taps*1/taps_max;

%Frequency response
h_taps = 20*log10(abs(freqz(taps,1,nb_samp)));

figure(1);
x_axis=linspace(0,Fsamp/2,nb_samp);
plot(x_axis,h_taps);
xlabel('Frequency response');
ylabel('dB');
grid on;