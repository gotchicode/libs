function data_out = gray_decode(data_in,nb_bits)
  tmp =data_in;
  tmp2=tmp;
  last_iter=0;
  for k=1:length(tmp2)
    if last_iter==0
      tmp2=[0 tmp2(1:end-1)];
      tmp=xor(tmp,tmp2);
      if tmp2==zeros(1,nb_bits)
        last_iter=1;
      end;
    end;
  end;
  data_out=bit_table_to_unsigned_decimal(tmp);
end