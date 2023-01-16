clc;
clear all;
close all;

%Load from file
inI = csvread("data_mod_I.txt");
inQ = csvread("data_mod_Q.txt");
In = inI + j*inQ;

%Angle
In_angle = angle(In);

%Unwrap
In_angle_unwrapped = unwrap(In_angle);

%Discriminator
In_angle_discr = In_angle_unwrapped(2:end) - In_angle_unwrapped(1:end-1);

plot(In_angle_discr);
