clc;
clear all;
close all;

%Parameters
Fsymb = 1;
Fsamp = 64;
roll_off = 1;
n_bits=16;
vector_size=10e3;

%Call external rrc filter with taps
addpath ("../filter");

#%Calculate RRC taps
h = rrc_function(Fsymb, Fsamp, roll_off);
[h_quant,h_quant_gain] = filter_tap_quant(h, n_bits);

%Generate a test vector of BPSK values
test_vector_in = round(rand(1,vector_size))*2-1;

%Filter and upsample with a polyphase
test_vector_out = polyphase_filter(test_vector_in,h_quant,Fsamp,Fsymb);
