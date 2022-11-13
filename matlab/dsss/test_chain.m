clear all;
close all;
clc;

%Initialize a rand seed
rand('state',1);

%Parameters
nb_bits=32; %Number of bits to be spreaded
SF=127; %Spreding factor
Symbrate=2; %Interpolation factor

%Init

%Load gold code sequence from a file
##dsss_sequence=csvread("../gold_code/p1__3_4_6_9_p2__4_9_N511.txt");
dsss_sequence=csvread("../gold_code/p1__1_3_7__p2__1_7_N127.txt");
dsss_sequence = dsss_sequence * 2 - 1;

%Load filter taps from a file
srrc_taps=csvread("taps.txt");

%---------------------------------------------
%   Modulation
%---------------------------------------------

%Generate data stream
data_in = round(rand(nb_bits,1));

%Mapping (BPSK)
data_symbols = data_in*2-1;

%Spreading
dsss_data = zeros(nb_bits*SF,1);
for k=1:length(data_symbols)
  if data_symbols(k)==1
    dsss_data((k-1)*SF+1:(k-1)*SF+1+SF-1)=dsss_sequence;
  end
  if data_symbols(k)==-1
    dsss_data((k-1)*SF+1:(k-1)*SF+1+SF-1)=-dsss_sequence;
  end
end

%Upsampling
dsss_data_upsampled=zeros(length(dsss_data)*2,1);
dsss_data_upsampled(1:2:end)=dsss_data;

%Filtering
dsss_data_filtered=conv(dsss_data_upsampled,srrc_taps);

%Modulator out
dsss_mod_out = dsss_data_filtered;

%---------------------------------------------
%   Channel
%---------------------------------------------
channel_out = dsss_mod_out;

%---------------------------------------------
%   DSSS Demodulator
%---------------------------------------------

% Matched filter
demod_in_mf = conv(channel_out,srrc_taps)/2;

%Global correlates
%correlation_result = conv(demod_in_mf,dsss_sequence);

%Early correlator
correlation_1_early_result = conv(demod_in_mf(1:2:end),dsss_sequence);

%Prompt correlator
correlation_2_prompt_result = conv(demod_in_mf(2:2:end),dsss_sequence);

%Late correlator
correlation_3_late_result = conv(demod_in_mf(3:2:end),dsss_sequence);


##hold on;
##plot(correlation_1_early_result,'x');
##plot(correlation_2_prompt_result, 'o');
##plot(correlation_3_late_result(1:end-1),'x');
plot(correlation_2_prompt_result);