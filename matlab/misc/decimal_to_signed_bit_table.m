function data_out = decimal_to_signed_bit_table(data_in,nb_bit)
  
  if data_in>0 && data_in<(2^nb_bit-1)
    data_in = data_in
  else
    data_in = (2^nb_bit-1)+data_in+1;
  end
  
  data_tmp = mod(data_in,2^nb_bit);
  data_out = zeros(1,nb_bit);
  for k=1:nb_bit
    tmp = 2^(k-1);
    tmp = mod(floor(data_tmp/tmp),2);
    data_out(nb_bit-k+1)=tmp;
  end
  
end
