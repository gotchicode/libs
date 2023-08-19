clc;
clear all;
close all;

%External paths
addpath ("../filter");
addpath ("../polyphase");
addpath ("../resample");
addpath ("../modulation");
addpath ("../misc");

%Load pkg
pkg load communications

%Parameters
nb_bits = 2^10; %vector length
modu='BPSK';
nb_symb=modu_bps(modu);
n_bits = 16; %quantization tap bits
roll_off = 0.5;
Fsymb=1;
Fsamp=32;

%Generate input signal
data_in_sequence = (round(rand(1,nb_bits)));

%Modulate
data_modulated=mapper(data_in_sequence,modu);

#%Calculate RRC taps
h = rrc_function(Fsymb, Fsamp, roll_off);
[h_quant,h_quant_gain] = filter_tap_quant(h, n_bits);
h_quant = h_quant/h_quant_gain*Fsamp/Fsymb;

%Upsample and RRC filter TX
data_tx_filtered_signal = interpolate_with_zeros(data_modulated, Fsamp/Fsymb);
data_tx_filtered_signal = conv(data_tx_filtered_signal,h_quant);

%Upsample and RRC filter RX
data_rx_filtered_signal = conv(data_tx_filtered_signal,h_quant);
data_rx_filtered_signal = data_rx_filtered_signal(33:end);


figure(1);
EYE_DIAG_data_rx_filtered_signal = eye_diag(data_rx_filtered_signal,Fsamp/Fsymb*2);
x_axis = linspace(-Fsamp/Fsymb,Fsamp/Fsymb,Fsamp/Fsymb*2);
plot(x_axis,real(EYE_DIAG_data_rx_filtered_signal(:,end-(1024+1024):end-1024)));

##eyediagram (data_rx_filtered_signal, (Fsamp/Fsymb)*2);


