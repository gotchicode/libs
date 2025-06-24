clc;
clear all;
close all;

% Parameters
nb_bits = 2^12;

%Persistant registers
in_enc_shift_reg = zeros(1,9);
out_enc_shift_reg = zeros(1,9);

%In generation
in_enc_table = zeros(1,nb_bits)+1;
out_enc_table = zeros(1,nb_bits)+1;

%Scrambler
out_enc_table = pn_9_enc_1b(in_enc_table, in_enc_shift_reg, out_enc_shift_reg);

%Record to a file
sequence = out_enc_table(461:971);
filename = 'pn9.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%d\n', sequence);
fclose(fileID);


