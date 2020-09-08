clc;
clear all;
close all;

%Init and param
modu='1024-QAM';
nb_size=2^10;
nb_bit=log2(nb_size);
test_mode = 1;

if test_mode==0
  data_in=round(rand(1,nb_size));
end

if test_mode==1
  %Build the constellation of all possible inputs
  data_in=[];
  data=(0:nb_size-1);
  for k=1:nb_size
    tmp = data(k);
    tmp = decimal_to_unsigned_bit_table(tmp,nb_bit);
    data_in=[data_in tmp];
  end
end

if test_mode==2
  data_in=[1 0 0 1];
end;

%Modulate
data_modulated=mapper(data_in,modu);

%Demodulate
data_out=demapper(data_modulated,modu);

%Calculate difference between in and output_max_field_width
error=sum(data_in-data_out);

##%Display
##filename=[modu '.jpg'];
figure(1);
plot(data_modulated,'+');
##saveas (1, filename);