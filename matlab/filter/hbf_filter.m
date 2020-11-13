

function data_out = hbf_filter(data_in, ratio, type)

%Ratio must be a power of 2

%Type
% 0: filter only
% 1: interpolation
% -1: decimation

% Load the taps
taps = csvread('hbf_taps.txt');

if type==0
    data_out=conv(data_in,taps);
end

if type==1
  
  %Over sampling with zeros
  data_in_ovr = zeros(1,length(data_in)*2);
  data_in_ovr(1:2:end) = data_in;
  
  %Filter at x2
  data_out = conv(data_in_ovr,taps);
  
  %Recursive enter and do the same
  if ratio>2
    data_in=data_out;
    ratio=ratio/2;
    data_out = hbf_filter(data_in, ratio, type);
  end
  
end

if type==-1
  
  %Apply the filter
  %Filter at x2
  data_filtered = conv(data_in,taps);
  
  %Decimate
  data_filtered_decim=data_filtered(1:2:end);
  data_out=data_filtered_decim;
  
  %Recursive enter and do the same
  if ratio>2
    data_in=data_out;
    ratio=ratio/2;
    data_out = hbf_filter(data_in, ratio, type);
  end
  
end
  




end