function data_out = pn_9_dec_1b(data_in, in_shift_reg_dec, out_shift_reg_dec)

  % Descrambler for PN9: x^9 + x^5 + 1
  shift_reg_dec = in_shift_reg_dec;
  for k = 1:length(data_in)
    tmp = data_in(k);
    out_tmp = xor(shift_reg_dec(5), shift_reg_dec(9));
    out = xor(tmp, out_tmp);
    out_dec_table(k) = out;
    shift_reg_dec(2:9) = shift_reg_dec(1:8);
    shift_reg_dec(1) = tmp;
  end

  data_out = out_dec_table;
  out_shift_reg_dec = shift_reg_dec;

end
