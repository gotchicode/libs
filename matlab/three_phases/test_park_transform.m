clc;
clear all;
close all;

%Simu param
nb_size=2^14;

%Parameters
Fsamp=50*1000;
Fsig=50;
Amp=1;

%Init time sequence
t=(1/Fsamp:1/Fsamp:nb_size/Fsamp);

%Generate input signal
Ia = Amp * sin(2*pi*Fsig*t);
Ib = Amp * sin(2*pi*Fsig*t-2*pi/3);
Ic = Amp * sin(2*pi*Fsig*t+2*pi/3);

%Generate a local phase
##theta=2*pi*Fsamp*Fsig:2*pi*Fsamp*Fsig:nb_size*2*pi*Fsamp*Fsig;
f_teta=Fsig*1.05;
theta = 2*pi*f_teta/Fsamp:2*pi*f_teta/Fsamp:2*pi*f_teta/Fsamp*nb_size;
theta = mod(2*pi/3+theta,2*pi);

%DQ0 transform
Id=zeros(1,nb_size);
Iq=zeros(1,nb_size);
Io=zeros(1,nb_size);
for k=1:length(Ia)
  tmp_right = [Ia(k); Ib(k); Ic(k)];
  tmp_left  = [cos(theta(k)) cos(theta(k)-2*pi/3) cos(theta(k)+2*pi/3); -1*sin(theta(k)) -1*sin(theta(k)-2*pi/3) -1*sin(theta(k)+2*pi/3); 1/2 1/2 1/2;];
  tmp=2/3*tmp_left*tmp_right;
  Id(k)=tmp(1);
  Iq(k)=tmp(2);
  Io(k)=tmp(3);
end;


%Plot
figure(1);
plot(Ia); hold on; plot(Ib); hold on; plot(Ic); 

figure(2);
plot(theta);

figure(3);
plot(Id); hold on; plot(Iq); hold on; plot(Io);

