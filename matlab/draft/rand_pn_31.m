
function [data_out,state_reg_out] = rand_pn_31(bit_size,sequence_size,state_reg_in)
  
% Parameters
m=bit_size;
nb_bits = sequence_size*bit_size;

%Persistant registers
in_enc_shift_reg = state_reg_in;

%In generation
in_enc_table = zeros(1,nb_bits)+1;
out_enc_table = zeros(1,nb_bits)+1;

%Scrambler
[out_enc_table,out_enc_shift_reg] = pn_31_enc_1b(in_enc_table, in_enc_shift_reg);

%Reshape
n=length(out_enc_table)/m;
out_enc_table_reshaped=reshape(out_enc_table,m,n);

%Table to signed
size_in=size(out_enc_table_reshaped);
data_in=out_enc_table_reshaped;
vect=2.^(0:m-1);
data_out=zeros(1,size_in(2));
for k=1:size_in(2)
  tmp = data_in(:,k);
  data_out(k)=vect*tmp;
end
%to signed
for k=1:length(data_out)
  if data_out(k)<(2^(m-1))
    data_out(k) = data_out(k);
  else
    data_out(k) = -((2^m)-data_out(k)+1);
  end
end

state_reg_out=out_enc_shift_reg;
  
end
