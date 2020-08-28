clc;
clear all;
close all;

%Parameters
nb_size = 2^16;
scale = 2^12;

%Generate a random test vector
data_test = randn(1,nb_size);
max_data_test=max(abs(data_test));
data_test=data_test*((scale/2-1)/max_data_test);

%Analyze
data_test_mean=mean(data_test);
data_test_var=mean((data_test-data_test_mean).^2);


%Display
fprintf('max=%f\n',max(data_test));
fprintf('min=%f\n',min(data_test));
fprintf('mean=%f\n',data_test_mean);
fprintf('variance=%f\n',data_test_var);