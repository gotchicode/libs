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

%Init RRCC filter taps

%Init
Fin_detect_flag=0;
Fsymb_detect_flag=0;
gardner_ted_store_symbol_y0=0;
##nco_accu_tmp_fsymb=2^32/8*1;
nco_accu_tmp_fsymb=2^32/32*(4+5);
nco_accu_tmp_fsymb_xovr=0;
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
fsymb_x2_sync_flag=0;
gardner_ted_store_symbol_y1=0;
nco_accu_tmp_fsymb_xovr_table = zeros(1,length(data_in)); 
Fin_detect_flag_table= zeros(1,length(data_in));
Fsymb_detect_flag_table= zeros(1,length(data_in));
fsymb_x2_flag_table=zeros(1,length(data_in));
fsymb_x2_flag_sync_table=zeros(1,length(data_in));
ted_table_real= zeros(1,length(data_in));
ted_table_real_enable_p = zeros(1,length(data_in));
ted_table_real_enable_n = zeros(1,length(data_in));
ted_table_imag= zeros(1,length(data_in));
ted_table_imag_enable_p = zeros(1,length(data_in));
ted_table_imag_enable_n = zeros(1,length(data_in));

for k=1:length(data_in_I)
  
    %Running NCO at Fsymb
    nco_accu_tmp_fsymb_r1 = nco_accu_tmp_fsymb;
    nco_accu_tmp_fsymb = mod(nco_accu_tmp_fsymb+Fsymb/Fin*2^32,2^32);
  
    %Running NCO at Fsymb x ovr
    nco_accu_tmp_fsymb_xovr_r1 = nco_accu_tmp_fsymb_xovr;
    nco_accu_tmp_fsymb_xovr =  mod(nco_accu_tmp_fsymb * (Fresamp/Fsymb),2^32);
##    nco_accu_tmp_fsymb_xovr_r1 = nco_accu_tmp_fsymb_xovr;
##    nco_accu_tmp_fsymb_xovr = mod(nco_accu_tmp_fsymb_xovr+Fsymb/Fin*2^32*(Fresamp/Fsymb),2^32);
####    nco_accu_tmp_fsymb_xovr = mod(nco_accu_tmp_fsymb_xovr+Fresamp/Fin*2^32,2^32);

    %Generate the pulse of the Fsymb
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb<nco_accu_tmp_fsymb_r1;
          Fsymb_detect_flag=1;
      else
          Fsymb_detect_flag=0;
      end
    end
    Fsymb_detect_flag_table(k)=Fsymb_detect_flag;
    nco_accu_tmp_fsymb_table(k) = nco_accu_tmp_fsymb;
    
    %Generate the pulse of the Fsymb x ovr
    if (k>1 && k<length(data_in)-1) 
      if nco_accu_tmp_fsymb_xovr<nco_accu_tmp_fsymb_xovr_r1;
          Fin_detect_flag=1;
      else
          Fin_detect_flag=0;
      end
    end
    Fin_detect_flag_table(k)=Fin_detect_flag;
    nco_accu_tmp_fsymb_xovr_table(k) = nco_accu_tmp_fsymb_xovr;
    
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
        data_resample(index_resample) = mu_direct_interp(decimation_samples, nco_accu_tmp_fsymb_xovr/2^32, interp_type,debug);
        end;
    end;
    
    %RRC filtering
    if Fin_detect_flag==1
      filter_kernel(2:end)=filter_kernel(1:end-1);
      filter_kernel(1)=data_resample(index_resample);
      tmp = sum(filter_kernel.*h_quant);
      data_rrc_filtered(index_resample) = tmp / h_quant_gain;
    end;
    
    %Downsample to symb rate x2
    if Fin_detect_flag==1
      if Fsymb_detect_flag==1
        downsample_cnt =0;
      else
        downsample_cnt = mod(downsample_cnt + 1, downsample_factor);
      end
      if (downsample_cnt==0 || downsample_cnt==downsample_factor/2)
        index_rrc_filter=index_rrc_filter+1;
        data_rrc_filtered_rate_x2(index_rrc_filter) = data_rrc_filtered(index_resample);
        fsymb_x2_flag =1;
        fsymb_x2_flag_table(index_resample)=1;
      else
        fsymb_x2_flag =0;
      end
      if downsample_cnt==0
        fsymb_x2_sync_flag=1;
       else
        fsymb_x2_sync_flag=0;
      end
      fsymb_x2_flag_sync_table(index_resample)=fsymb_x2_sync_flag;
##      fprintf("Fin_detect_flag=%d Fsymb_detect_flag=%d fsymb_x2_flag=%d downsample_cnt=%d fsymb_x2_sync_flag=%d\n",Fin_detect_flag ,Fsymb_detect_flag , fsymb_x2_flag, downsample_cnt, fsymb_x2_sync_flag);
      
    else
      fsymb_x2_flag =0;
    end
    
    %Gardner TED at symb rate x2
    if fsymb_x2_flag==1
      
      if fsymb_x2_sync_flag==1
        
        %Real
        if ( real(data_rrc_filtered(index_resample))<0 && real(gardner_ted_store_symbol_y0) >0 )
          ted_table_real(index_resample) = real(gardner_ted_store_symbol_y1) * ( real(data_rrc_filtered(index_resample)) - real(gardner_ted_store_symbol_y0) );
          ted_table_real_enable_p(index_resample)=1;
        end
        if ( real(data_rrc_filtered(index_resample))>0 && real(gardner_ted_store_symbol_y0) <0 )
          ted_table_real(index_resample) = real(gardner_ted_store_symbol_y1) * ( real(data_rrc_filtered(index_resample)) - real(gardner_ted_store_symbol_y0) );
          ted_table_real_enable_n(index_resample)=-1;
        end
        
        %Imag
        if ( imag(data_rrc_filtered(index_resample))<0 && imag(gardner_ted_store_symbol_y0) >0 )
          ted_table_imag(index_resample) = imag(gardner_ted_store_symbol_y1) * ( imag(data_rrc_filtered(index_resample)) - imag(gardner_ted_store_symbol_y0) );
          ted_table_imag_enable_p(index_resample)=1;
        end
        if ( imag(data_rrc_filtered(index_resample))>0 && imag(gardner_ted_store_symbol_y0) <0 )
          ted_table_imag(index_resample) = imag(gardner_ted_store_symbol_y1) * ( imag(data_rrc_filtered(index_resample)) - imag(gardner_ted_store_symbol_y0) );
          ted_table_imag_enable_n(index_resample)=-1;
        end
        
      end;
      
      gardner_ted_store_symbol_y0 = gardner_ted_store_symbol_y1;
      gardner_ted_store_symbol_y1 = data_rrc_filtered(index_resample);

    end; %end gardner ted
  
    
    
end

%Select only correct samples up to index_sample for debug
data_resample = data_resample(1:index_resample);
data_rrc_filtered = data_rrc_filtered(1:index_resample);
data_rrc_filtered_rate_x2 = data_rrc_filtered_rate_x2(1:index_rrc_filter);
fsymb_x2_flag_table = fsymb_x2_flag_table(1:index_resample);
fsymb_x2_flag_sync_table = fsymb_x2_flag_sync_table(1:index_resample);
ted_table_real = ted_table_real(1:index_resample);
ted_table_real_enable_p = ted_table_real_enable_p(1:index_resample);
ted_table_real_enable_n = ted_table_real_enable_n(1:index_resample);
ted_table_imag = ted_table_imag(1:index_resample);
ted_table_imag_enable_p = ted_table_imag_enable_p(1:index_resample);
ted_table_imag_enable_n = ted_table_imag_enable_n(1:index_resample);

data_resample_I=real(data_resample);
data_resample_Q=imag(data_resample);

##figure(10);
##start_val=1007;
##end_val=start_val+64;
##plot(Fsymb_detect_flag_table(start_val:end_val)*0.25);
##hold on;
##plot(Fin_detect_flag_table(start_val:end_val)*0.125);
##hold on;
##plot(data_in_I(start_val:end_val));
##plot(nco_accu_tmp_fsymb_table(start_val:end_val)/2^32);
##legend('Fsymb detect flag_table', 'Fin detect flag table', 'data in I', 'nco accu tmp fsymb table' );
##
##eyediagram(data_rrc_filtered_rate_x2,2);


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

##eyediagram (data_in, 8);
##eyediagram (data_resample, 4);
##eyediagram (data_rrc_filtered, 4);
##eyediagram (data_rrc_filtered_rate_x2, 4);
##eyediagram (data_rrc_filtered_rate_x2, 8);

##figure(1);
##plot(real(data_rrc_filtered_rate_x2));
##
##figure(2);
##plot(imag(data_rrc_filtered_rate_x2))

##plot(data_rrc_filtered_rate_x2,'.');
##
##figure(3)
##plot(real(data_rrc_filtered));
##hold on;
##plot(ted_table_real,'.');
##hold on;
##plot(ted_table_real_enable_p*0.1);
##hold on;
##plot(ted_table_real_enable_n*0.1);
##hold on;
##plot(fsymb_x2_flag_sync_table*0.5);
##hold on;
##plot(fsymb_x2_flag_table*0.25);
##fprintf("mean=%d sum=%f nb_p=%d nb_n=%d\n",sum(ted_table_real)/(sum(ted_table_real_enable_p)-sum(ted_table_real_enable_n)), sum(ted_table_real.*ted_table_real), sum(ted_table_real_enable_p), sum(ted_table_real_enable_n)  )
##
figure(4)
plot(real(data_rrc_filtered));
hold on;
plot(ted_table_imag,'.');
hold on;
plot(ted_table_imag_enable_p*0.1);
hold on;
plot(ted_table_imag_enable_n*0.1);
hold on;
plot(fsymb_x2_flag_sync_table*0.5);
hold on;
plot(fsymb_x2_flag_table*0.25);
fprintf("mean=%d sum=%f nb_p=%d nb_n=%d\n",sum(ted_table_imag)/(sum(ted_table_imag_enable_p)-sum(ted_table_imag_enable_n)), sum(ted_table_imag.*ted_table_imag), sum(ted_table_imag_enable_p), sum(ted_table_imag_enable_n)  )

##figure(4);
##plot(real(data_rrc_filtered));
##hold on;
##plot(fsymb_x2_flag_table);
##hold on;
##plot(fsymb_x2_flag_sync_table*0.5);


##figure(5);
##EYE_DIAG_data_in = eye_diag(data_in,8);
##plot(real(EYE_DIAG_data_in(:,end-256:end)));

##figure(6);
##EYE_DIAG_data_resample_I = eye_diag(data_resample_I,8);
##plot(real(EYE_DIAG_data_resample_I(:,end-256:end)));
##
##figure(7);
##EYE_DIAG_data_rrc_filtered = eye_diag(data_rrc_filtered,8);
##plot(real(EYE_DIAG_data_rrc_filtered(:,end-256:end)));

##figure(8);
##EYE_DIAG_data_rrc_filtered_rate_x2 = eye_diag(data_rrc_filtered_rate_x2,4);
##plot(real(EYE_DIAG_data_rrc_filtered_rate_x2(:,end-256:end)));

##figure(8);
##plot(data_in_I);
##hold on;
##plot(Fin_detect_flag_table*0.1);

##figure(9);
##mm=900;
##kk=64
##ll=32;
##plot(data_in_I(mm-kk:mm-ll));
##hold on;
##plot(Fin_detect_flag_table(mm-kk:mm-ll)*0.5);
##hold on;
##plot(Fsymb_detect_flag_table(mm-kk:mm-ll)*0.25);
##hold on;
##plot(Fsymb_detect_flag_table(mm-kk:mm-ll)*0.25);

##figure(10);
##plot(data_resample_I);
##hold on;
##plot(fsymb_x2_flag_sync_table*0.25);

##figure(11);
##plot(data_resample_I);
##hold on;
##plot(fsymb_x2_flag_sync_table*0.25);

##figure(12);
##plot(real(data_rrc_filtered(3240:3260+10)));
##hold on;
##plot(fsymb_x2_flag_sync_table(3240:3260+10)*0.25);
##hold on;
##plot(fsymb_x2_flag_table(3240:3260+10)*0.125);



