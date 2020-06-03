clc;
clear all;
close all;

%CIC Parameters
M = 1;
R = 16;  % decimation or interpolation ratio
N = 5;  % number of stages

%Fir params
nb_taps=50;

%Sampling Parameters
nb_points = 2^12;
fsamp = 100e6;

%Specify the response
passband_freq=fsamp/R*0.5;
cut_off_freq=passband_freq/2;

[x_fsamp,h_cic_resp_lin_norm,h_calc_fir_lin_unfold,h_cic_comp_resp_lin,h_cic_resp_log_norm,h_calc_fir_log_unfold,h_cic_comp_resp_log,max_h_cic_resp_lin]=cic_fir_compensated_calc(M,R,N,nb_taps,nb_points,fsamp,cut_off_freq);

%Find the -6dB point
position = find_minus_6dB(h_cic_comp_resp_lin);
min_6dB_freq=x_fsamp(position);
min_6dB_atten=h_cic_comp_resp_log(position);

figure(1)
plot(x_fsamp,h_cic_resp_log_norm,'b');
hold on;
plot(x_fsamp,h_calc_fir_log_unfold,'g--');
hold on;
plot(x_fsamp,h_cic_comp_resp_log,'r');
legend('cic','fir','cic + fir')
axis([0 fsamp/2 -400 50])
xlabel('Hz')
ylabel('dB')
hold on;


