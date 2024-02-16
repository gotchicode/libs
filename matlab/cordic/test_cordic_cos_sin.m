clc;
clear all;
close all;

n=25;

result_cordic=[];
result_real=[];

for k=1:359
  input_degres = k;
  input_rad = input_degres/360*2*pi;
  [x_out,y_out] = cordic_cos_sin(input_rad,n,0,1);
  result_cordic=[result_cordic; input_degres x_out y_out];
  result_real=[result_real; input_degres cos(input_degres/360*2*pi) sin(input_degres/360*2*pi)];
end


figure(1);
x_axis=result_cordic(:,1);
y_axis_from_cordic=result_cordic(:,2);
y_axis_from_real=result_real(:,2);
plot(x_axis,y_axis_from_cordic);
hold on;
plot(x_axis,y_axis_from_real);
xlabel ("degres");
ylabel ("cosine");
title ("cordic vs real cos(x)");

figure(2);
x_axis=result_cordic(:,1);
y_axis_from_cordic=result_cordic(:,3);
y_axis_from_real=result_real(:,3);
plot(x_axis,y_axis_from_cordic);
hold on;
plot(x_axis,y_axis_from_real);
xlabel ("degres");
ylabel ("sine");
title ("cordic vs real sin(x)");

figure(3);
x_axis=result_cordic(:,1);
error_cos = 20*log10((result_cordic(:,2) ./ result_real(:,2)));
error_sin = 20*log10((result_cordic(:,3) ./ result_real(:,3)));
plot(x_axis,error_cos);
hold on;
plot(x_axis,error_sin);
xlabel ("degres");
ylabel ("cos and sine dB");
title ("20*log10(cordic/real)");