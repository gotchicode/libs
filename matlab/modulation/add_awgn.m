function data_out=add_awgn(data_in,snr,use_seed,display)

%Select how to measure power
type_square_abs=0;

%Size
nb_size=length(data_in);
  
%Data in sequence
data_in_sequence=data_in;
data_in_sequence_mean=mean(data_in_sequence);
if type_square_abs==0
  data_in_sequence_rms=mean(sqrt(real(data_in_sequence).^2+imag(data_in_sequence).^2));
else
  data_in_sequence_rms=mean(abs(data_in_sequence));
end
if display fprintf('data_in_sequence_mean=%f data_in_sequence_rms=%f\n',data_in_sequence_mean,data_in_sequence_rms); end;
  
%For a noise sequence
if use_seed==1
rand("state",0);
end
noise_sequence=rand(1,nb_size)-0.5;
noise_sequence_mean=mean(noise_sequence);
if type_square_abs==0
  noise_sequence_rms=mean(sqrt(real(noise_sequence.^2)+imag(noise_sequence.^2)));
else
  noise_sequence_rms=mean(abs(noise_sequence));
end
##if display fprintf('noise_sequence_mean=%f noise_sequence_rms=%f\n',noise_sequence_mean,noise_sequence_rms);
if display==1 fprintf('noise_sequence_mean=%f noise_sequence_rms=%f\n',noise_sequence_mean,noise_sequence_rms); end

%Measure actual SNR
actual_snr=data_in_sequence_rms/noise_sequence_rms;
snr_ratios=actual_snr/snr;

if display==1 fprintf('actual_snr=%f (linear)\n',actual_snr); end

%Gain tuning
if type_square_abs==0
  noise_sequence=noise_sequence*(snr_ratios);
else
  noise_sequence=noise_sequence*(snr_ratios);
end 
noise_sequence_mean=mean(noise_sequence);
if type_square_abs==0
  noise_sequence_rms=mean(sqrt(real(noise_sequence.^2)+imag(noise_sequence.^2)));
else
  noise_sequence_rms=mean(abs(noise_sequence));
end

%Updated snr
updated_snr=data_in_sequence_rms/noise_sequence_rms;
if display==1 fprintf('updated_snr=%f (linear)\n',updated_snr); end

%Out
data_out=data_in+noise_sequence;
  
end
