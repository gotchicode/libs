function data_out = pn_23_enc_1b(data_in, in_shift_reg_enc, out_shift_reg_enc)

  %Scrambler
  shift_reg_enc = in_shift_reg_enc;
  for k=1:length(data_in)
    tmp = data_in(k);
    out_tmp = xor(shift_reg_enc(18),shift_reg_enc(23));
    out = xor(tmp,out_tmp);
    out_enc_table(k) = out;
    shift_reg_enc(2:23)=shift_reg_enc(1:22);
    shift_reg_enc(1) = out;
  end;

  data_out = out_enc_table;
  out_shift_reg_enc = shift_reg_enc;

end