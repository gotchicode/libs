clc;
clear all;
close all;

%Parameters
nb_taps=63;

%Hilbert taps generation
taps = zeros(1,nb_taps);
for k=1:2:nb_taps
    taps(k) = 2/pi/k;
end;
taps_flip=flip(taps);
taps = [-1*taps_flip 0 taps];

##%Display response
##freqz(taps,1,512);

%Generate a test vectorize
nb_size=2^10;
fsamp=16;
fsig=1;
t=(1/fsamp:1/fsamp:nb_size/fsamp);
signal=sin(2*fsig*t);

%Filter the test vector
signal_filtered=conv(signal,taps);

%Plot
plot(signal);
hold on;
plot(signal_filtered);


