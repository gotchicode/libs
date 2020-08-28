##clc;
##clear all;
##close all;
##
##% Parameters
##bit_size=16;
##sequence_size= 2^12;
##
##%Init
##state_reg_in=zeros(1,31);
##state_reg_out=zeros(1,31);
##
##%Sequence
##y=1;
##data_store=[];
##while (y<5)
##  [data_out,state_reg_out] = rand_pn_31(bit_size,sequence_size,state_reg_in);
##  state_reg_in = state_reg_out;
##  data_store=[data_store data_out];
##  y=y+1;
##end
##
##
##%Plot
##plot(data_store,'+');
##
##mean_data_store=mean(data_store);
##var_data_store=sum(data_store.^2-mean(data_store))/length(data_store);
edges=linspace(-2^bit_size,2^bit_size,10000);
plot(edges,histc(data_store,edges));

