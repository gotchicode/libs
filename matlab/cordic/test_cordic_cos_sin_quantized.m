clc;
clear all;
close all;

n=15;
quant = 2^16; %Quantizations of values
debug=0;

result_cordic=[];
result_real=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is a version working in degres steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

##for k=1:360
##  input_degres = k;
##  input_rad = input_degres/360*2*pi;
##  input_rad = round((quant-1) * input_rad / 2 / pi);
##  [x_out,y_out] = cordic_cos_sin(input_rad,n,debug,quant);
##  result_cordic=[result_cordic; input_degres x_out y_out];
##  result_real=[result_real; input_degres cos(input_degres/360*2*pi) sin(input_degres/360*2*pi)];
##end
##
##
##figure(1);
##x_axis=result_cordic(:,1);
##y_axis_from_cordic=result_cordic(:,2);
##y_axis_from_real=result_real(:,2);
##plot(x_axis,y_axis_from_cordic);
##xlabel ("degres");
##ylabel ("cosine");
##title ("cordic vs real cos(x)");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is a version working in quantified steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:quant-1
  [x_out,y_out] = cordic_cos_sin(k,n,debug,quant);
  input_degres = k*360/quant;
  result_cordic=[result_cordic; k x_out y_out];
  result_real=[result_real; input_degres cos(input_degres/360*2*pi) sin(input_degres/360*2*pi)];
end

result_cordic_back_to_real=result_cordic(:,2)/quant;
result_real_in_cordic_scale=round(result_real(:,2)*quant);

figure(1);
x_axis=result_cordic(:,1);
y_axis_from_cordic=result_cordic(:,2);
y_axis_from_real=result_real(:,2);
plot(x_axis,y_axis_from_cordic,'.');
xlabel ("degres");
ylabel ("cosine");
title ("cordic cos(x)");

figure(2);
x_axis=result_cordic(:,1);
plot(x_axis,result_cordic_back_to_real,'.');
hold on;
plot(x_axis,y_axis_from_real);
xlabel ("degres");
ylabel ("cosine");
title ("cordic real vs cos diplayed in real (x)");

error_real_scale = result_cordic_back_to_real./y_axis_from_real;
error_real_scale(quant/4)=1;
error_real_scale(quant/4*3)=1;

figure(3);
x_axis=result_cordic(:,1);
plot(x_axis,error_real_scale);
xlabel ("degres");
ylabel ("cosine");
title ("error cos x displayed in real");

error_cordic_scale=y_axis_from_cordic-result_real_in_cordic_scale;

figure(4);
x_axis=result_cordic(:,1);
plot(x_axis,y_axis_from_cordic);
hold on;
plot(x_axis,result_real_in_cordic_scale);
xlabel ("degres");
ylabel ("cosine");
title ("real cos x displayed in cordic scale");


figure(5);
x_axis=result_cordic(:,1);
plot(x_axis,error_cordic_scale);
xlabel ("degres");
ylabel ("cosine");
title ("error in cordic scale");


