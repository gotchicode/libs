clc;
clear all;
close all;

nb_bit=18

f = [0, 0.48,  0.5,  0.52,  0.7,  1]; 
m = [1, 1,    0.5,    0,  0,    0];
taps = fir2 (100, f, m);
taps_quant=round(taps*2^(nb_bit-1)-1);
[h, w] = freqz (taps);
[h_quant, w] = freqz (taps_quant);
h_log = 20*log10(abs(h));
h_quant_log = 20*log10(abs(h_quant));
m_log = 20*log10(abs(m));
plot (f, m_log, ";target response;");
hold on;
plot (w/pi, h_log, ";ideal filter response;");
hold on;
plot (w/pi, h_quant_log-max(h_quant_log), ";quant filter response;");