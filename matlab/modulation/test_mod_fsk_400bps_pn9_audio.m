clc;
clear all;
close all;


%Modulation parameters
%Audio is 44800 Hz.
%Bitrate is 400 bps
%Carrier frequency is 2000 Hz
%Deviation is
fs=44800;
fc=2000;
ovr=112; %oversampling factor
fsk_deviation=0.5; %Percentage of the bitrate which is referenced as 1

%Load a PN9
data_in = csvread("../pn/pn9.txt");

%Modulate, for his case the phase is continuous
phase_in=0;
[mod_signal,mod_signal_phase_out]=mod_fsk(data_in,phase_in,ovr,fsk_deviation);

% Time vector
t = (0:length(mod_signal)-1) / fs; 

% Frequency translation: shift baseband to 2 kHz
mod_signal_rf = real(mod_signal .* exp(1*j*2*pi*fc*t)); 

%Display signal
figure(2);
subplot(311);
plot(data_in(1:16));
subplot(312);
plot(real(mod_signal(1:ovr*16)));
subplot(313);
plot(imag(mod_signal(1:ovr*16)));

% Plot modulated signal
figure(3);
plot(t(1:1000), mod_signal_rf(1:1000));
xlabel('Time (s)');
ylabel('Amplitude');
title('FSK Signal on 2 kHz Carrier');