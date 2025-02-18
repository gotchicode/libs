clc;
clear all;
close all;
pkg load communications;

%External paths
addpath ("../filter");
addpath ("../polyphase");
addpath ("../resample");

%Parameters
nb_bits = 2^14; %vector length
modu='QPSK';
nb_symb=modu_bps(modu);
n_bits = 16; %quantization tap bits
roll_off = 0.5;
T_PPM=0;
Delta_f=0.0; % percentage of symb rate
Fsymb=1;
Fsamp=8;
Fin = 1;
Fout = 2*(1e6+T_PPM)/1e6;
debug = 0;
interp_type=3;
phase_offset= 1 * pi/8;
carrier_offset=Delta_f/(Fsamp/Fsymb) / 100; % percentage of symb rate

%Generate input signal
##data_in_sequence = (round(rand(1,nb_bits)));
data_in_sequence = repmat([1 0 1 1 0 1 0 0 ], 1,nb_bits/8);

%Modulate
data_modulated=mapper(data_in_sequence,modu);

%RRC filter and interpolate

#%Calculate RRC taps
h = rrc_function(Fsymb, Fsamp, roll_off);
[h_quant,h_quant_gain] = filter_tap_quant(h, n_bits);
h_quant = h_quant/h_quant_gain*Fsamp/Fsymb;


%Filter and upsample with a polyphase
##filtered_signal = polyphase_filter(data_modulated,h_quant,Fsamp,Fsymb);
filtered_signal = interpolate_with_zeros(data_modulated, Fsamp/Fsymb);
filtered_signal = conv(filtered_signal,h_quant);

%Generate a carrier offset
t=1:length(filtered_signal);
carrier_offset_signal = exp(j*mod(2*pi*carrier_offset*t,2*pi));

%Apply the carrier offset
filtered_signal = filtered_signal.*carrier_offset_signal;

%Fractional resampling
data_out = mu_interp_process(filtered_signal,Fin,Fout,debug,interp_type);

%Apply a phase offset
data_out = data_out .* exp(j*phase_offset);

%% Save to file
fid=fopen("mod_I.txt",'w');
for k=1:length(data_out)
  fprintf(fid,"%f\n",real(data_out(k)));
end
fclose(fid);
fid=fopen("mod_Q.txt",'w');
for k=1:length(data_out)
  fprintf(fid,"%f\n",imag(data_out(k)));
end
fclose(fid);

##%% Display
##%Plot I
##figure(1);
##plot(real(data_out));
##
##%Plot Q
##figure(2);
##plot(imag(data_out));

% Eye diagram
##eyediagram (filtered_signal, (Fsamp/Fsymb)*(Fout/Fin)*2);
