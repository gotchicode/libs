clc;
clear all;
close all;

%Parameters
nb_size=2^15;
snr_db=15;
snr=10^(snr_db/10);
modu='QPSK';
use_seed=0;
display=0;

%Init
total_errors=0;
total_bits=0;

while(1)

  %Generate input signal
  data_in_sequence = (round(rand(1,nb_size)));

  %Modulate
  data_modulated=mapper(data_in_sequence,modu);

  %Add AWGN
  data_with_noise=add_awgn(data_modulated,snr,use_seed,display);

  %Demodulate
  data_demodulated=demapper(data_with_noise,modu);

  %BER
  errors=abs(data_in_sequence-data_demodulated);
  
  total_errors=total_errors+sum(errors);
  total_bits=total_bits+nb_size;
  total_ber=total_errors/total_bits;
  fprintf('snr_db=%f \t total_errors=%d \t total_bits=%d\tber=%f\n',snr_db,total_errors,total_bits,total_ber);

end

%Plot
##plot(real(errors),'.');
##plot(real(data_with_noise),'.');