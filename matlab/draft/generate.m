clc;
clear all;
close all;

%Parameters
nb_taps = 20;
inter_factor = 8;

%Test if configuration is ok
ratio_test = nb_taps/inter_factor-floor(nb_taps/inter_factor)
if ratio_test==0
else
  fprintf("Error - It won't work because nb_taps/inter_factor not integer\n");
end


%Taps indexes of symetry
tab1 = [];
for k=-nb_taps/2:1:-1
  tab1 = [tab1 k];
end
tab1=abs(tab1);
for k=1:nb_taps/2
  tab1 = [tab1 k];
end

%Taps indexes
tab2 = [];
tab1=abs(tab1);
for k=1:nb_taps
  tab2 = [tab2 k-1];
end

%Fill index with samples
tab3=zeros(nb_taps,inter_factor);
for k=1:inter_factor
  y=1;
  for m=k:inter_factor:nb_taps
    tab3(m,k)=y;
    y=y+1;
  end
end

%Group in a table
table = [tab1; tab2; tab3.']'



