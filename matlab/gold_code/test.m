clc;
clear all;
close all;

%Parameters

##n=5;
##N=(2^n-1) * 10;
##m1=[5 4 3 2];
##m2=[5 2];

##n=10;
##N=(2^n-1) * 10;
##m1=[10 9 7 6 4 1];
##m2=[10 9 8 7 6 5 4 3];

n=11;
N=(2^n-1) * 10;
m1=[11 8 5 2];
m2=[11 2];

%Init
register1=ones(1,n);
register2=ones(1,n);

%Build branches
branches1=zeros(1,n);
for k=1:length(m1)
  branches1(m1(k))=1;
end
branches2=zeros(1,n);
for k=1:length(m2)
  branches2(m2(k))=1;
end

%Output table
data_out = zeros(1,N);

for k=1:N

  tmp = register1 .*  branches1;
  tmp = sum(tmp);
  tmp = mod(tmp,2);
  register1(1:n-1) = register1(2:n);
  register1(n) = tmp;
  
  tmp = register2 .*  branches2;
  tmp = sum(tmp);
  tmp = mod(tmp,2);
  register2(1:n-1) = register2(2:n);
  register2(n) = tmp;
  
  tmp_out = mod(register1(1) + register2(1),2);
  data_out(k) = tmp_out;

end

%Check autocorrelation
cross_in1= [data_out data_out data_out data_out];
cross_in2= data_out;
crossresult = abs(conv(cross_in1,cross_in2));

%Print to a file 
fid = fopen("data_out.txt",'w');
for k=1:length(data_out)
  fprintf(fid,"%d\n",data_out(k));
end;
fclose(fid);