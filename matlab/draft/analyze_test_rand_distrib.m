clc;
clear all;
close all;

%Load the matrix
load 'test.mat';

%Plot the distribution
plot(data_test_occurence);

%Compute the mean
accu_mean=0;
total_occurence=0;
for k=1:length(data_test_occurence)
  accu_mean=accu_mean+k*data_test_occurence(k);
  total_occurence=total_occurence+data_test_occurence(k);
end
computed_mean=accu_mean/total_occurence;

%Compute variance
accu_variance=0;
for k=1:length(data_test_occurence)
  accu_variance = accu_variance+((k-computed_mean)^2)*k;
end
computed_variance=accu_variance/total_occurence;

%Display
fprintf('mean=%f\n',computed_mean);
fprintf('variance=%f\n',computed_variance);

