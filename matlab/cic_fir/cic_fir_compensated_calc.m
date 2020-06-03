
function [x_fsamp,h_cic_resp_lin_norm,h_calc_fir_lin_unfold,h_cic_comp_resp_lin,h_cic_resp_log_norm,h_calc_fir_log_unfold,h_cic_comp_resp_log,max_h_cic_resp_lin]=cic_fir_compensated_calc(M,R,N,nb_taps,nb_points,fsamp,cut_off_freq);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CIC response
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute axis
x_fsamp=(0:fsamp/nb_points/R/2:fsamp/2-fsamp/nb_points/R/2);
f_norm_axis=(0:1/nb_points/R/2:1/2-1/nb_points/R/2);
f=f_norm_axis;

%Compute response
h_cic_resp_lin=abs(sin(pi*f*R)./sin(pi.*f)).^N;
h_cic_resp_log = 20*log10(h_cic_resp_lin);

%Find max
max_h_cic_resp_lin=max(h_cic_resp_lin);
max_h_cic_resp_log2 = log2(max_h_cic_resp_lin);

%Normalize
h_cic_resp_lin_norm=h_cic_resp_lin/max_h_cic_resp_lin;
h_cic_resp_log_norm=20*log10(h_cic_resp_lin_norm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIR compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the wanted reponse
cut_off_freq_point = round(cut_off_freq/(fsamp/R)*nb_points*2);
h_wanted_resp_lin=[ones(1,cut_off_freq_point) ones(1,nb_points-cut_off_freq_point)/1000];

%Calculate the wanted response and its axis
h_comp_fir=h_wanted_resp_lin./h_cic_resp_lin_norm(1:nb_points);
x_comp_fir_norm = (0:1/(nb_points-1):1);
b = fir2(nb_taps,x_comp_fir_norm,h_comp_fir);

h_calc_fir=freqz(b,1,nb_points).';
h_calc_fir_lin=abs(h_calc_fir);

%%Unfold
h_calc_fir_lin_unfold = unfold(h_calc_fir_lin,R,nb_points);
h_calc_fir_log_unfold = 20*log10(h_calc_fir_lin_unfold);

%Multiply compensating fir with CIC response
h_cic_comp_resp_lin = h_calc_fir_lin_unfold.*h_cic_resp_lin_norm;
h_cic_comp_resp_log = 20*log10(h_cic_comp_resp_lin);

end


