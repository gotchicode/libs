clc;
clear all;
close all;

n=10;
quant = 2^15; %Quantizations of values

result_cordic=[];
result_real=[];

for k=1:359
  input_degres = k;
  input_rad = input_degres/360*2*pi;
  input_rad = round((quant-1) * input_rad / 2 / pi);
  [x_out,y_out] = cordic_cos_sin(input_rad,n,0,quant);
  result_cordic=[result_cordic; input_degres x_out y_out];
  result_real=[result_real; input_degres cos(input_degres/360*2*pi) sin(input_degres/360*2*pi)];
end


figure(1);
x_axis=result_cordic(:,1);
y_axis_from_cordic=result_cordic(:,2);
y_axis_from_real=result_real(:,2);
plot(x_axis,y_axis_from_cordic);
xlabel ("degres");
ylabel ("cosine");
title ("cordic vs real cos(x)");

