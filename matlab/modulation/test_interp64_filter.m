clc;
clear all;
close all;

%Parameters
nb_sample = 2^8;
Fsymb = 1;
Fsamp = 64;

%Test vector
##data_in = [zeros(1,nb_sample/2) ones(1,nb_sample/2)];
data_in=repmat([1 1 1 1 1 1 0 0 0 0 0 0],1,nb_sample/8);
data_in = [zeros(1,nb_sample/2) data_in];

%Filter
taps=csvread('interp64_filter_taps.txt');
nb_taps=length(taps);
[data_out,data_out_ovr] = up_and_filter(data_in,Fsamp,0,taps);

data_out_ovr_with_delay=[zeros(1,floor(nb_taps/2)) data_out_ovr];
data_out_ovr_with_delay=data_out_ovr_with_delay(1:length(data_out));

%Display
figure(1)
plot(data_out_ovr);
hold on;
plot(data_out);

figure(2);
plot(data_out_ovr_with_delay);
hold on;
plot(data_out);
