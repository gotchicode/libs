clc;
clear all;
close all;

%Initialize a rand seed
rand('state',1);

%Test parameters
nb_size=2^12;

%Modulation parameters
ovr=16; %oversampliing factor
fsk_deviation=0.35

%Data generation
data_in = round(rand(1,nb_size));

%Modulate in FSK
phase_in=0;
[mod_signal,mod_signal_phase_out,data_map]=mod_4fsk(data_in,phase_in,ovr,fsk_deviation);

%Prepare Display
x_axis=linspace(-ovr/2,ovr/2,nb_size/2*ovr);
fft_done=20*log10(abs(fftshift(fft(mod_signal))));
max_fft_done=max(fft_done);
fft_done=fft_done-max_fft_done;

%Display
figure(1);
plot(x_axis,fft_done);

%Display signal
figure(2);
subplot(411);
plot(data_in(1:32));
subplot(412);
plot(data_map(1:16));
subplot(413);
plot(real(mod_signal(1:ovr*16)));
subplot(414);
plot(imag(mod_signal(1:ovr*16)));

##Export to file
fp = fopen("data_mod_I.txt","w");
for k=1:length(mod_signal)
  fprintf(fp,"%f\n",real(mod_signal(k)));
##  fprintf("%f\n",imag(mod_signal(k)));
end
fclose(fp);

fp = fopen("data_mod_Q.txt","w");
for k=1:length(mod_signal)
##  fprintf("%f\n",real(mod_signal(k)));
  fprintf(fp,"%f\n",imag(mod_signal(k)));
end
fclose(fp);