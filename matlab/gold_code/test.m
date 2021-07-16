clc;
clear all;
close all;

%Parameters
n=10;
N=2^n-1;
m1=[10 9 7 6 4 1];
m2=[10 9 8 7 6 5 4 3];

%Init
register1=zeros(1,n);
register2=zeros(1,n);

%Build branches
branches1=zeros(1,n);
for k=1:length(m1)
  branches1(m1(k))=1;
end
branches2=zeros(1,n);
for k=1:length(m2)
  branches2(m2(k))=1;
end

for k=1:N
  