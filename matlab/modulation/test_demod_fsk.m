clc;
clear all;
close all;

%Initialize a rand seed
rand('state',1);

%Test parameters
nb_size=2^12;
modulation=2; % 0: FSK; 1: MSK; 2: GMSK

%Modulation parameters
ovr=64; %oversampliing factor

%Data generation
data_in = round(rand(1,nb_size));

%Modulate
phase_in=0;
switch modulation
    case 0
        deviation=0.35;
        [mod_signal,mod_signal_phase_out]=mod_fsk(data_in,phase_in,ovr,deviation);
  case 1
        deviation=0.5;
        [mod_signal,mod_signal_phase_out]=mod_msk(data_in,phase_in,phase_in,ovr,deviation);
  case 2
        gmsk_deviation=0.5; %This should no be changed for GMSK
        BT=0.3; %GMSK BT
        [mod_signal,phase_store_I,phase_store_Q,data_debug]=mod_gmsk(data_in,phase_in,phase_in,ovr,gmsk_deviation,BT);
    otherwise
end

%---------------------------------------
%Channel
%---------------------------------------
snr_dB= 30;
snr = 10^(snr_dB/20);
mod_signal = add_awgn(mod_signal,snr,0,0);

%---------------------------------------
%Demodulate
%---------------------------------------

%Discriminator
demod_phase = angle(mod_signal);

%Discriminator - phase unwrap
demod_phase_unwrap = unwrap(demod_phase);

%Phase_difference
demod_phase_difference = diff(demod_phase_unwrap);


%Prepare Display
x_axis=linspace(-ovr/2,ovr/2,nb_size*ovr);
fft_done=20*log10(abs(fftshift(fft(mod_signal))));
max_fft_done=max(fft_done);
fft_done=fft_done-max_fft_done;

%Display
figure(1);
plot(x_axis,fft_done);

%Display signal modulator
figure(2);
subplot(311);
plot(data_in(1:32));
subplot(312);
plot(real(mod_signal(1:ovr*32)));
subplot(313);
plot(imag(mod_signal(1:ovr*32)));

%Display signal demodulator
figure(3);
subplot(311);
plot(demod_phase(1:ovr*32));
subplot(312);
plot(demod_phase_unwrap(1:ovr*32));
subplot(313);
plot(demod_phase_difference(1:ovr*32));
