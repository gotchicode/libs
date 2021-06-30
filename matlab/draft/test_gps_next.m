clc;
clear all;
close all;

addpath ("../resample");

rand("state",0);

%Parameter
nb_size=32;
Fchip=1.023e6;
Foffset=0.0001*Fchip;
Soffset=0.0001*Fchip;
phase_select1=3;
phase_select2=6;

%Generate a code
CA_code = CA_code_gen(phase_select1,phase_select2);
CA_code_sign=CA_code*2-1;

%Generate a random stream
data=round(rand(1,nb_size));

%Spread
data_spread = spread(data,CA_code);

%Phase or frequency shift
##t=(1/Fchip:1/Fchip:length(data_spread)/Fchip);
##carrier_shifted=cos(2*pi*Foffset.*t)+j*sin(2*pi*Foffset.*t);
##data_spread=data_spread.*carrier_shifted;

%Sample resampling (cubic)
Fin=Fchip;
Fout=Fin+Soffset;
data_spread=mu_interp_process(data_spread,Fin,Fout,0,3);

%Make the correlations
for k=1:length(data_spread)-length(CA_code_sign)+1
  tmp_a=data_spread(k:k+length(CA_code_sign)-1);
  tmp_b=CA_code_sign;
  conv_result(k)=sum(tmp_a.*tmp_b);
end;
conv_result_abs=abs(conv_result);



plot(conv_result_abs);

##
##%Frequency shift
##t=(1/Fchip:1/Fchip:length(data_spread)/Fchip);
##carrier_shifted=cos(2*pi*Foffset.*t);
##data_spread=data_spread.*carrier_shifted;
##
##%Find frequency offset
##k_shift=0;
##shift_border=10e3;
##shift_step=1e3;
##find_freq_offset_result=zeros(shift_border*2/shift_step,length(data_spread)-1023);
##CA_code_sign_FFT_pattern=fftshift((fft(CA_code_sign)));
##
##for shift=-shift_border:shift_step:shift_border
##  
##  data_spread_unshift=data_spread.*cos(-2*pi*shift.*t);
##  k_shift=k_shift+1;
##
##  fprintf('Processing %f shift\n',shift);
##  
##  for k=1:length(data_spread_unshift)-1023
##    tmp=data_spread_unshift(k:k+1023-1);
##    tmp_fft=fftshift((fft(tmp)));
##    tmp_cor=abs(sum(CA_code_sign_FFT_pattern.*conj(tmp_fft)));
##    find_freq_offset_result(k_shift,k)=tmp_cor;
##  end
##  
##end
##
##%Prepare 3 plots
##tx =  linspace (-shift_border, shift_border, shift_border*2/shift_step+1)';
##ty =  (1:length(data_spread)-1023)';
##tz = find_freq_offset_result';
##[xx, yy] = meshgrid (tx, ty);
##mesh (tx, ty, tz);
##xlabel ("frequency");
##ylabel ("sample");
##zlabel ("correlation");
##title ("3-D Sombrero plot");
##
