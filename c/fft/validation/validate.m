clc;
clear all;
close all;

%parameters
filename_data_in_re = '../prj/data_in_re.txt';
filename_data_in_im = '../prj/data_in_im.txt';
filename_data_out_re = '../prj/data_out_re.txt';
filename_data_out_im = '../prj/data_out_im.txt';

%initialization
fig=1;

%load input
data_in = csvread(filename_data_in_re)'+i*csvread(filename_data_in_im)';

%fft
data_out = fft(data_in);

%prepare analysis
data_out_re = real(data_out);
data_out_im = imag(data_out);
data_out_re_from_c=csvread(filename_data_out_re)';
data_out_im_from_c=csvread(filename_data_out_im)';

error_re=data_out_re-data_out_re_from_c;
error_im=data_out_im-data_out_im_from_c;

ratio_re=data_out_re/data_out_re_from_c;
ratio_im=data_out_im/data_out_im_from_c;

%plot real outputs
figure(fig);fig=fig+1;
plot(data_out_re);
hold on;
plot(data_out_re_from_c);
title('real outputs');

%plot imag outputs
figure(fig);fig=fig+1;
plot(data_out_im);
hold on;
plot(data_out_im_from_c);
title('imag outputs');

%plot error_re
figure(fig);fig=fig+1;
plot(error_re);
title('error re');

%plot error_im
figure(fig);fig=fig+1;
plot(error_im);
title('error im');

##%plot ratio_re
##figure(fig);fig=fig+1;
##plot(ratio_re);
##title('ratio re');
##
##%plot ratio_im
##figure(fig);fig=fig+1;
##plot(ratio_re);
##title('ratio im');

