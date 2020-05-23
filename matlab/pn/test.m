clc;
clear all;
close all;

% Parameters
nb_bits = 2^8;
ber=1;


%In generation
in_enc_table = zeros(1,nb_bits)+1;
out_enc_table = zeros(1,nb_bits)+1;

%Error tables generation
in_error_table = zeros(1,nb_bits)+1;
out_error_table = zeros(1,nb_bits)+1;

%Out init
in_dec_table = zeros(1,nb_bits)+1;
out_dec_table = zeros(1,nb_bits)+1;


%Scrambler
out_enc_table = pn_23_enc_1b(in_enc_table);
##shift_reg_enc = zeros(1,23);
##for k=1:length(in_enc_table)
##  tmp = in_enc_table(k);
##  out_tmp = xor(shift_reg_enc(18),shift_reg_enc(23));
##  out = xor(tmp,out_tmp);
##  out_enc_table(k) = out;
##  shift_reg_enc(2:23)=shift_reg_enc(1:22);
##  shift_reg_enc(1) = out;
##end;


%Add errors
in_error_table=out_enc_table;
in_error_table(100) = mod(in_error_table(100)+1,2);
out_error_table=in_error_table;
in_dec_table=out_error_table;

##%Descrambling
out_dec_table = pn_23_dec_1b(in_dec_table);
##shift_reg_dec = zeros(1,23);
##for k=1:length(in_dec_table)
##  tmp = in_dec_table(k);
##  out_tmp = xor(shift_reg_dec(18),shift_reg_dec(23));
##  out = xor(tmp,out_tmp);
##  out_dec_table(k) = out;
##  shift_reg_dec(2:23)=shift_reg_dec(1:22);
##  shift_reg_dec(1) = tmp;
##end;

plot(out_dec_table);
sum(out_dec_table==0)