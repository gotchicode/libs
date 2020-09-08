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
interp_factor=256;
display=0;
add_noise=0;
snr_db=100;


##%---------------------------------------------------------------------
##%BEGIN LOOP
##%---------------------------------------------------------------------
##%Vary parameter timing_offset in line 70
##for vary=0:256



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

%Receive filter
data_modulated_filtered = filter(taps,1,data_modulated_filtered);
data_modulated_filtered_receive = data_modulated_filtered;

%Compensation filter
data_modulated_filtered_receive=data_modulated_filtered_receive*interp_factor;

%Eye diagram
timing_offset=0;
data_modulated_filtered_receive_prepare=data_modulated_filtered_receive(4096:end); %Remove transient
offset=131+timing_offset; %Sampling point is in 128 for DEFAULT 131 value
data_modulated_filtered_receive_prepare=data_modulated_filtered_receive_prepare(offset:end);
m=floor(length(data_modulated_filtered_receive_prepare)/interp_factor);
data_modulated_filtered_receive_prepare=data_modulated_filtered_receive_prepare(1:m*interp_factor);
data_modulated_filtered_receive_reshaped = reshape(data_modulated_filtered_receive_prepare,interp_factor,m);

if display==1
  figure(1);
  plot(data_modulated_filtered_receive_reshaped(:,1:32));
end;

%Downsample by to two per symbol
data_modulated_filtered_receive_ovr_2=data_modulated_filtered_receive_prepare(128:interp_factor/2:end);

%----------------------------------------
%Apply Gardner TED
%----------------------------------------
ted_values=zeros(1,length(data_modulated_filtered_receive_ovr_2));
ted_values_en=zeros(1,length(data_modulated_filtered_receive_ovr_2));
ted_values_cnt = mod((1:length(ted_values))+1,2);
for k=3:length(data_modulated_filtered_receive_ovr_2)
  
  symb_t3=data_modulated_filtered_receive_ovr_2(k);
  symb_t2=data_modulated_filtered_receive_ovr_2(k-1);
  symb_t1=data_modulated_filtered_receive_ovr_2(k-2);
  
  %Case A symb_t3>symb_t2>symb_t1
  if ((symb_t3)>0 && (symb_t3)>(symb_t2) && 0>(symb_t1) && symb_t2>(symb_t1))
    if ted_values_cnt(k-1)==1
      ted_values_en(k-1)=1;
      ted_values(k-1)=(symb_t3-symb_t1)*symb_t2;
    end
  end
  %Case B symb_t3<symb_t2<symb_t1
  if ((symb_t3)<0 && (symb_t3)<(symb_t2) && (symb_t2)<(symb_t1) && 0<(symb_t1))
    if ted_values_cnt(k-1)==1
      ted_values_en(k-1)=-1;
      ted_values(k-1)=(symb_t3-symb_t1)*symb_t2;
    end
  end
  
end

%----------------------------------------
%Mean of TED output
%----------------------------------------
mean_ted=mean(ted_values(abs(ted_values_en)>0));
fprintf("timing offset=%d\t\t\t ted=%f\n",timing_offset,mean_ted);


##end
##%---------------------------------------------------------------------
##%END LOOP
##%---------------------------------------------------------------------



figure(1)
plot(ted_values_en);
hold on;
plot(ted_values,'+');
hold on;
plot(data_modulated_filtered_receive_ovr_2*2,'o');
hold on;
plot(ted_values_cnt/4,'x');



