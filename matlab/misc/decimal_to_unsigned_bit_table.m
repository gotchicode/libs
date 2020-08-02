function data_out = decimal_to_unsigned_bit_table(data_in,nb_bit)
  
  data_tmp = mod(data_in,2^nb_bit);
  data_out = zeros(1,nb_bit);
  for k=1:nb_bit
    tmp = 2^(k-1);
    tmp = mod(floor(data_tmp/tmp),2);
    data_out(nb_bit-k+1)=tmp;
  end
  
end
