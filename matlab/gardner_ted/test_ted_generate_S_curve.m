clc;
clear all;
close all;

%External paths
addpath ("../filter");
addpath ("../polyphase");
addpath ("../resample");
addpath ("../modulation");
addpath ("../misc");

%Load pkg
pkg load communications

%Parameters
nb_bits = 2^10; %vector length
modu='BPSK';
nb_symb=modu_bps(modu);
n_bits = 16; %quantization tap bits
roll_off = 0.5;
Fsymb=1;
Fsamp=32;
Terror=4;

%Init
Terror_table=[];
Spoint_table=[]

for mm=0:32
  
Terror=mm

%Generate input signal
data_in_sequence = (round(rand(1,nb_bits)));

%Modulate
data_modulated=mapper(data_in_sequence,modu);

#%Calculate RRC taps
h = rrc_function(Fsymb, Fsamp, roll_off);
[h_quant,h_quant_gain] = filter_tap_quant(h, n_bits);
h_quant = h_quant/h_quant_gain*Fsamp/Fsymb;

%Upsample and RRC filter TX
data_tx_filtered_signal = interpolate_with_zeros(data_modulated, Fsamp/Fsymb);
data_tx_filtered_signal = conv(data_tx_filtered_signal,h_quant);

%Upsample and RRC filter RX
data_rx_filtered_signal = conv(data_tx_filtered_signal,h_quant);
data_rx_filtered_signal = data_rx_filtered_signal(Fsamp/Fsymb+1+Terror:end); %Resync 
data_rx_filtered_signal = data_rx_filtered_signal/(Fsamp/Fsymb);

%Downsample
data_rx_filtered_down_signal=data_rx_filtered_signal(1:Fsamp/Fsymb/2:end);

%gardener ted
ted_data_in = data_rx_filtered_down_signal;
ted_data_out = zeros(1,length(ted_data_in));
ted_data_out_p = zeros(1,length(ted_data_in));
ted_data_out_n = zeros(1,length(ted_data_in));
ted_index=0;
ted_data_in_real = real(ted_data_in);
ted_data_in_imag = imag(ted_data_in);
for k=5:2:length(ted_data_in_real)
  if (ted_data_in_real(k)>0 && ted_data_in_real(k-2)<0)
    ted_data_out(k)=ted_data_in_real(k-1)*(ted_data_in_real(k)-ted_data_in_real(k-2));
    ted_data_out_p(k)=1;
  end
  if (ted_data_in_real(k)<0 && ted_data_in_real(k-2)>0)
    ted_data_out(k)=ted_data_in_real(k-1)*(ted_data_in_real(k)-ted_data_in_real(k-2));
    ted_data_out_n(k)=1;
  end
end

S_point = sum(ted_data_out) / (sum(ted_data_out_p)+sum(ted_data_out_n));

Terror_table=[Terror_table Terror];
Spoint_table=[Spoint_table S_point];

end

##x_axis = [ (-16:-1) (0:16)]; %(Fsamp/Fsymb/2) * -1; -1     0 Fsamp/Fsymb/2;    
##Spoint_table = [ Spoint_table(18:33) Spoint_table(1:17)]; %Fsamp/Fsymb/2+2 Fsamp/Fsymb+1 1 Fsamp/Fsymb/2+1
x_axis = [ ((Fsamp/Fsymb/2) * -1:-1) (0:Fsamp/Fsymb/2)];
Spoint_table = [ Spoint_table(Fsamp/Fsymb/2+2:Fsamp/Fsymb+1) Spoint_table(1:Fsamp/Fsymb/2+1)];

figure(1);
plot(x_axis,Spoint_table);

save('S_curve.mat', 'x_axis', 'Spoint_table');

##figure(1)
##plot(ted_data_out,'o');
##hold on;
##plot(ted_data_out_p*0.25);
##hold on;
##plot(ted_data_out_n*0.25);
##plot(ted_data_in_real);




##figure(1);
##EYE_DIAG_data_rx_filtered_signal = eye_diag(data_rx_filtered_signal,Fsamp/Fsymb*2);
##x_axis = linspace(-Fsamp/Fsymb,Fsamp/Fsymb,Fsamp/Fsymb*2);
##plot(x_axis,real(EYE_DIAG_data_rx_filtered_signal(:,end-(1024+1024):end-1024)));

##eyediagram (data_rx_filtered_signal, (Fsamp/Fsymb)*2);
##eyediagram (data_rx_filtered_down_signal, 4);



