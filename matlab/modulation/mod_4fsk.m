function [data_out,phase_store,data_map]=mod_4fsk(data_in,phase_init,ovr,fsk_deviation)
  
  %Data in is a table of 0 and 1 and must be even  
  nb_size=length(data_in);
  
  %Map to symbols with values -3 -1 +1 +3
  data_map = zeros(1,nb_size/2);
  data_map_index=1;
  for k=1:2:nb_size
    if (data_in(k)==0 && data_in(k+1)==0) 
      data_map(data_map_index)=-3;
    endif
    if (data_in(k)==0 && data_in(k+1)==1) 
      data_map(data_map_index)=-1;
    endif
    if (data_in(k)==1 && data_in(k+1)==0) 
       data_map(data_map_index)=1;
    endif
    if (data_in(k)==1 && data_in(k+1)==1) 
       data_map(data_map_index)=3;
    endif
    data_map_index = data_map_index+1;
  end
  
  %Upsamp data_in
  data_in_upsamp=zeros(1,nb_size/2*ovr);
  for k=1:ovr
    data_in_upsamp(k:ovr:end)=data_map;
  end

  %FSK modulation
  data_in_upsamp_nrz=(data_in_upsamp);
  phase_step=fsk_deviation/ovr*2*pi;
  phase=phase_step*data_in_upsamp_nrz;
  phase_cum=cumsum(phase)+phase_init;
  mod_signal=cos(phase_cum)+j*sin(phase_cum);
  
  data_out=mod_signal;
  phase_store = phase_cum(end);
  
end
