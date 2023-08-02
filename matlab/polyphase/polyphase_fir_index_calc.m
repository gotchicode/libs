clc;
clear all;
close all;


%Parameters
ratio=128;
ntaps=8;
ntaps=ntaps*ratio+1;


%Create table index
table_index=(1:ntaps);

%Display selected index
for k=1:ratio
  table_index(1+k-1:ratio:end)
 end

