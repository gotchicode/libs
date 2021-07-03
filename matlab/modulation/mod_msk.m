function [data_out,phase_store_I,phase_store_Q]=mod_msk(data_in,phase_init_I,phase_init_Q,ovr,msk_deviation)
  
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

mod_signal=data_out;
  
end
