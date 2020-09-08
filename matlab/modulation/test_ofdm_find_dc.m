clc;
clear all;
close all;
rand("state",0);

%Parameters
Nfft=64;
Ngsbc=2;
Ndc=1;
Npilotspacing=2;
Npilotspacingsymb2symb=2;
Nsymbperframe=10;

%Generate input signal
data_in_sequence = 2*(round(rand(1,Nfft-Ndc-Ngsbc))-0.5); %-1 because of DC
data_in_sequence = [0 data_in_sequence]; %First index is DC

%OFDM symbol structure
[ofdm_frame_struct,nb_data,nb_gsbcdc,nb_pl]=generate_ofdm_frame_struct(Nfft, Ngsbc, Ndc, Npilotspacing, Npilotspacingsymb2symb, Nsymbperframe);

%IFFT to time domain
ofdm_symb=ifft(data_in_sequence);

%Add DC component
ofdm_symb=ofdm_symb+1/512*2;

%FFT back to frequency domain
data_recovered=fft(ofdm_symb); %DC=2 in the index 2
data_recovered_shift=fftshift(data_recovered); %DC=2 goes to Nfft/2+1 index

%Display
figure(1);
plot(real(data_in_sequence));
figure(2);
plot(real(data_recovered));
figure(3);
plot(real(data_recovered_shift));
