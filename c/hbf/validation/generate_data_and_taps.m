clc;
clear all;
close all;

%Generate hbf taps
%From https://www.dsprelated.com/showarticle/1113.php
ntaps= 33;
N= ntaps-1;
n= -N/2:N/2;
sinc= sin(n*pi/2)./(n*pi+eps);      % truncated impulse response; eps= 2E-16
sinc(N/2+1)= 1/2;                  % value for n --> 0
win= kaiser(ntaps,6);               % window function
b= sinc.*win';


%Quantization
b_quant = round(b*2^12);

%Generate random table of data
data_in = round(rand(1,2048)*2^12)-2^11;

%Write to file
fid = fopen('data_in.txt','w');
for k=1:length(data_in)
  fprintf(fid,'%d\n',data_in(k));
end
fclose(fid);

%Write to file
fid = fopen('taps.txt','w');
for k=1:length(b_quant)
  fprintf(fid,'%d\n',b_quant(k));
end
fclose(fid);

%Check
data_out = conv(data_in,b_quant);

%FFT
fft_in = data_out;
fft_out = 20*log10(abs(fftshift(fft(fft_in))));

%Display
plot(fft_out);

