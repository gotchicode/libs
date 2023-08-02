function [h_quant, h_quant_gain] = filter_tap_quant(h, n_bits)

  nb_sample=1e6;
  data_in=zeros(1,nb_sample)+1;
  data_out=conv(data_in,h);
  measured_gain=data_out(nb_sample/2)/data_in(nb_sample/2);
  h_max=max(h);
  h_quant = round((2^(n_bits-1)-1)/h_max*h);
  h_max=max(h_quant)

  data_in=zeros(1,nb_sample)+1;
  data_out=conv(data_in,h_quant);
  measured_gain=data_out(nb_sample/2)/data_in(nb_sample/2);

  log2(measured_gain)
  floor(log2(measured_gain))
  (measured_gain / 2^(floor(log2(measured_gain))))
  h_quant_gain_power_of_2 = round(h_quant ./ (measured_gain / 2^(floor(log2(measured_gain)))));

  data_in=zeros(1,nb_sample)+1;
  data_out=conv(data_in,h_quant_gain_power_of_2);
  measured_gain_last=data_out(nb_sample/2)/data_in(nb_sample/2)
  
  h_quant = h_quant_gain_power_of_2;
  
  h_quant_gain = measured_gain_last;
  
end