clc;
clear all;
close all;

% Parameters
nb_bits = 2^8;
ber=1;

%Persistant registers
in_enc_shift_reg = zeros(1,23);
out_enc_shift_reg = zeros(1,23);

in_dec_shift_reg = zeros(1,23);
out_dec_shift_reg = zeros(1,23);

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
out_enc_table = pn_23_enc_1b(in_enc_table, in_enc_shift_reg, out_enc_shift_reg);

%Add errors
in_error_table=out_enc_table;
in_error_table(100) = mod(in_error_table(100)+1,2);
out_error_table=in_error_table;
in_dec_table=out_error_table;

##%Descrambling
out_dec_table = pn_23_dec_1b(in_dec_table, in_dec_shift_reg, out_dec_shift_reg);

plot(out_dec_table);
sum(out_dec_table==0)