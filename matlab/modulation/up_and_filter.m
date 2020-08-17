function [data_out_filtered,data_out_ovr] = up_and_filter(data_in,interp_factor,filter_mode,taps)
  
data_modulated = data_in;
  
%Upsampling with zero hold
if filter_mode==0
  
  data_modulated_ovr = zeros(1,length(data_modulated)*interp_factor);
    for m=1:interp_factor
      data_modulated_ovr(m:interp_factor:end)=data_modulated;
    end
    data_modulated_filtered=filter(taps,1,data_modulated_ovr);

##  %Sync output of filter
##  data_modulated_sync = data_modulated(7:end);
##  data_modulated_filtered_sync = data_modulated_filtered(46:4:end);
##  t_end=length(data_modulated_filtered_sync);
##  data_modulated_sync=data_modulated_sync(1:t_end);
  
end

%Upsampling with zero padding
if filter_mode==1

  data_modulated_ovr = zeros(1,length(data_modulated)*interp_factor);
  data_modulated_ovr(1:interp_factor:end)=data_modulated;
  data_modulated_filtered=filter(taps,1,data_modulated_ovr);

##  %Sync output of filter
##  data_modulated_sync = data_modulated(7:end);
##  data_modulated_filtered_sync = data_modulated_filtered(46:4:end);
##  t_end=length(data_modulated_filtered_sync);
##  data_modulated_sync=data_modulated_sync(1:t_end);
  
end

data_out_filtered = data_modulated_filtered;
data_out_ovr=data_modulated_ovr;
  
  
end
