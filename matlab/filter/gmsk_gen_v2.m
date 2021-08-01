clc;
clear all;
close all;

%Parameters
BT=0.3; Tb=1; L=8; k=2;

%Impl parameter
nb_quant=2^15;

%---------------------------------------
% Ideal
%---------------------------------------

%From https://gaussianwaves.com/ ebook
h=gmsk_function(BT, Tb, L, k);

%Work out the reponse of ideal filter
h_freq = 20*log10(abs(freqz(h,1,512)));
h_x_axis = (0:0.5/length(h_freq):0.5-0.5/length(h_freq)).';

%---------------------------------------
% Quant without gain correction
%---------------------------------------
max_h = max(h);
h_quant = h/max_h;
h_quant = round(h_quant*(nb_quant-1));

%Work out the reponse of ideal filter
h_quant_freq = 20*log10(abs(freqz(h_quant,1,512)));
h_quant_x_axis = (0:0.5/length(h_quant_freq):0.5-0.5/length(h_quant_freq)).';

%---------------------------------------
% Quant without with correction
%---------------------------------------
fprintf('The gain of the quantified filter is %f\n',10^(max(h_quant_freq)/20));
fprintf('Closest log 2 gain is %f\n',2^floor(log2(10^(max(h_quant_freq)/20))) );
fprintf('The ratioi s %f\n', 2^floor(log2(10^(max(h_quant_freq)/20))) /  10^(max(h_quant_freq)/20) );
ratio_gain = 2^floor(log2(10^(max(h_quant_freq)/20))) /  10^(max(h_quant_freq)/20);

h_quant_comp = h/max_h*ratio_gain;
h_quant_comp = round(h_quant_comp*(nb_quant-2));

%Work out the reponse of ideal filter
h_quant_comp_freq = 20*log10(abs(freqz(h_quant_comp,1,512)));
h_quant_comp_x_axis = (0:0.5/length(h_quant_comp_freq):0.5-0.5/length(h_quant_comp_freq)).';
fprintf('The gain of the quantified compensated filter is %f\n',10^(max(h_quant_comp_freq)/20));

%---------------------------------------
%Display
%---------------------------------------
figure(1);
plot(h_x_axis,h_freq);
hold on;
plot(h_quant_x_axis,h_quant_freq-max(h_quant_freq));

%---------------------------------------
%Export parameters and taps to a text file
%---------------------------------------
fid=fopen('../../vhdl/modulator/sim/taps.txt','w');
fprintf(fid,'%d\n',floor(log2(10^(max(h_quant_freq)/20)))); %Print the gain
fprintf(fid,'%d\n',L*4+1); %Print the number of of taps
fprintf(fid,'%d\n',L); %Print the interpolation ratio
for k=1:length(h_quant_comp)
 fprintf(fid,'%d\n',h_quant_comp(k));
end
fclose(fid);

