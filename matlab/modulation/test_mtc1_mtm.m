clc;
clear all;
close all;

%Parameters
nb_size_data=2^8;
bps=4000;
sps=0.8e6;
subf=8e3;
deviation=400e3;

%Generate the data stream to be modualted in BPSK
bpsk_ovr=sps/bps;
##data=(round(rand(1,nb_size_data))-0.5)*2;
data=ones(1,nb_size_data);

%Zero hold upsampling of BPSK
data_ovr=zeros(1,length(data)*bpsk_ovr);
for m=1:bpsk_ovr
  data_ovr(m:bpsk_ovr:end)=data;
end

%Generate the subcarrier
t=(1/sps:1/sps:length(data_ovr)/sps);
subc=cos(2*pi*subf*t);

%Modulate the subcarrier
subc_modulated=subc.*data_ovr;

%FM modulation
%prepare the bpsk signal modualted on a subcarrier
phase_deviation=2*pi/sps*deviation;
phase_deviation=phase_deviation*subc_modulated;
phase_deviation_accum=cumsum(phase_deviation);


%prepare the ranging tone

%Mod in fm
mod_fm=sin(phase_deviation_accum);

%Plot the fft of this
fft_data_in = 20 * log10(fftshift(abs(fft(mod_fm)))); fft_data_in=fft_data_in-max(fft_data_in);

%Figure 1
figure(1);
x_axis =(-sps/2:sps/length(fft_data_in):sps/2-1/length(fft_data_in)).';
plot(x_axis,fft_data_in);
grid on;
xlabel('Normalized frequency')
ylabel('dB')
legend('Data in spectrum')
