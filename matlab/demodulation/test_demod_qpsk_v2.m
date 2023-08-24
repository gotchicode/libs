clc;
clear all;
close all;

%Other directories
addpath ("../resample");
addpath ("../filter");
addpath ("../misc");
%Parameters
Fin = 320e6;
Fresamp=160e6;
Fsymb=40e6;
interp_type=3;
roll_off = 0.5;
n_bits = 16; %quantization tap bits
debug = 0;

%Load values form a textfile
data_in_I = csvread("../modulation/mod_I.txt")';
data_in_Q = csvread("../modulation/mod_Q.txt")';
data_in = data_in_I+j*data_in_Q;

%Init
nco_accu_tmp_fsymb=0;
nco_accu_tmp_fsymb_r1=0;
nco_accu_tmp_fsymb_xovr=0;
nco_accu_tmp_fsymb_xovr_r1=0;
Fsymb_pulse=0;
Fsymb_ovr_pulse=0;

%Debug init
ADEBUG_TABLE_Fsymb_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_Fsymb_ovr_pulse=zeros(1,length(data_in_I));

for k=1:length(data_in_I)
  
    %Running NCO at Fsymb
    nco_accu_tmp_fsymb_r1 = nco_accu_tmp_fsymb;
    nco_accu_tmp_fsymb = mod(nco_accu_tmp_fsymb+Fsymb/Fin*2^32,2^32);
    
    %Running NCO at Fsymb x ovr
    nco_accu_tmp_fsymb_xovr_r1 = nco_accu_tmp_fsymb_xovr;
    nco_accu_tmp_fsymb_xovr =  mod(nco_accu_tmp_fsymb * (Fresamp/Fsymb),2^32);
    
    %Generate the pulse of the Fsymb
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb<nco_accu_tmp_fsymb_r1;
          Fsymb_pulse=1;
      else
          Fsymb_pulse=0;
      end
    end
    
    %Generate the pulse of the Fsymb x ovr
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb_xovr<nco_accu_tmp_fsymb_xovr_r1;
          Fsymb_ovr_pulse=1;
      else
          Fsymb_ovr_pulse=0;
      end
    end
    
    %Generate the pulse of the Fsymb x ovr
    
    
    %%-----------------------------------
    %%-- DEBUG
    %%-----------------------------------
    ADEBUG_TABLE_Fsymb_pulse(k) = Fsymb_pulse;
    ADEBUG_TABLE_Fsymb_ovr_pulse(k) = Fsymb_ovr_pulse;
    
    
end

%%-----------------------------------
%%-- DISPLAY
%%-----------------------------------
figure(1);
plot(ADEBUG_TABLE_Fsymb_pulse);
hold on;
plot(ADEBUG_TABLE_Fsymb_ovr_pulse*0.5);