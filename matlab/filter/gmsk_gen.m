clc;
clear all;
close all;

%Parameters
nb_sample = 2^10;
Fsymb = 1;
Fsamp = 100;
B_T=0.3;
manual_gain=1;

%Init
Ts=1/Fsymb;
Tsamp=1/Fsamp;
t=(-5:Tsamp:5);

%Intermediate calculations
B=B_T/Tsamp;

%Filter coefficients
delta_h = sqrt(log(2))/2/pi/B/Tsamp;
h=zeros(1,length(t));
for k=1:length(t)
    h(k)=[exp(-1*t(k)^2)/(2*delta_h^2*Tsamp^2)] / [sqrt(2*pi)*delta_h*Tsamp];
end;

%Measure gain
data_in=zeros(1,nb_sample)+1023;
data_out=conv(data_in,h);
measured_gain=data_out(nb_sample/2)/data_in(nb_sample/2);

%Compense
h=h/measured_gain*manual_gain;

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

%Save taps for gnu radio
fid=fopen('taps_gnu_radio.txt','w');
fprintf(fid,'[');
for k=1:length(h)
  if k==length(h)
    fprintf(fid,'%f]\n',h(k));
   else
    fprintf(fid,'%f,\n',h(k));
   end;
end;
  
fclose(fid);
