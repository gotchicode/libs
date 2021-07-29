
function [data_out,phase_store_I,phase_store_Q,data_debug]=mod_gmsk(data_in,phase_init_I,phase_init_Q,ovr,msk_deviation,BT)

%Addpath for the gaussion filter
addpath ("../filter")
  
%Constant forcing how is computed the MSK modulation

msk_method=0; %0: real only, 1:real and imag paths (not validated) 

if msk_method==0
    %-----------------------------------
    %----- MSK modulation
    %-----------------------------------
    %Data in is a table of 0 and 1
    
    nb_size=length(data_in);
    data_in=(data_in*2-1);
    
    %Upsamp by zeros
    data_in_upsamp=zeros(1,nb_size*ovr);
    data_in_upsamp(1:ovr:end)=data_in;
    
    %Phase initialization
    phase_init=phase_init_I;
    
    %Gaussian filter initialization
    %Parameters amd kernel
    Tb=1; L=ovr; k=2;
    h = gmsk_function(BT, Tb, L, k);

    data_in_upsamp_nrz = filter(h,1,data_in_upsamp); %filtering
    data_in_upsamp_nrz = data_in_upsamp_nrz*ovr; %gain compensation of the zero hold
    phase_step=msk_deviation/ovr*pi;
    phase=phase_step*data_in_upsamp_nrz;
    phase_cum=cumsum(phase)+phase_init_I;
    mod_signal=sin(phase_cum);
    phase_store_I=phase_cum(end);
    phase_store_Q=0;
    
    data_out = mod_signal;
    
    data_debug = data_in_upsamp_nrz;

end
 
if msk_method==1
    %-----------------------------------
    %----- MSK modulation
    %-----------------------------------
    %Data in is a table of 0 and 1

    nb_size=length(data_in);

    %Create I and Q rails
    data_in_I_rail=data_in(1:2:end);
    data_in_Q_rail=data_in(2:2:end);

    %Upsamp
    data_in_I_rail_upsamp=zeros(1,nb_size*ovr/2);
    for k=1:ovr
      data_in_I_rail_upsamp(k:ovr:end)=data_in_I_rail;
    end
    data_in_Q_rail_upsamp=zeros(1,nb_size*ovr/2);
    for k=1:ovr
      data_in_Q_rail_upsamp(k:ovr:end)=data_in_Q_rail;
    end

    %Phase initialization
    phase_init_I=0;
    phase_init_Q=0;

    %MSK modulation
    data_in_I_rail_upsamp_nrz=(data_in_I_rail_upsamp*2-1);
    phase_step=msk_deviation/ovr*2*pi;
    phase=phase_step*data_in_I_rail_upsamp_nrz;
    phase_cum=cumsum(phase)+phase_init_I;
    mod_signal_I=sin(phase_cum);
    phase_store_I=phase_cum(end);

    data_in_Q_rail_upsamp_nrz=(data_in_Q_rail_upsamp*2-1);
    phase_step=msk_deviation/ovr*2*pi;
    phase=phase_step*data_in_Q_rail_upsamp_nrz;
    phase_cum=cumsum(phase)+phase_init_Q;
    mod_signal_Q=sin(phase_cum);
    phase_store_Q=phase_cum(end);

    %Data out with Q rail delayed by one sample
    data_out=mod_signal_I(ovr/2+1:end)+j*mod_signal_Q(1:end-ovr/2);


end
  
end
