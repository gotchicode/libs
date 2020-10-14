

function data_out = CA_code_gen(phase_select1,phase_select2)
  
%G1 generation
g1_sr=ones(1,10);
g1=zeros(1,1023);
for k=1:1023
  g1(k)=g1_sr(10);
  g1_sr_save=g1_sr(1);
  g1_sr(1)=xor(g1_sr(3),g1_sr(10));
  g1_sr(2:10)=[g1_sr_save g1_sr(2:9)];
end

%G2 generation
g2_sr=ones(1,10);
g2=zeros(1,1023);
for k=1:1023
  g2(k)=xor(g2_sr(phase_select1),g2_sr(phase_select2));
  g2_sr_save=g2_sr(1);
  g2_sr(1)=xor(g2_sr(10),xor(g2_sr(9),xor(g2_sr(8),xor(g2_sr(6),xor(g2_sr(3),g2_sr(2))))));
  g2_sr(2:10)=[g2_sr_save g2_sr(2:9)];
end;

%CA code generation
CA_code=xor(g1,g2);

##Debug line
##CA_code(1:16)
  
data_out=CA_code;
  
end
