clc;
clear all;
close all;

data_in = -2^15+2;
nb_bit=16;
data_out = decimal_to_signed_bit_table(data_in,nb_bit)

data_in = 2^15-1;
nb_bit=16;
data_out = decimal_to_signed_bit_table(data_in,nb_bit)

data_in = -2;
nb_bit=16;
data_out = decimal_to_signed_bit_table(data_in,nb_bit)

