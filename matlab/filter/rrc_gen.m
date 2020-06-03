clc;
clear all;
close all;

%Equation from https://en.wikipedia.org/wiki/Root-raised-cosine_filter

%Parameters
nb_sample = 2^10;
Fsymb = 1;
Fsamp = 4;
roll_off = 0.25;

%Init
Ts=1/Fsymb;
Tsamp=1/Fsamp;
t=(-9:Tsamp:9);

%Filter coefficients
h_zero = 1/Ts*(1+roll_off*(4/pi-1));
h_Ts_4_roll_off = roll_off/Ts/sqrt(2) * [(1+2/pi) * sin(pi/4/roll_off) + (1-2/pi) * cos(pi/4/roll_off)];
h= 1/Ts * (sin(pi*t/Ts*(1-roll_off)) + 4*roll_off*t/Ts.*cos(pi*t/Ts*(1+roll_off))) ./ (pi * t/Ts .* [1-(4*roll_off*t/Ts).^2]);

%Replace the h_zero
for k=1:length(t)
  if t(k)==0
    h(k)=h_zero;
  endif
end;

%Replace the h_Ts_4_roll_off
for k=1:length(t)
  if t(k)==Ts/4/roll_off
    h(k)=h_Ts_4_roll_off;
    printf('found h_Ts_4_roll_off\n');
  endif
  if t(k)==-Ts/4/roll_off
    h(k)=h_Ts_4_roll_off;
    printf('-found h_Ts_4_roll_off\n');
  endif
end;

%Plot the taps
figure(1);
x_axis = t;
plot(x_axis,h);
title('root raised cosine filter taps');

%Plot the reponse
figure(2);
freqz(h,1,512);

%Save taps
fid=fopen('taps.txt','w');
fprintf(fid,'%f\n',h);
fclose(fid);


