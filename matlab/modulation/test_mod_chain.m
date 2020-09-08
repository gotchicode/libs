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

%Upsampling x64
taps=csvread('interp64_filter_taps.txt');
nb_taps=length(taps);
data_modulated_filtered_transmit_x256_up=up_and_filter(data_modulated_filtered_transmit,64,1,taps);

%Apply a gain
data_modulated_filtered_transmit_x256_up=data_modulated_filtered_transmit_x256_up*interp_factor;

%----------------------------
%Eye diagram
%----------------------------
if display==1
  eye_diagram_in=data_modulated_filtered_transmit_x256_up;
  factor=interp_factor*64*2;
  m=floor(length(eye_diagram_in)/factor);
  data_eye_diagram=eye_diagram_in(1:m*factor);
  data_eye_diagram = reshape(data_eye_diagram,factor,m);
  plot(real(data_eye_diagram(:,512:512+128)));
end;


%----------------------------
%Constellation
%----------------------------
##plot(data_modulated_filtered_transmit_x256_up);

