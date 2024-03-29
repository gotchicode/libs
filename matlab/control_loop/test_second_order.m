clc;
clear all;
close all;

%option
optionu=2;

%Simu param
nb_size=2^13;

%Parameters
T=1;
Bn=0.001;
ksi=sqrt(2)/2;
use_integ=1;

%Intermediate parameters
A = (Bn*T/(ksi+1/4/ksi));
K1 = 4*ksi*A/(1+2*ksi*A+A^2);
K2 = 4*A^2/(1+2*ksi*A+A^2);

%Loop input stim
data_in = [zeros(1,nb_size/2) ones(1,nb_size/2)]; %A step
%data_in = (0:nb_size)*1; %Ramp
##data_in = sin(2*pi*1/10000*(0:nb_size));

%First option, implemented in the code
if optionu==1
  %Initialization
  add_prev=0;
  loop_integ=0;
  loop_out=0;
  error_saved=[];
  loop_out_saved = [];
  loop_inter=0;
  for k=1:length(data_in)
      error_saved=[error_saved data_in(k)-loop_out];
      loop_out_saved = [loop_out_saved loop_out];
      loop_in=data_in(k)-loop_out;
      loop_inter1 = loop_in * K1;
      loop_inter2 = loop_in*K2 + add_prev;
      loop_inter = loop_inter1 + loop_inter2;
      add_prev = add_prev+loop_in * K2;
      loop_integ = loop_integ+loop_inter;
      loop_out = loop_integ;
  end
end



%Second option, implemented throught a function
if optionu==2
  %Initialization
  add_prev_out=0;
  loop_integ_out=0;
  loop_out=0;
  error_saved=[];
  loop_out_saved = [];
  loop_inter=0;
  for k=1:length(data_in);
    loop_in=data_in(k)-loop_out;
    add_prev_in = add_prev_out;
    loop_integ_in = loop_integ_out;
    [loop_out, add_prev_out, loop_integ_out] = loop_filter_2nd_order(loop_in, T, Bn, ksi, add_prev_in, loop_integ_in, use_integ);
    error_saved=[error_saved data_in(k)-loop_out];
    loop_out_saved = [loop_out_saved loop_out];
  end
end

  
figure(1);
plot(data_in);
hold on;
plot(loop_out_saved);
figure(2);
plot(error_saved);
