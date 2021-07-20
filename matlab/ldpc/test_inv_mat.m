clc;
clear all;
close all;

%gen text mat
test_matrix = round(rand(3,3));

%round mat
test_matrix_inv = inv(test_matrix);
text_matrix_det = det(test_matrix);