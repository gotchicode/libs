clc;
clear all;
close all;

%Other directories
addpath ("../resample");
addpath ("../filter");

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

%Init RRCC filter taps

%Init
nco_accu_tmp=0;
index_resample=0;
index_rrc_filter=0;
data_resample=zeros(1,length(data_in));
data_rrc_filtered=zeros(1,length(data_in));
data_rrc_filtered_rate_x2=zeros(1,length(data_in));
h_rrc = rrc_function(1, Fresamp/Fsymb, roll_off);
[h_quant,h_quant_gain] = filter_tap_quant(h_rrc, n_bits);
filter_kernel=zeros(1,length(h_quant));
downsample_factor = Fresamp/Fsymb;
downsample_cnt = 0;
fsymb_x2_flag=0;

for k=1:length(data_in_I)
  
    %Running NCO
    nco_accu_tmp_r1 = nco_accu_tmp;
    nco_accu_tmp = mod(nco_accu_tmp+Fresamp/Fin*2^32,2^32);
    if nco_accu_tmp<nco_accu_tmp_r1;
        Fin_detect_flag=1;
    else
        Fin_detect_flag=0;
    end
    
    %Storing samples for decimation
    if (k>1 && k<length(data_in)-1) 
      if Fin_detect_flag==1
        decimation_samples(1:4)=data_in(k-1:k+2);
      end;
    end;
    
    %Resample by 2
    if (k>1 && k<length(data_in)-1) 
      if Fin_detect_flag==1
        index_resample = index_resample+1;
        data_resample(index_resample) = mu_direct_interp(decimation_samples, nco_accu_tmp/2^32, interp_type,debug);
        end;
    end;
    
    %RRC filtering
    if Fin_detect_flag==1
      filter_kernel(2:end)=filter_kernel(1:end-1);
      filter_kernel(1)=data_resample(index_resample);
      tmp = sum(filter_kernel.*h_quant);
      data_rrc_filtered(index_resample) = tmp;
    end;
    
    %Downsample to symb rate x2
    if Fin_detect_flag==1
      downsample_cnt = mod(downsample_cnt + 1, downsample_factor);
      if (downsample_cnt==0 || downsample_cnt==downsample_factor-1)
        index_rrc_filter=index_rrc_filter+1;
        data_rrc_filtered_rate_x2(index_rrc_filter) = data_rrc_filtered(index_resample);
        fsymb_x2_flag =1;
      else
        fsymb_x2_flag =0;
      end
    else
      fsymb_x2_flag =0;
    end
    
end

%Select only correct samples up to index_sample
data_resample = data_resample(1:index_resample);
data_rrc_filtered = data_rrc_filtered(1:index_resample);
data_rrc_filtered_rate_x2 = data_rrc_filtered_rate_x2(1:index_rrc_filter);

data_resample_I=real(data_resample);
data_resample_Q=imag(data_resample);

##%Resampling /2
##data_resampled_I= mu_decim_process(data_in_I,Fin,Fout,debug,interp_type);
##data_resampled_Q= mu_decim_process(data_in_Q,Fin,Fout,debug,interp_type);
##
##%Frequency shift
##
##%RRC filtering
###%Calculate RRC taps
##h = rrc_function(Fsymb, Fsamp, roll_off);
##[h_quant,h_quant_gain] = filter_tap_quant(h, n_bits);
##
##%Filter
##data_filtered_I = conv(data_resampled_I,h_quant);
##data_filtered_Q = conv(data_resampled_Q,h_quant);
##
##data_filtered=data_filtered_I+j*data_filtered_Q;
##
####eyediagram (data_in_I+j*data_in_Q, 8);

eyediagram (data_rrc_filtered_rate_x2, 4);
