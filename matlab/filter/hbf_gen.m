clc;
clear all;
close all;

%Read file
taps = csvread('hbf_taps.txt');

%Normalize
taps_max=max(taps);
taps=taps*1/max(taps);

%Frequency response
h_taps = 20*log10(abs(freqz(taps,1,512)));

%Figure 1
figure(1);
x_axis =(0:0.5/length(h_taps):0.5-0.5/length(h_taps)).';
plot(x_axis,h_taps);
grid on;
xlabel('Normalized frequency')
ylabel('dB')
legend('Ideal taps')