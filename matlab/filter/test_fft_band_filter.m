clc;
clear all;
close all;

%Addpath
addpath ("../modulation");
addpath ("../pn");

%Parameters
nb_size=2^10;
modu='BPSK';
interp_factor=100;

%Persistant registers
in_enc_table = zeros(1,nb_size)+1;
in_enc_shift_reg = zeros(1,23);
out_enc_shift_reg = zeros(1,23);

%Generate input signal
data_in_sequence = pn_23_enc_1b(in_enc_table, in_enc_shift_reg, out_enc_shift_reg);

%Modulate
data_modulated=mapper(data_in_sequence,modu);

%Upsample x50
data_modulated_ovr = zeros(1,length(data_modulated)*interp_factor);
for m=1:interp_factor
  data_modulated_ovr(m:interp_factor:end)=data_modulated;
end

%Create a carrier 1
t=(1/interp_factor:1/interp_factor:nb_size/interp_factor);
carrier1=cos(2*pi*5.*t)+j*sin(2*pi*5.*t);

%Create a carrier 2
t=(1/interp_factor:1/interp_factor:nb_size/interp_factor);
carrier2=cos(2*pi*10.*t)+j*sin(2*pi*10.*t);

%Display FFT
x_axis=linspace(-interp_factor/2,interp_factor/2,length(data_modulated));
fft_sig = 20*log10(abs(fftshift(fft(data_modulated))));
plot(x_axis,fft_sig);
