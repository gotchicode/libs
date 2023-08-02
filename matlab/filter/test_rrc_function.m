clc;
clear all;
close all;

%RRC Parameters
Fsymb = 1;
Fsamp = 1024;
roll_off = 1;

%Implementation taps (signed)
n_bits=8;

%Calculate RRC taps
h = rrc_function(Fsymb, Fsamp, roll_off);


%Quantisize Taps
h_in = h* 1.23456789; %try a gain
[h_quant,h_quant_gain] = filter_tap_quant(h_in, n_bits);


##%Plot the taps
##figure(1);
##t=(-4:1/Fsamp:4);
##x_axis = t;
##plot(x_axis,h);
##title('root raised cosine filter taps');

%Plot the reponse of h
figure(2);
freqz(h,1,512);

figure(3);
freqz(h_quant/h_quant_gain,1,512);