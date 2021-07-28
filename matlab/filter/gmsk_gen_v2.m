clc;
clear all;
close all;

%Parameters
BT=0.3; Tb=1; L=4; k=2;

%Impl parameter
nb_quant=2^7;

%---------------------------------------
% Ideal
%---------------------------------------

%From https://gaussianwaves.com/ ebook
h=gmsk_function(BT, Tb, L, k);

%Work out the reponse of ideal filter
h_freq = 20*log10(abs(freqz(h,1,512)));
h_x_axis = (0:0.5/length(h_freq):0.5-0.5/length(h_freq)).';

%---------------------------------------
% Quant
%---------------------------------------
max_h = max(h)
h_quant = h/max_h;
h_quant = round(h_quant*(nb_quant-1));

%Work out the reponse of ideal filter
h_quant_freq = 20*log10(abs(freqz(h_quant,1,512)));
h_quant_x_axis = (0:0.5/length(h_quant_freq):0.5-0.5/length(h_quant_freq)).';

%---------------------------------------
%Display
%---------------------------------------
figure(1);
plot(h_x_axis,h_freq);
hold on;
plot(h_quant_x_axis,h_quant_freq-max(h_quant_freq));

