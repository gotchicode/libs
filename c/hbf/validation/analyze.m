clc;
clear all;
close all;

%Import
data = csvread("data_out.txt");

%FFT
fft_in = data;
fft_out = 20*log10(abs(fftshift(fft(fft_in))));

%Display
plot(fft_out);
