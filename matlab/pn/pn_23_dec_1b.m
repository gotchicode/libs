function data_out = pn_23_dec_1b(data_in, in_shift_reg_dec, out_shift_reg_dec)

  %Descrambling
  shift_reg_dec = in_shift_reg_dec;
  for k=1:length(data_in)
    tmp = data_in(k);
    out_tmp = xor(shift_reg_dec(18),shift_reg_dec(23));
    out = xor(tmp,out_tmp);
    out_dec_table(k) = out;
    shift_reg_dec(2:23)=shift_reg_dec(1:22);
    shift_reg_dec(1) = tmp;
  end;

  data_out=out_dec_table;
  out_shift_reg_dec=shift_reg_dec;
 
end