clc;
clear all;
close all;

##rand("state",0);

addpath ("../modulation");

%Inits
index_k=0;
NCO_accu=0;
NCO_clk=0;
NCO_clk_d1=0;
bits_tmp=0;

%DEBUG_STORE
DEBUG_STORE_NCO_clk=zeros(1,2^10);
DEBUG_STORE_bits_tmp=zeros(1,2^10);
DEBUG_STORE_index_k=zeros(1,2^10);

%Parameter
Fsamp=100e6;
Fsymb=1e6;
modu='QPSK';

%Intermediate inits
nbps=modu_bps(modu);

while(index_k<2^16)

%--------------------------------------------------
%- Modulator
%--------------------------------------------------

%Detect a clock rising edge
if (NCO_clk==1 && NCO_clk_d1==0)
  
  %QPSK
  bits_tmp=round(rand(1,nbps))
  
  NCO_clk
  NCO_clk_d1

end

%NCO
NCO_clk_d1 = NCO_clk; 
NCO_clk = round(mod(NCO_accu,2^32)/2^32);
NCO_accu = NCO_accu + Fsymb*2^32/Fsamp;

%DEBUG_STORE
DEBUG_STORE_index_k(1:end-1)=DEBUG_STORE_index_k(2:end);DEBUG_STORE_index_k(end)=index_k; 
DEBUG_STORE_NCO_clk(1:end-1)=DEBUG_STORE_NCO_clk(2:end);DEBUG_STORE_NCO_clk(end)=NCO_clk; 
DEBUG_STORE_bits_tmp(1:end-2)=DEBUG_STORE_bits_tmp(3:end); DEBUG_STORE_bits_tmp(end-1:end)=bits_tmp;

%Index increment
index_k = index_k+1;

end

