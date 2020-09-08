clc;
clear all;
close all;

%For loop
snr_save=[];
snr_measures=[];

for snr_dB=0:100

  %Parameters
  sig_size=2^20;
  ##snr_dB=40;
  snr=10^(snr_dB/20);

  %Generate test signal
  test_in = ones(1,sig_size);
##  t=(1:sig_size);
##  test_in=sin(2*pi*0.1*t);

  %Generate noise
  noise = rand(1,sig_size)*2;

  %Add noise to signal
  test_in_with_noise=test_in+noise/snr;

  %Measure
  mean_of=mean(abs(test_in_with_noise));
  std_of=std(abs(test_in_with_noise));
  snr_measured=mean_of.^2/std_of.^2;
  snr_measured_dB=10*log10(snr_measured);

  %Store information
  snr_save=[snr_save snr_dB];
  snr_measures=[snr_measures snr_measured_dB];
  
end;

figure(1);
plot(snr_save,snr_measures);
figure(2);
plot(diff(snr_measures));
