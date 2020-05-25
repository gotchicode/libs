clc;
clear all;
close all;

%Param
nb_size = 2^12; 

%Input gen
test_in = rand(1,nb_size);

%Timestamp
localtime_start_DFT = (time());

%my fft
test_my_fft_out=my_fft(test_in,nb_size);

%Timestamp
localtime_end_DFT = (time());
fprintf("Time for calc of my fft=%f\n",localtime_end_DFT-localtime_start_DFT);

%FFT
localtime_start_DFT = (time());
test_fft_out=fft(test_in);
localtime_end_DFT = (time());
fprintf("Time for calc of octave fft=%f\n",localtime_end_DFT-localtime_start_DFT);

##%difference
##plot(abs(test_my_fft_out)-abs(test_fft_out));

figure(1)
plot(real(test_my_fft_out));
hold on;
plot(real(test_fft_out));

figure(2)
plot(imag(test_my_fft_out));
hold on;
plot(imag(test_fft_out));

figure(3)
plot(real(test_my_fft_out) - real(test_fft_out));
plot(imag(test_my_fft_out) - imag(test_fft_out));