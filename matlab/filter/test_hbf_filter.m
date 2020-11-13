clc;
clear all;
close all;

%Parameter
nb_size = 2^15;
ratio=16; %Must be a power of 2
type=1; %0: notmal, 1:interp, -1:decimate

%Test vectort
data_in = randn(1,nb_size);

%Apply hbf filter
data_out = hbf_filter(data_in, ratio, type);

%If type==1 decim back
if type==1
  data_decim_out = hbf_filter(data_out, ratio, -1);
end

%Spectrum calc
fft_data_in = 20 * log10(fftshift(abs(fft(data_in)))); fft_data_in=fft_data_in-max(fft_data_in);
fft_data_out = 20 * log10(fftshift(abs(fft(data_out)))); fft_data_out=fft_data_out-max(fft_data_out);

%Figure 1
figure(1);
x_axis =(-0.5:1/length(fft_data_in):0.5-1/length(fft_data_in)).';
plot(x_axis,fft_data_in);
grid on;
xlabel('Normalized frequency')
ylabel('dB')
legend('Data in spectrum')

%Figure 2
figure(2);
x_axis =(-0.5*ratio:ratio/length(fft_data_out):0.5*ratio-0.5*ratio/length(fft_data_out)).';
plot(x_axis,fft_data_out);
grid on;
xlabel('Normalized frequency')
ylabel('dB')
legend('Data out spectrum')

if type==1
  fft_data_decim_out = 20 * log10(fftshift(abs(fft(data_decim_out)))); fft_data_decim_out=fft_data_decim_out-max(fft_data_decim_out);
  %Figure 3
  figure(3);
  x_axis =(-0.5*ratio:ratio/length(fft_data_decim_out):0.5*ratio-0.5*ratio/length(fft_data_decim_out)).';
  plot(x_axis,fft_data_decim_out);
  grid on;
  xlabel('Normalized frequency')
  ylabel('dB')
  legend('Data out spectrum decimated back')

end

