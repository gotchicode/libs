clc;
clear all;
close all;


%Parameters
nb_size=2^11;
carrier_freq=70e6;
am_freq=1e6;
am_depth=10; %in percent
samp_freq=1e9;

%Init vectors
t=(1/samp_freq:1/samp_freq:nb_size/samp_freq);

%Generate the carrier signal
carrier=cos(2*pi*carrier_freq*t);

%Generate the AM signal
am_signal=cos(2*pi*am_freq*t);
am_signal=(am_signal*(am_depth/2)+(am_depth/2))+(100-am_depth);
am_signal = am_signal/100;

%Modulate the carrier by AM
modulated_carrier=carrier.*am_signal;

%IQ demod signals init
I_cos=cos(2*pi*carrier_freq*1.001*t+rand*2*pi);
Q_sin=sin(2*pi*carrier_freq*1.001*t+rand*2*pi);

##%Hilbert kernel
##H_size=33;
##H_kernel(1:2:H_size)=0;
##H_kernel(2:2:H_size)=1./2./pi./(2:2:H_size);

%IQ demod
I_demod=modulated_carrier.*I_cos;
Q_demod=modulated_carrier.*Q_sin;

%Filter
taps=csvread('taps.txt');
I_demod=filter(taps,1,I_demod);
Q_demod=filter(taps,1,Q_demod);

%ABS
absval=(I_demod.^2+Q_demod.^2);

##%FFT of modulated_carrier
##figure(1);
##fft_signal=20*log10(abs(fftshift(fft(modulated_carrier))));
##x_axis=linspace(-samp_freq/2,samp_freq/2,nb_size);
##plot(x_axis,fft_signal);
##
##%FFT of I and Q
##figure(2);
##fft_signal=20*log10(abs(fftshift(fft(I_demod))));
##x_axis=linspace(-samp_freq/2,samp_freq/2,nb_size);
##plot(x_axis,fft_signal);

figure(3);
##plot(I_demod);
##hold on;
##plot(Q_demod);
plot(absval);





