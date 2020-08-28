clc;
clear all;
close all;

%Init and param
##rand("state",0);
modu='BPSK';
modu_fact=1/modu_bps(modu);
size_factor=1; %default is one
nb_size=2^8*8*modu_bps(modu)*size_factor;
nb_bit=log2(nb_size);
test_mode = 0;
filter_mode=1; %0: zero hold; 1:zero padding
interp_factor=4;
display=1;
add_noise=0;
snr_db=4-2-2;

if test_mode==0
  data_in=round(rand(1,nb_size));
end

if test_mode==1
  %Build the constellation of all possible inputs
  data_in=[];
  data=(0:nb_size-1);
  for k=1:nb_size
    tmp = data(k);
    tmp = decimal_to_unsigned_bit_table(tmp,nb_bit);
    data_in=[data_in tmp];
  end
end

if test_mode==2
  data_in=[1 0 0 1];
end;

%Modulate
data_modulated=mapper(data_in,modu);

%Emision filter - from symbol rate to x4 symbol rate
taps=csvread('taps.txt');
nb_taps=length(taps);
[data_modulated_filtered,data_modulated_ovr] = up_and_filter(data_modulated,interp_factor,filter_mode,taps);
data_modulated_filtered_transmit = data_modulated_filtered;

%Here add noise
if add_noise==1
  snr=10^(snr_db/20);
  data_modulated_filtered=add_awgn(data_modulated_filtered,snr,0,0);
end

%receive filter
data_modulated_filtered = filter(taps,1,data_modulated_filtered);
data_modulated_filtered_receive = data_modulated_filtered;

%Compensation filter
data_modulated_filtered_receive=data_modulated_filtered_receive*interp_factor;

%Sync transmit and receive samples
start_sync_em=6;
start_sync_rec=start_sync_em*interp_factor+nb_taps-interp_factor;
transmit_sync=data_modulated(start_sync_em:end);
receive_sync=data_modulated_filtered_receive(start_sync_rec:interp_factor:end);

%Demapp
data_demap=demapper(receive_sync,modu);

%Sync transmit and received bits
##bits_in_sync = data_in(6:end); %BPSK
##bits_in_sync = data_in(11:end); %QPSK
##bits_in_sync = data_in(21:end); %16QAM
##bits_in_sync = data_in(31:end); %64QAM
bits_in_sync = data_in(modu_bps(modu)*5+1:end);
bits_out_sync = data_demap;

%Calc errors
bits_errors=bits_out_sync-bits_in_sync(1:length(bits_out_sync));
nb_errors=sum(abs(bits_errors))
BER=nb_errors/length(bits_errors)

if display==1

  figure(1);
  subplot(2,1,1)
  plot(real(data_modulated));
  subplot(2,1,2)
  plot(imag(data_modulated));

  figure(2);
  subplot(2,1,1)
  plot(real(data_modulated_ovr));
  subplot(2,1,2)
  plot(imag(data_modulated_ovr));

  figure(3);
  subplot(2,1,1)
  plot(real(data_modulated_filtered_receive));
  subplot(2,1,2)
  plot(imag(data_modulated_filtered_receive));

  figure(4);
  x_axis=linspace(-interp_factor/2,interp_factor/2,nb_size*interp_factor*modu_fact);
  subplot(2,1,1)
  plot(x_axis,20*log10(abs(fftshift(fft(data_modulated_ovr)))));
  subplot(2,1,2)
  plot(x_axis,20*log10(abs(fftshift(fft(data_modulated_filtered)))));

  %eye diagram display
  figure(5)
  data_modulated_filtered = data_modulated_filtered(length(data_modulated_filtered_receive)/2:end);
  subplot(2,1,1)
  for k=1:interp_factor*2:length(data_modulated_filtered)-interp_factor*2+1
    plot(real(data_modulated_filtered(k:k+interp_factor*2-1)));
    hold on;
  end
  subplot(2,1,2)
  for k=1:interp_factor*2:length(data_modulated_filtered)-interp_factor*2+1
    plot(imag(data_modulated_filtered(k:k+interp_factor*2-1)));
    hold on;
  end
  
  %Bits
  figure(6)
  subplot(2,1,1)
  plot(data_in);
  subplot(2,1,2)
  plot(data_demap);
  
end
