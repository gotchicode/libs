clc;
clear all;
close all;

%Parameters
Fsamp = 6400;
nb_size = 2^14;
quant = 2^17-1;

%Read file
taps = csvread('taps.txt');
taps_quant = round(taps*quant);

%Frequency response ideal
h_taps = 20*log10(abs(freqz(taps,1,nb_size)));

%Frequency response quant
h_taps_quant = 20*log10(abs(freqz(taps_quant,1,nb_size)));
h_taps_quant_max = max(h_taps_quant);
h_taps_quant=h_taps_quant-h_taps_quant_max;

figure(1);
x_axis =(0:Fsamp/2/length(h_taps):Fsamp/2-Fsamp/2/length(h_taps)).';
plot(x_axis,h_taps);
hold on;
plot(x_axis,h_taps_quant);
xlabel('MHz')
ylabel('dB')
legend('Ideal taps','Quantized taps')