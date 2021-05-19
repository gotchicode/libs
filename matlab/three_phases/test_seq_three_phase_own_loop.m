clc;
clear all;
close all;

%Simu param
nb_size=2^13;

%Signal in Parameters
Fsamp=50*64;
Fsig=50*0.99;
Finternal=50;
Amp=1;

%Control loop Parameters
open_loop=0;
T=1;
Bn=0.005;
ksi=sqrt(2)/2;
A = (Bn*T/(ksi+1/4/ksi));
K1 = 4*ksi*A/(1+2*ksi*A+A^2);
K2 = 4*A^2/(1+2*ksi*A+A^2);

%Inits
iter=0;
t=0;
theta=0;
recovered_signal_theta=0;
taps = csvread('taps.txt')';
filter_srl = zeros(1,length(taps));
teta_control=0;
loop_add_prev=0;
loop_integ=0;
loop_out=0;
loop_inter=0;

%Debug signals init
debug_Va=zeros(1,nb_size);
debug_fir_out=zeros(1,nb_size);
debug_error_phase_filtered_angle=zeros(1,nb_size);

%-----------------------------------------------
% Loop
%-----------------------------------------------

while(iter<nb_size)

    %Iter incr
    iter = iter+1;

    %Time increment
    t=t+1/Fsamp;

    %Generate input signal
    Va = Amp * sin(2*pi*Fsig*t);
    
    %Generate a coarse complex translate signals
    Fcarrier = Finternal;
    Va_carrier = Amp * [ cos(2*pi*Fcarrier*t) + j*sin(2*pi*Fcarrier*t) ];
    
    %Perform the translation
    Va_translated = Va.*(-1*Va_carrier);
    
    %FIR of Va_translated
    filter_srl(2:end)=filter_srl(1:end-1);
    filter_srl(1)=Va_translated;
    fir_out = sum(filter_srl.*taps);
    
    %Generate a local phase
    f_teta = 0;
    theta = theta + teta_control;
    theta = mod(theta,2*pi);
    theta_mod_pi = mod(theta,pi);
    local_signal  = cos(theta)+j*sin(theta);
    local_signal_real = real(local_signal);
    
    %Generate a local phase
    recovered_signal_theta = recovered_signal_theta + 2*pi*Finternal/Fsamp+teta_control;
    recovered_signal = cos(recovered_signal_theta);
    
    %Correct
    error_phase=angle(fir_out.*(-1*local_signal));

    %Loop
    if iter>5000 %close the loop laps of iteration
      loop_in=error_phase;
    else
      loop_in=0;
    end;
    
    loop_inter1 = loop_in * K1;
    loop_inter2 = loop_in*K2 + loop_add_prev;
    loop_inter = loop_inter1 + loop_inter2;
    loop_add_prev = loop_add_prev+loop_in * K2;
    %loop_integ = loop_integ+loop_inter;
    loop_integ = loop_inter;
    loop_out = loop_integ;
    
    %Loop out apply
    teta_control = -1*loop_out;

    %Debug signal create
    debug_Va(iter)=Va;
    debug_fir_out(iter)=fir_out;
    debug_error_phase(iter)=error_phase;
    debug_theta(iter)=theta; 
    debug_local_signal_real(iter)=local_signal_real;
    debug_theta_mod_pi(iter)=theta_mod_pi;
    debug_loop_out(iter)=loop_out;
    debug_recovered_signal(iter)=recovered_signal;
end

figure(1)
hold on;
plot(debug_Va);
plot(debug_theta_mod_pi);
plot(debug_error_phase);
plot(debug_loop_out);
plot(debug_recovered_signal);
legend('debug Va','debug theta mod pi','debug error phase','debug loop out','debug recovered signal');


