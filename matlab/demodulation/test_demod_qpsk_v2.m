clc;
clear all;
close all;
pkg load communications;

%Other directories
addpath ("../resample");
addpath ("../filter");
addpath ("../misc");
addpath ("../gardner_ted");
addpath ("../control_loop");

%Parameters overall
Fin = 320e6;
Fresamp=160e6;
Fsymb=40e6;
interp_type=3;
roll_off = 0.5;
n_bits = 16; %quantization tap bits
debug = 0;
init_sample_offset=2^32/1024*(256);

%TED loop parameters
T_ted = 1;
Bn_ted = 0.005/4;
ksi_ted = sqrt(2)/2;
enable_ted_loop=0;
sign_ted_loop=-1;

%PED loop parameters
T_ped = 1;
Bn_ped = 0.005/4;
ksi_ped = sqrt(2)/2;
enable_ped_loop=1;
sign_ped_loop=-1;
ped_use_integ=0;

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
nco_accu_tmp_fsymb_50_delay=0;
nco_accu_tmp_fsymb_50_delay_r1=0;
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
ted_phase_out=zeros(1,length(data_in_I));
Fsymb_fe_pulse=0;
add_prev_in_ted = 0;
loop_integ_in_ted = 0;
TED_correction=0;
ted_store_increment=0;
ted_store_increment_flag=0;
data_symbols_en=0;
add_prev_in_ped=0;
loop_integ_in_ped=0;
add_prev_out_ped=0;
PED_correction=0;

%Debug init
ADEBUG_TABLE_Fsymb_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_Fsymb_ovr_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_Fsymb_x2_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_resample_I=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_rrc_filtered_I=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_symbols_I=zeros(1,length(data_in_I));
ADEBUG_TABLE_nco_accu_tmp_fsymb=zeros(1,length(data_in_I));
ADEBUG_TABLE_nco_accu_tmp_fsymb_xovr=zeros(1,length(data_in_I));
ADEBUG_TABLE_Fsymb_fe_pulse=zeros(1,length(data_in_I));
ADEBUG_TABLE_ted_phase_out=zeros(1,length(data_in_I));
ADEBUG_TABLE_loop_out_ted=zeros(1,length(data_in_I));
ted_store_increment_sum=0;
ADEBUG_TABLE_sum_corrections_ted=zeros(1,length(data_in_I));
ADEBUG_TABLE_loop_out_ted=zeros(1,length(data_in_I));
ADEBUG_TABLE_loop_out_ped=zeros(1,length(data_in_I));
ADEBUG_TABLE_data_symbols_angle=zeros(1,length(data_in_I));


for k=1:length(data_in_I)
  
    %%-----------------------------------
    %%-- Phase offset compensation
    %%-----------------------------------
    if enable_ped_loop==1
        data_in = data_in .* exp(j*PED_correction);
    end
##    dtmp = data_in(k) .* exp(j*PED_correction)
##    pause;
   
    %%-----------------------------------
    %%-- Pulses generation
    %%-----------------------------------

    %Running NCO at Fsymb
    nco_accu_tmp_fsymb_r1 = nco_accu_tmp_fsymb;
    nco_accu_tmp_fsymb = mod(nco_accu_tmp_fsymb+Fsymb/Fin*2^32+TED_correction*enable_ted_loop,2^32);
    
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
    
    %Generate a pulse at Fsymb falling edge
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb>2147483648 && nco_accu_tmp_fsymb_r1<2147483648+1; %2^31
          Fsymb_fe_pulse=1;
      else
          Fsymb_fe_pulse=0;
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
    if Fsymb_pulse==1 %on rising edge of Fsymb
##    if Fsymb_fe_pulse==1 %on falling edge of Fsymb
      index_symbols = index_symbols+1;
      data_symbols(index_symbols) = data_rrc_filtered(index_resample);
      data_symbols_en = 1;
    else
      data_symbols_en = 0;
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
    
    %%
    %% This part converts TED values to different levels one
    %%
    %Convert to samples
    % +1 is Symbol/4
    if (Fsymb_pulse==1 && index_resample>1)
      if ted_out(index_resample)>1
        ted_out(index_resample) = 1;
      endif
      if ted_out(index_resample)<-1
        ted_out(index_resample) = -1;
      endif
    end
    
    %Convert samples to phase increment
    if (Fsymb_pulse==1 && index_resample>1)
      ted_phase_out(index_resample) = ted_out(index_resample)/4 * 2^32;
    end
    
    %%-----------------------------------
    %%-- Timing error loop filter
    %%-----------------------------------
    if (Fsymb_pulse==1 && index_resample>1)
      if ted_out_en(index_resample)==1
        loop_in_ted = ted_phase_out(index_resample);
        [loop_out_ted, add_prev_out_ted, loop_integ_out_ted] = loop_filter_2nd_order(loop_in_ted, T_ted, Bn_ted, ksi_ted, add_prev_in_ted, loop_integ_in_ted,0);
        add_prev_in_ted = add_prev_out_ted;
        loop_integ_in_ted = loop_integ_out_ted;
      end
    end
    
    %%-----------------------------------
    %%-- Timing error sampling control
    %%-----------------------------------
    % Detect a new TED value
    if (index_resample>1  && ted_out_en(index_resample)==1)
      ted_store_increment = loop_out_ted;
      ted_store_increment_flag=1;
    end
    
    % This is debug
    if (k>1 &&  ted_store_increment_flag==1 && Fsymb_fe_pulse==1 ) 
      ted_store_increment_sum = ted_store_increment_sum + ted_store_increment * (sign_ted_loop);
      ADEBUG_TABLE_sum_corrections_ted(k) = ted_store_increment_sum;
    end
    
    % Apply value one time to the
    if (ted_store_increment_flag==1 && Fsymb_fe_pulse==1)
      ted_store_increment_flag=0;
      TED_correction= ted_store_increment * (sign_ted_loop);
    else
      TED_correction=0;
    end
    
    %%-----------------------------------
    %%-- Phase Error Detector
    %%-----------------------------------
    if (data_symbols_en==1 )
      data_symbols_angle(index_symbols) = mod(angle(data_symbols(index_symbols)),pi/2) - pi /4 ;
    end
    
    %%-----------------------------------
    %%-- Phase error loop filter
    %%-----------------------------------
    if (data_symbols_en==1 )
      loop_in_ped = data_symbols_angle(index_symbols);
      [loop_out_ped, add_prev_out_ped, loop_integ_out_ped] = loop_filter_2nd_order(loop_in_ped, T_ped, Bn_ped, ksi_ped, add_prev_in_ped, loop_integ_in_ped,ped_use_integ);
      add_prev_in_ped = add_prev_out_ped;
      loop_integ_in_ped = loop_integ_out_ped;
      PED_correction =  loop_out_ped * (sign_ped_loop);
    end
    
##    if (k>1000)
##      data_symbols_angle(index_symbols)
##      loop_out_ped
##      pause;
##    end

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
    ADEBUG_TABLE_Fsymb_fe_pulse(k) = Fsymb_fe_pulse;
    if (Fsymb_pulse==1 && index_resample>1) ADEBUG_TABLE_ted_phase_out(k) = ted_phase_out(index_resample); end
    if (Fsymb_pulse==1 && index_resample>1 && ted_out_en(index_resample)==1) ADEBUG_TABLE_loop_out_ted(k) = loop_out_ted; end
    if (data_symbols_en==1) ADEBUG_TABLE_loop_out_ped(k)=loop_out_ped; end
    if (data_symbols_en==1) ADEBUG_TABLE_data_symbols_angle(k)=data_symbols_angle(index_symbols); end

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
##start_plot=30000+256;
##end_plot=30000+256*2;
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
##plot(ADEBUG_TABLE_Fsymb_fe_pulse(start_plot:end_plot),'.-');



##figure(1);
##plot(data_symbols,'o');
##title ("data symbols");

##figure(2);
##plot(ted_out,'o');
##title ("ted out");

##
##figure(3);
##plot(ADEBUG_TABLE_ted_phase_out,'o');
##title ("ted phase_out");
##
##figure(4);
##plot(ADEBUG_TABLE_loop_out_ted,'o');
##title ("loop out ted");
##
##figure(5);
##plot(ADEBUG_TABLE_sum_corrections_ted,'o');
##title ("sum corrections ted");
##
##figure(6);
##plot(ADEBUG_TABLE_sum_corrections_ted/2^32,'o');
##title ("sum corrections ted in symbol");

figure(7);
##plot(data_symbols(end-1024:end),'o');
plot(data_symbols,'o');
title ("last 1024 data symbols");

figure(8);
plot(ADEBUG_TABLE_loop_out_ped,'o');
title ("loop out ped");

figure(9);
plot(ADEBUG_TABLE_data_symbols_angle,'o');
title ("data symbols angle");



eyediagram(data_symbols(end-1024:end),Fresamp/Fsymb/2);


