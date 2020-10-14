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
find_freq_offset_result=zeros(1,length(data_spread)-1023);
CA_code_sign_FFT_pattern=fftshift((fft(CA_code_sign)));
for k=1:length(data_spread)-1023
  tmp=data_spread(k:k+1023-1);
  tmp_fft=fftshift((fft(tmp)));
  tmp_cor=abs(sum(CA_code_sign_FFT_pattern.*conj(tmp_fft)));
  find_freq_offset_result(k)=tmp_cor;
end

%Correlation
result=abs(conv(data_spread,CA_code_sign));

%Display
plot(find_freq_offset_result);

##plot(20*log10(abs(fftshift(fft((cos(2*pi*Foffset.*t)))))));