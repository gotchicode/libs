
clc;
clear all;
close all;

data_in = [1900 2000 -1996 -1896 ]
data_cnt = 2;

quant_factor=2^32;

mu_tmp=4/8;
if quant_factor==1
else
  mu_tmp=round(mu_tmp*quant_factor);
end;

mu_bis_tmp = mu_tmp * mu_tmp;
y0=data_in(data_cnt-1);
y1=data_in(data_cnt);
y2=data_in(data_cnt+1);
y3=data_in(data_cnt+2);
a0=y3-y2-y0+y1;
a1=y0-y1-a0;
a2=y2-y0;
a3=y1;
a0_mult_term = a0*mu_tmp*mu_bis_tmp; %mu - 2^32 x 2^32 x 2^32
a1_mult_term = a1*mu_bis_tmp*quant_factor; %mu - 2^32 x 2^32 x quant_factor
a2_mult_term = a2*mu_tmp*quant_factor*quant_factor; %mu - 2^32 x quant_factor x quant_factor
a3_mult_term = a3*quant_factor*quant_factor*quant_factor; % x quant_factor x quant_factor x quant_factor

a0_mult_term_plus_a1_mult_term = a0_mult_term+a1_mult_term;
a2_mult_term_plus_a3_mult_term = a2_mult_term+a3_mult_term;

tmp = a0_mult_term_plus_a1_mult_term+a2_mult_term_plus_a3_mult_term;
if quant_factor==1
  else
    tmp = round(tmp/quant_factor/quant_factor/quant_factor);
end;

buffer_out= tmp