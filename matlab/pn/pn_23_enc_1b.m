function data_out = pn_23_enc_1b(data_in)

  %Scrambler
  shift_reg_enc = zeros(1,23);
  for k=1:length(data_in)
    tmp = data_in(k);
    out_tmp = xor(shift_reg_enc(18),shift_reg_enc(23));
    out = xor(tmp,out_tmp);
    out_enc_table(k) = out;
    shift_reg_enc(2:23)=shift_reg_enc(1:22);
    shift_reg_enc(1) = out;
  end;

  data_out = out_enc_table;

end