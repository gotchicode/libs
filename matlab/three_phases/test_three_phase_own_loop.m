clc;
clear all;
close all;

%Simu param
nb_size=2^14;

%Parameters
Fsamp=50*64;
Fsig=50;
Amp=1;

%Init time sequence
t=(1/Fsamp:1/Fsamp:nb_size/Fsamp);

%Generate input signal
Va = Amp * sin(2*pi*Fsig*t);
Vb = Amp * sin(2*pi*Fsig*t-2*pi/3);
Vc = Amp * sin(2*pi*Fsig*t+2*pi/3);

%Generate a coarse complex translate signals
Fcarrier = Fsig;
Va_carrier = Amp * [ cos(2*pi*Fcarrier*t) + j*sin(2*pi*Fcarrier*t) ];

%Perform the translation
Va_translated = Va.*(-1*Va_carrier);

%Filter
taps = csvread('taps.txt');
Va_translated_filtered = conv(Va_translated,taps);
Va_translated_filtered = Va_translated_filtered(end-nb_size+1:end);

##plot(angle(Va_translated_filtered));

##
##%Generate a local phase
##f_teta=Fsig*1.001;
##theta = 2*pi*f_teta/Fsamp:2*pi*f_teta/Fsamp:2*pi*f_teta/Fsamp*nb_size;
##theta = mod(theta,2*pi);
##local_phase=cos(theta)+j*sin(theta);
##
##%Correct
##error_phase=Va.*(-1*local_phase);
##
##%Filter it
##taps = csvread('taps.txt');
##error_phase_filtered = conv(error_phase,taps);
##error_phase_filtered = error_phase_filtered(end-nb_size+1:end);
##error_phase_filtered_angle = angle(error_phase_filtered);
##
##%Loop
##
##
FFT
fft_in=Va_translated_filtered;
x_axis = (-Fsamp/2:Fsamp/nb_size:Fsamp/2-Fsamp/nb_size);
local_phase_fft = 20 * log10(fftshift(abs(fft(fft_in))));
plot(x_axis,local_phase_fft)

