%This function is a test implementation of the mu_interp_process function

clc;
clear all;
close all;

%Parameters
nb_size = 2^6;

%Interp param
ovr=16;
Fin=100e6;
Fout=10e6;
debug=1;
interp_type=3; %0:Linear %1:Cosine %2:Cubic %3:Cubic Paul Breeuwsma

%Data in generation (sinus)
t=(1/ovr:1/ovr:nb_size/ovr);
data_in=sin(2*pi*t);
data=data_in;

%Interpolate
data_out = mu_decim_process(data,Fin,Fout,debug,interp_type);

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
eyediagram (data_out(nb_size/2+1:end), ovr*2);