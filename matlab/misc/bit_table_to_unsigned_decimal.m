function data_out = bit_table_to_unsigned_decimal(data_in)
  tmp=0:length(data_in)-1;
  tmp=fliplr(tmp);
  tmp=2.^tmp;
  tmp=data_in.*tmp;
  data_out=sum(tmp);
end