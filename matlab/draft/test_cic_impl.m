clc;
clear all;
close all;

%Parameters
nb_sample = 2^12*40;
fsamp_in = 50e6;

%CIC Parameters
M = 1;
R = 20;  % decimation or interpolation ratio
N = 5;  % number of stages
interp_decim= -1; %+1 interp and -1 decim

%Inits
t = (1/fsamp_in:1/fsamp_in:nb_sample/fsamp_in);
if interp_decim==1 fsamp_out = fsamp_in*R; end;
if interp_decim==-1 fsamp_out = fsamp_in/R; end;


%Test vector generation
##data_in = randn(1,nb_sample); %random data
data_in = sin(2*pi*fsamp_in/100.*t); %sin
##data_in = [zeros(1,nb_sample/2) ones(1,nb_sample/2)]; %step
##data_in =  (1:nb_sample);%ramp
##data_in = [(1:64) (1:64)]; data_in = repmat(data_in,1,8); data_in = data_in-32; %saw
##data_in = [zeros(1,64) ones(1,64)]; data_in = repmat(data_in,1,8);

if interp_decim==1
  
  %Cic implementation interpolation
  %Comb
  comb_d1 = 0;
  comb_reg = zeros(N,nb_sample);
  for v = 1 : N
    if v==1
      comb_in = data_in;
      printf('Comb %d of %d stages (first)\n',v,N);
      for k=1:length(comb_in)
        if k>1
          comb_out(k)=comb_in(k)-comb_d1;
        end
        comb_d1 = comb_in(k);
      end;
    else
      comb_in = comb_out;
      printf('Comb %d of %d stages\n',v,N);
      for k=1:length(comb_in)
        if k>2
          comb_out(k)=comb_in(k)-comb_d1;
        end
        comb_d1 = comb_in(k);
      end;
    end;
    comb_reg(v,1:length(comb_out))=comb_out;
  end;
  
end;

if interp_decim==-1
  %Cic implementation decimation
  %Integrator
  integ_reg = zeros(N,length(data_in));
  for v = 1 : N
    if v==1
      printf('Integrator %d of %d stages (first)\n',v,N);
      integrator_in = data_in;
      accu = 0;
      for k=2:length(integrator_in)
        integrator_out(k) = accu;
        accu = accu+integrator_in(k);
      end
     else
      printf('Integrator %d of %d stages\n',v,N);
      integrator_in = integrator_out;
      accu = 0;
      for k=1:length(integrator_in)
        integrator_out(k) = accu;
        accu = accu+integrator_in(k);
      end
    end
    integ_reg(v,1:length(integrator_out))=integrator_out;
  end
end

%Interpolation or decimation
if interp_decim==1
  resample_in = comb_out;
  resample_out = zeros(1,length(resample_in)*R);
  resample_out(1:R:end) = resample_in;
##  for k=1:length(resample_in)
##    resample_out((k-1)*R+1:(k-1)*R+1+R-1)=repmat(resample_in(k),R,1);
####    fprintf('%d %d \n',(k-1)*R+1, (k-1)*R+1+R-1);
##  end
end
if interp_decim==-1
  resample_in = integrator_out;
  resample_out = zeros(1,length(resample_in)/R);
  resample_out = resample_in(1:R:end);
end

if interp_decim==1
  %Cic Implementation interpolation
  %Integrator
  integ_reg = zeros(N,length(resample_out));
  for v = 1 : N
    if v==1
      printf('Integrator %d of %d stages (first)\n',v,N);
      integrator_in = resample_out;
      accu = 0;
      for k=2:length(integrator_in)
        integrator_out(k) = accu;
        accu = accu+integrator_in(k);
      end
     else
      printf('Integrator %d of %d stages\n',v,N);
      integrator_in = integrator_out;
      accu = 0;
      for k=1:length(integrator_in)
        integrator_out(k) = accu;
        accu = accu+integrator_in(k);
      end
    end
    integ_reg(v,1:length(integrator_out))=integrator_out;
  end
end;

if interp_decim==-1
  %Cic implementation decimation
  %Comb
  comb_d1 = 0;
  comb_reg = zeros(N,nb_sample);
  for v = 1 : N
    if v==1
      comb_in = resample_out;
      printf('Comb %d of %d stages (first)\n',v,N);
      for k=1:length(comb_in)
        if k>1
          comb_out(k)=comb_in(k)-comb_d1;
        end
        comb_d1 = comb_in(k);
      end;
    else
      comb_in = comb_out;
      printf('Comb %d of %d stages\n',v,N);
      for k=1:length(comb_in)
        if k>2
          comb_out(k)=comb_in(k)-comb_d1;
        end
        comb_d1 = comb_in(k);
      end;
    end;
    comb_reg(v,1:length(comb_out))=comb_out;
  end;
end;

if interp_decim==1
  data_out = integrator_out;
end;

if interp_decim==-1
  data_out = comb_out;
end; 


%FFT in
fft_in = 20 * log10(abs(fftshift(fft(data_in))));
x_axis_fft_in = (-fsamp_in/2:fsamp_in/nb_sample:fsamp_in/2-fsamp_in/nb_sample);

%FFT out
fft_out = 20 * log10(abs(fftshift(fft(data_out))));
if interp_decim==1 x_axis_fft_out = (-fsamp_out/2:fsamp_out/nb_sample/R:fsamp_out/2-fsamp_out/nb_sample/R); end
if interp_decim==-1 x_axis_fft_out = (-fsamp_out/2:fsamp_out/nb_sample*R:fsamp_out/2-fsamp_out/nb_sample*R); end

##%debug
##debug_plot=data_in;
##figure(1);
##plot(debug_plot);
##title('data in');
##
##debug_plot=comb_reg(1,:);
##figure(2);
##plot(debug_plot);
##title('comb reg 1');
##
##debug_plot=comb_reg(2,:);
##figure(3);
##plot(debug_plot);
##title('comb reg 2');
##
##debug_plot=resample_out;
##figure(4);
##plot(debug_plot);
##title('resample out');
##
##debug_plot=integ_reg(1,:);
##figure(5);
##plot(debug_plot);
##title('integ reg 1');
##
##debug_plot=integ_reg(2,:);
##figure(6);
##plot(debug_plot);
##title('integ reg 2');

%Plot signal
figure(1);
subplot (211);
plot(data_in);
title('data in');
subplot (212);
plot(data_out);
title('data out');

%Plot fft
figure(2);
subplot (211);
plot(x_axis_fft_in,fft_in);
title('cic input fft');
subplot (212);
plot(x_axis_fft_out,fft_out);
title('cic output fft');

