clc;
clear all;
close all;

addpath ("../resample");

rand("state",0);

%Parameter
nb_size=32;
Fchip=1.023e6;
Foffset=0.0001*Fchip;
Soffset=0.0001*Fchip;
phase_select1=3;
phase_select2=6;
ovr=64;

%--------------------------------------------------------------------
% Modulator
%--------------------------------------------------------------------

%Generate a code
CA_code = CA_code_gen(phase_select1,phase_select2);
CA_code_sign=CA_code*2-1;

%Generate a random stream
data=round(rand(1,nb_size));

%Spread
data_spread = spread(data,CA_code);

%Shaping and upsampling
taps_x64=csvread('taps_64.txt');
data_spread_sampled=zeros(1,length(data_spread)*ovr);
data_spread_sampled(1:ovr:end)=data_spread;
data_spread_sampled=filter(taps_x64,1,data_spread_sampled);

%--------------------------------------------------------------------
% Channel
%--------------------------------------------------------------------
data_spread_channel=data_spread_sampled;

%Phase offset
data_spread_channel = data_spread_channel*exp(j*pi/180*(0));

%Carrier offset
t=(1/ovr:1/ovr:length(data_spread_channel)/ovr);
offset=1/1023/40; %In Hz per chip - a chip lasts ovr samples, a symbol lasts ovr*spread_fact
carrier=cos(2*pi*offset*t)+j*sin(2*pi*offset*t);
data_spread_channel = data_spread_channel.*carrier;


%Sample offset offset
sample_offset=1;
if sample_offset==1
  data_spread_channel=data_spread_channel(1:end);
else
  data_spread_channel=[data_spread_channel(sample_offset:end) zeros(1,sample_offset-1)];
end;

%AWGN

%--------------------------------------------------------------------
% Demodulate
%--------------------------------------------------------------------
data_spread_rx_in=data_spread_channel;

%Shaping filtering
data_spread_rx_in=filter(taps_x64,1,data_spread_rx_in);

%Decimation to symbol rate x2
data_spread_rx_in_decimated=data_spread_rx_in(1:32:end);

%Adjust the gain ( x 64.1)
data_spread_rx_in_decimated = data_spread_rx_in_decimated*64.1;

%Correlation between the CA_code_sign and received sequence
%Real
correl_result_real=zeros(1,length(data_spread_rx_in_decimated));
correl_result_imag=zeros(1,length(data_spread_rx_in_decimated));
for k=1:length(data_spread_rx_in_decimated)-length(CA_code_sign)*2-1
  tmp_seq = data_spread_rx_in_decimated(k:2:k+length(CA_code_sign)*2-1);
  correl_result_real(k) = abs(sum(real(tmp_seq).*CA_code_sign));
  correl_result_imag(k) = abs(sum(imag(tmp_seq).*CA_code_sign));
end;
correl_result_abs = correl_result_real.^2+correl_result_imag.^2;


##
##
##%--------------------------------------------------------------------
##% Eye diagram of received samples after RRC
##%--------------------------------------------------------------------
##data_eye_in =  reshape(data_spread_rx_in,128,[]);
##data_eye_in_size=size(data_eye_in);
##figure(1);
##for k=100:100+50
##  plot(data_eye_in(:,k));
##  hold on;
##end;
##
##
##%--------------------------------------------------------------------
##% Eye diagram of decimated samples
##%--------------------------------------------------------------------
##data_eye_in =  reshape(data_spread_rx_in_decimated,4,[]);
##data_eye_in_size=size(data_eye_in);
##figure(2);
##for k=100:100+50
##  plot(data_eye_in(:,k));
##  hold on;
##end;

figure(3)
subplot(3,1,1);
plot(correl_result_real);
subplot(3,1,2);
plot(correl_result_imag);
subplot(3,1,3);
plot(correl_result_abs);

