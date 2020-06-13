clc;
clear all;
close all;

%Read file
taps = csvread('taps.txt');

%Parameter
nb_iter=4;

%Normalize
taps_max=max(taps);
taps=taps*1/max(taps);

%Quant taps
[taps_raw_quant,taps_quant] =  taps_to_pw2(taps,nb_iter);

%Plot taps
figure(1);
plot(taps);
hold on;
plot(taps_quant);

%Frequency response
h_taps = 20*log10(abs(freqz(taps,1,512)));
h_taps_quant=20*log10(abs(freqz(taps_quant,1,512)));

figure(2);
x_axis =(0:0.5/length(h_taps_quant):0.5-0.5/length(h_taps_quant)).';
plot(x_axis,h_taps);
hold on;
plot(x_axis,h_taps_quant);
xlabel('Normalized frequency')
ylabel('dB')
legend('Ideal taps','Quantized taps')