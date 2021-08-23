function data_out=add_awgn(data_in,snr,use_seed,display)

%Size
nb_size=length(data_in);
  
%Data in sequence
data_in_sequence=data_in;

%Power of the input signal
data_in_power=sum(abs(data_in_sequence).^2)/nb_size;

%noise
noise=data_in_power/snr;

%Scale noise
if(isreal(data_in)),
  noise_scaled = sqrt(noise)*randn(size(data_in_sequence));
else
  noise_scaled = sqrt(noise)/2*(randn(size(data_in_sequence))+1i*randn(size(data_in_sequence)));
end

if display==1
  fprintf('data_in_power=%f\n',data_in_power);
  fprintf('noise_scaled_power=%f\n',sum(abs(noise_scaled).^2)/nb_size);
end
 
%Add noise
data_out = data_in_sequence + noise_scaled; %received signal