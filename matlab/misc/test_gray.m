clear all;
close all;
clc;

%Parameters
nb_bits=16;

%generate a nb_bit bit value
data_gen = ceil(rand*2^nb_bits);
##data_gen = 14;

%Encode in Gray
data_gray_encoder = gray_encode(data_gen,nb_bits);

%Decode from Gray
data_gen_out=gray_decode(data_gray_encoder,nb_bits);


