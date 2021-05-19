clc;
clear all;
close all;

%Simu param
nb_size=2^14;

%Parameters
Fsamp=50*1000;
Fsig=0.4;
Amp=1;

%Init time sequence
t=(1/Fsamp:1/Fsamp:nb_size/Fsamp);

%Generate input signal
Ia = Amp * sin(2*pi*Fsig*t);
Ia_sq = Ia .* Ia; 
integ=sum(Ia_sq)