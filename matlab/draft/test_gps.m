clc;
clear all;
close all;

rand("state",0);

%Parameter
nb_size=16;
Fchip=1.023e6;
Foffset=0.00001*Fchip;
phase_select1=3;
phase_select2=6;

%Generate a code
CA_code = CA_code_gen(phase_select1,phase_select2);
CA_code_sign=CA_code*2-1;

%Generate a random stream
data=round(rand(1,nb_size));

%Spread
data_spread = spread(data,CA_code);

%Frequency shift
t=(1/Fchip:1/Fchip:length(data_spread)/Fchip);
carrier_shifted=cos(2*pi*Foffset.*t);
data_spread=data_spread.*carrier_shifted;

%Find frequency offset
k_shift=0;
shift_border=10e3;
shift_step=1e3;
find_freq_offset_result=zeros(shift_border*2/shift_step,length(data_spread)-1023);
CA_code_sign_FFT_pattern=fftshift((fft(CA_code_sign)));

for shift=-shift_border:shift_step:shift_border
  
  data_spread_unshift=data_spread.*cos(-2*pi*shift.*t);
  k_shift=k_shift+1;

  fprintf('Processing %f shift\n',shift);
  
  for k=1:length(data_spread_unshift)-1023
    tmp=data_spread_unshift(k:k+1023-1);
    tmp_fft=fftshift((fft(tmp)));
    tmp_cor=abs(sum(CA_code_sign_FFT_pattern.*conj(tmp_fft)));
    find_freq_offset_result(k_shift,k)=tmp_cor;
  end
  
end

%Prepare 3 plots
tx =  linspace (-shift_border, shift_border, shift_border*2/shift_step+1)';
ty =  (1:length(data_spread)-1023)';
tz = find_freq_offset_result';
[xx, yy] = meshgrid (tx, ty);
mesh (tx, ty, tz);
xlabel ("frequency");
ylabel ("sample");
zlabel ("correlation");
title ("3-D Sombrero plot");

