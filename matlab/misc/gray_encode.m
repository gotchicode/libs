function data_out = gray_encode(data_in,nb_bits)
  data_in_bin = decimal_to_unsigned_bit_table(data_in,nb_bits);
  data_in_bin_shifted = [0 data_in_bin(1:end-1)];
  data_out = xor(data_in_bin,data_in_bin_shifted);
end