clc;
clear all;
close all

nb_size= 256*256;
select_size=1024;
debug=1;

my_fft_init_data_out = my_fft_init(nb_size,debug);

data_out=get_fft_init_table(my_fft_init_data_out, nb_size, select_size,debug);