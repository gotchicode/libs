
function [data_out,phase_store_I,phase_store_Q]=mod_msk(data_in,phase_init_I,phase_init_Q,ovr,msk_deviation)
  
%Constant forcing how is computed the MSK modulation

msk_method=1; %0: real only, 1:real and imag paths (not validated) 

if msk_method==0
    %-----------------------------------
    %----- MSK modulation
    %-----------------------------------
    %Data in is a table of 0 and 1
    
    nb_size=length(data_in);
    
    %Upsamp
    data_in_upsamp=zeros(1,nb_size*ovr);
    for k=1:ovr
      data_in_upsamp(k:ovr:end)=data_in;
    end
    
    %Phase initialization
    phase_init=phase_init_I;
    
    data_in_upsamp_nrz=(data_in_upsamp*2-1);
    phase_step=msk_deviation/ovr*pi;
    phase=phase_step*data_in_upsamp_nrz;
    phase_cum=cumsum(phase)+phase_init_I;
    mod_signal=sin(phase_cum);
    phase_store_I=phase_cum(end);
    phase_store_Q=0;
    
    data_out = mod_signal;

end
 
if msk_method==1
    %-----------------------------------
    %----- MSK modulation
    %-----------------------------------
    %Data in is a table of 0 and 1
    
    nb_size=length(data_in);
    
    %Upsamp
    data_in_upsamp=zeros(1,nb_size*ovr);
    for k=1:ovr
      data_in_upsamp(k:ovr:end)=data_in;
    end
    
    %Phase initialization
    phase_init=phase_init_I;
    
    data_in_upsamp_nrz=(data_in_upsamp*2-1);
    phase_step=msk_deviation/ovr*pi;
    phase=phase_step*data_in_upsamp_nrz;
    phase_cum=cumsum(phase)+phase_init_I;
    mod_signal= cos(phase_cum) + j*sin(phase_cum);
    phase_store_I=phase_cum(end);
    phase_store_Q=0;
    
    data_out = mod_signal;


end
  
end
