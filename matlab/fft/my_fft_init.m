function data_out = my_fft_init(nb_size,debug)



%Calculate the needed space inside a table and find each start address
space_needed=0;
k=nb_size;
while(k>4)
  if debug==1 fprintf('fft_size=%d\tstart address=%d\n',k,space_needed); end;
  space_needed=space_needed+k;
  k=k/2;
end;

%Fill with values
space_needed=0;
k=nb_size;
my_fft_trigo_table=zeros(1,space_needed);
while(k>4)
  %%Here add a loop to fill with values
  tmp = (1:k)-1;
  tmp_table=[cos(+2*pi/k*tmp)-j*sin(+2*pi/k*tmp)];
  my_fft_trigo_table(space_needed+1:space_needed+1+k-1)=tmp_table;
  space_needed=space_needed+k;
  k=k/2;
end;

data_out=my_fft_trigo_table;

end



