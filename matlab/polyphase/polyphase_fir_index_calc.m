clc;
clear all;
close all;


%Parameters
ntaps=45;
ratio=4;

%Create table index
table_index=(1:ntaps);

%Display selected index
for k=1:ratio
  table_index(1+k-1:ratio:end)
 end

