clc;
clear all;
close all;

%CIC Parameters
M = 1;
R = 2;  % decimation or interpolation ratio
N = 5;  % number of stages

%Fir params
nb_taps=51;

%Sampling Parameters
nb_points = 2^12*(8/R); %Depending on R, so final size is always 2^15
fsamp = 100e6;

%Specify the response
passband_freq=fsamp/R*0.5;
cut_off_freq=passband_freq/2;

%Run the cic compensation 
[x_fsamp,h_cic_resp_lin_norm,h_calc_fir_lin_unfold,h_cic_comp_resp_lin,h_cic_resp_log_norm,h_calc_fir_log_unfold,h_cic_comp_resp_log,max_h_cic_resp_lin,fir_taps]=cic_fir_compensated_calc(M,R,N,nb_taps,nb_points,fsamp,cut_off_freq);

%Find the -6dB point
position = find_minus_6dB(h_cic_comp_resp_lin);
min_6dB_freq=x_fsamp(position);
min_6dB_atten=h_cic_comp_resp_log(position);

%Find the passband at 0.2dB
position = find_minus_0_02dB(h_cic_comp_resp_lin);
min_0_02dB_freq=x_fsamp(position);
min_0_02dB_atten=h_cic_comp_resp_log(position);

%Plot result
fig=figure(1);
plot(x_fsamp,h_cic_resp_log_norm,'b');
hold on;
plot(x_fsamp,h_calc_fir_log_unfold,'g--');
hold on;
plot(x_fsamp,h_cic_comp_resp_log,'r');
axis([0 fsamp/2 -200 20])
x_vertical=fsamp/R/2;
plot([x_vertical,x_vertical],[-200,20],'--');
legend('cic','fir','cic + fir','low fsamp')
xlabel('Hz')
ylabel('dB')
hold on;
description=[' R=' num2str(R) ' N=' num2str(N) ' Cut Off Freq=' num2str((cut_off_freq/1e6)) ' MHz' ' Slow samp Freq=' num2str((fsamp/R/1e6)) ' MHz'  ' -6dB @' num2str(min_6dB_freq/1e6)];
title(description);

%Export image of cic
filename=['image_' 'R_' num2str(R) '_N_' num2str(N) '_cut_off_freq_' num2str(round(cut_off_freq)) '.bmp'];
saveas(fig,filename);

%Export image of taps
filename=['image_' 'R_' num2str(R) '_N_' num2str(N) '_cut_off_freq_' num2str(round(cut_off_freq)) '.txt'];
fid_fir=fopen(filename,'w');
for k=1:length(fir_taps)
    fprintf(fid_fir,'%f\n',fir_taps(k));
end;
fclose(fid_fir);


%Print a report to the main window
fprintf('\n');
fprintf('R=%d M=%d Fin=%d cut_off_freq=%d nb_taps=%d\nmin_6dB_freq=%d min_6dB_atten=%d \nmin_0_02dB_freq=%d min_0_02dB_atten=%d\n',R,M,fsamp/R,cut_off_freq,nb_taps,min_6dB_freq,min_6dB_atten,min_0_02dB_freq,min_0_02dB_atten);
fprintf('\n');


