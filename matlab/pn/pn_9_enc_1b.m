function data_out = pn_9_enc_1b(data_in, in_shift_reg_enc, out_shift_reg_enc)

  % Scrambler for PN9: x^9 + x^5 + 1
  shift_reg_enc = in_shift_reg_enc;
  for k = 1:length(data_in)
    tmp = data_in(k);
    out_tmp = xor(shift_reg_enc(5), shift_reg_enc(9));
    out = xor(tmp, out_tmp);
    out_enc_table(k) = out;
    shift_reg_enc(2:9) = shift_reg_enc(1:8);
    shift_reg_enc(1) = out;
  end

  data_out = out_enc_table;
  out_shift_reg_enc = shift_reg_enc;

end
