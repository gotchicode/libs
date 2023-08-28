clc;
clear all;
close all;
pkg load communications;

%Other directories
addpath ("../resample");
addpath ("../filter");
addpath ("../misc");
addpath ("../gardner_ted");

%Parameters
Fin = 320e6;
Fresamp=160e6;
Fsymb=40e6;
interp_type=3;
roll_off = 0.5;
n_bits = 16; %quantization tap bits
debug = 0;
init_sample_offset=2^32/1024*(256);

%Load values form a textfile
data_in_I = csvread("../modulation/mod_I.txt")';
data_in_Q = csvread("../modulation/mod_Q.txt")';
data_in = data_in_I+j*data_in_Q;

%Init RRC filter
h_rrc = rrc_function(1, Fresamp/Fsymb, roll_off);
[h_quant,h_quant_gain] = filter_tap_quant(h_rrc, n_bits);

%Init variables
nco_accu_tmp_fsymb=init_sample_offset;
nco_accu_tmp_fsymb_r1=init_sample_offset;
nco_accu_tmp_fsymb_xovr=0;
nco_accu_tmp_fsymb_xovr_r1=0;
nco_accu_tmp_fsymb_x2=0;
nco_accu_tmp_fsymb_x2_r1=0;
Fsymb_pulse=0;
Fsymb_ovr_pulse=0;
Fsymb_ovr_pulse=0;
Fsymb_x2_pulse=0;
index_resample=0;
nco_accu_tmp_fsymb_xovr_buffer=zeros(1,4);
data_resample=zeros(1,length(data_in_I));
filter_kernel=zeros(1,length(h_quant));
index_symbols=0;
data_symbols=zeros(1,length(h_quant));
ted_samples =zeros(1,3);
ted_out=zeros(1,length(data_in_I));
ted_out_en=zeros(1,length(data_in_I));

%Debug init
ADEBUG_TABLE_Fsymb_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_Fsymb_ovr_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_Fsymb_x2_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_resample_I=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_rrc_filtered_I=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_symbols_I=zeros(1,length(data_in_I));
ADEBUG_TABLE_nco_accu_tmp_fsymb=zeros(1,length(data_in_I));
ADEBUG_TABLE_nco_accu_tmp_fsymb_xovr=zeros(1,length(data_in_I));


for k=1:length(data_in_I)
  
    %%-----------------------------------
    %%-- Pulses generation
    %%-----------------------------------
  
    %Running NCO at Fsymb
    nco_accu_tmp_fsymb_r1 = nco_accu_tmp_fsymb;
    nco_accu_tmp_fsymb = mod(nco_accu_tmp_fsymb+Fsymb/Fin*2^32,2^32);
    
    %Running NCO at Fsymb x ovr
    nco_accu_tmp_fsymb_xovr_r1 = nco_accu_tmp_fsymb_xovr;
    nco_accu_tmp_fsymb_xovr =  mod(nco_accu_tmp_fsymb * (Fresamp/Fsymb),2^32);
    
    %Running NCO at Fsymb x2
    nco_accu_tmp_fsymb_x2_r1 = nco_accu_tmp_fsymb_x2;
    nco_accu_tmp_fsymb_x2 = mod(nco_accu_tmp_fsymb * (Fresamp/Fsymb)/2,2^32);
    
    %Generate the pulse of the Fsymb
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb<nco_accu_tmp_fsymb_r1;
          Fsymb_pulse=1;
      else
          Fsymb_pulse=0;
      end;
    end;
    
    %Generate the pulse of the Fsymb x ovr
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb_xovr<nco_accu_tmp_fsymb_xovr_r1;
          Fsymb_ovr_pulse=1;
      else
          Fsymb_ovr_pulse=0;
      end;
    end;
    
    %Generate the pulse of the Fsymb x 2
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb_x2<nco_accu_tmp_fsymb_x2_r1;
          Fsymb_x2_pulse=1;
      else
          Fsymb_x2_pulse=0;
      end;
    end;
    
    %%-----------------------------------
    %%-- Fractional resampling
    %%-----------------------------------
    
    %Storing samples for decimation
    if (k>1 && k<length(data_in)-1) 
      %if Fsymb_ovr_pulse==1
        decimation_samples(1:4)=data_in(k-1:k+2);
      %end;
    end;
    
    %Resample by 2
    if (k>1 && k<length(data_in)-1) 
      if Fsymb_ovr_pulse==1
        index_resample = index_resample+1;
        data_resample(index_resample) = mu_direct_interp(decimation_samples, 1-(nco_accu_tmp_fsymb_xovr/2^32*2), interp_type,debug);
      end;
    end;
    
    %%-----------------------------------
    %%-- RRC Filtering
    %%-----------------------------------
    
    %RRC filtering
    if Fsymb_ovr_pulse==1
      filter_kernel(2:end)=filter_kernel(1:end-1);
      filter_kernel(1)=data_resample(index_resample);
      tmp = sum(filter_kernel.*h_quant);
      data_rrc_filtered(index_resample) = tmp / h_quant_gain;
    end;
    
    %%-----------------------------------
    %%-- Decimation by 2 to Fsymb
    %%-----------------------------------
    if Fsymb_pulse==1 
      index_symbols = index_symbols+1;
      data_symbols(index_symbols) = data_rrc_filtered(index_resample);
    end
    
    %%-----------------------------------
    %%-- Timing Error Detector
    %%-----------------------------------
    %Shift data for TED
    if (Fsymb_x2_pulse==1 && index_resample>1)
      ted_samples(2:3) = ted_samples(1:2);
      ted_samples(1) = data_rrc_filtered(index_resample);
    end

    %Gardner TED
    if (Fsymb_pulse==1 && index_resample>1)
      [tmp1 tmp2 ] = gardner_ted(ted_samples(3), ted_samples(2), ted_samples(1));
      ted_out(index_resample) = tmp1; 
      ted_out_en(index_resample) = tmp2;
    end
    
    
    
    %%-----------------------------------
    %%-- DEBUG
    %%-----------------------------------
    ADEBUG_TABLE_Fsymb_pulse(k) = Fsymb_pulse;
    ADEBUG_TABLE_Fsymb_ovr_pulse(k) = Fsymb_ovr_pulse;
    ADEBUG_TABLE_Fsymb_x2_pulse(k) = Fsymb_x2_pulse;
    ADEBUG_TABLE_nco_accu_tmp_fsymb(k) = nco_accu_tmp_fsymb;
    ADEBUG_TABLE_nco_accu_tmp_fsymb_xovr(k) = nco_accu_tmp_fsymb_xovr; 
    if (k>1 && Fsymb_ovr_pulse==1) ADEBUG_TABLE_data_resample_I(k) = real(data_resample(index_resample)); end
    if (k>1 && Fsymb_ovr_pulse==1) ADEBUG_TABLE_data_rrc_filtered_I(k) = real(data_rrc_filtered(index_resample)); end
    if (k>1 && Fsymb_pulse==1) ADEBUG_TABLE_data_symbols_I(k) = real(data_symbols(index_symbols)); end
    
end

%%-----------------------------------
%%-- Select interesting data
%%-----------------------------------
data_resample = data_resample(1:index_resample);
data_rrc_filtered = data_rrc_filtered(1:index_resample);
ted_out = ted_out(1:index_resample);
ted_out_en = ted_out_en(1:index_resample);

%%-----------------------------------
%%-- DISPLAY
%%-----------------------------------
##start_plot=2570;
##end_plot=2640;
##figure(1);
##plot(ADEBUG_TABLE_Fsymb_pulse(start_plot:end_plot));
##hold on;
##plot(ADEBUG_TABLE_Fsymb_ovr_pulse(start_plot:end_plot)*0.5);
##hold on;
##plot(ADEBUG_TABLE_Fsymb_x2_pulse(start_plot:end_plot)*0.25);
##hold on;
##plot(data_in_I(start_plot:end_plot));
##hold on;
##plot(ADEBUG_TABLE_data_resample_I(start_plot:end_plot),'+');
##hold on;
##plot(ADEBUG_TABLE_data_rrc_filtered_I(start_plot:end_plot),'x');
##hold on;
##plot(ADEBUG_TABLE_data_symbols_I(start_plot:end_plot),'o');
##hold on;
##plot(ADEBUG_TABLE_nco_accu_tmp_fsymb(start_plot:end_plot)/2^32+2);
##hold on;
##plot(ADEBUG_TABLE_nco_accu_tmp_fsymb_xovr(start_plot:end_plot)/2^32+2);
##
##figure(2);
##plot(data_symbols,'o');

figure(3);
plot(ted_out,'o');


##eyediagram(data_symbols,Fresamp/Fsymb/2);


