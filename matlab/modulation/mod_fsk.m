function [data_out,phase_store]=mod_fsk(data_in,phase_init,ovr,fsk_deviation)
  
  %Data in is a table of 0 and 1
  
  nb_size=length(data_in);
  
  %Upsamp data_in
  data_in_upsamp=zeros(1,nb_size*ovr);
  for k=1:ovr
    data_in_upsamp(k:ovr:end)=data_in;
  end

  %FSK modulation
  data_in_upsamp_nrz=(data_in_upsamp*2-1);
  phase_step=fsk_deviation/ovr*2*pi;
  phase=phase_step*data_in_upsamp_nrz;
  phase_cum=cumsum(phase)+phase_init;
  mod_signal=sin(phase_cum);
  
  data_out=mod_signal;
  phase_store = phase_cum(end);
  
end
