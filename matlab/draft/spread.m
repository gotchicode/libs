function data_out = spread(data_in,code)
  
CA_code=code;
data=data_in;

data_spread=zeros(1,length(CA_code)*length(data));
CA_code_sign=CA_code*2-1;
CA_code_sign_rep=repmat(CA_code_sign,1,length(data));
data_sign=data*2-1;
data_sign_ovr = zeros(1,length(data_sign)*length(CA_code));
for m=1:length(CA_code)
  data_sign_ovr(m:length(CA_code):end)=data_sign;
end
data_spread=data_sign_ovr.*CA_code_sign_rep;

data_out=data_spread;
  
end
