clc;
clear all;
close all;

taps = zeros(1,68);

taps(33)=0;
taps(34)=1;
taps(35)=1;
taps(36)=0;

freqz(taps,1);