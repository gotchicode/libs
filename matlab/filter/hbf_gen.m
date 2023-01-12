clc;
clear all;
close all;

%Section just under below is from https://www.dsprelated.com/showarticle/1113.php
ntaps= 39; %Has to be odd
N= ntaps-1;
n= -N/2:N/2;
sinc= sin(n*pi/2)./(n*pi+eps);      % truncated impulse response; eps= 2E-16
sinc(N/2 +1)= 1/2;                  % value for n --> 0
win= kaiser(ntaps,6);               % window function
b= sinc.*win';
taps = b;

%Get the fain
taps_gain = sum(taps);

%Normalize to 1
taps=taps/taps_gain;

%Frequency response
h_taps = 20*log10(abs(freqz(taps,1,512)));

%Figure 1
figure(1);
x_axis = linspace(0,0.5,512);
plot(x_axis,h_taps);
grid on;
xlabel('Normalized frequency')
ylabel('dB')
legend('Ideal taps')

%Print taps to a textfile
fp = fopen('taps.txt', 'w');
for k=1:ntaps
 fprintf(fp, "%f\n", taps(k));
end;
fclose(fp);