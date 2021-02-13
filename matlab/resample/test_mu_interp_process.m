%This function is a test implementation of the mu_interp_process function

clc;
clear all;
close all;

%Parameters
nb_size = 2^10;

%Interp param
ovr=8;
Fin=25e6;
Fout=100e6;
debug=0;
interp_type=3; %0:Linear %1:Cosine %2:Cubic %3:Cubic Paul Breeuwsma

%Data in generation
##data_in = round(rand(1,nb_size));
data_in =2*(round(rand(1,nb_size))-0.5);

%Upsasample by 8 zeros
data_IQ_ovr = zeros(1,length(data_in)*ovr);
data_IQ_ovr(1:ovr:end)=data_in;

%Load taps and filter
taps=csvread('taps.txt');
data=filter(taps,1,data_IQ_ovr);

%Interpolate
data_out = mu_interp_process(data,Fin,Fout,debug,interp_type);

##figure(1)
##plot(data_in);
##
##figure(2)
##plot(data);
##
##figure(3)
##plot(data_out); 

%-----------------------------------------
%-- Display FFT
%-----------------------------------------
data_fft=20*log10(abs(fftshift(fft(data))));
data_fft_max=max(data_fft);
data_fft=data_fft-data_fft_max;

data_out_fft=20*log10(abs(fftshift(fft(data_out))));
data_out_fft_max=max(data_out_fft);
data_out_fft=data_out_fft-data_out_fft_max;

##data_fft=20*log10(abs(fftshift(fft(data))));
##data_out_fft=20*log10(abs(fftshift(fft(data_out(end-2^16-1:end)))));

figure(1);
plot(data_fft);

figure(2);
plot(data_out_fft);


%-----------------------------------------
%-- Display EYE DIAGRAM
%-----------------------------------------
eyediagram (data_out(nb_size/2+1:end), ovr*8*2);