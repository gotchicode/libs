function data_out=get_fft_init_table(data_in, nb_size, select_size,debug)
  
%%Get part of the table for a given size
space_needed=0;
k=nb_size;
while(k>4)
  if debug==1 fprintf('fft_size=%d\tstart address=%d\n',k,space_needed,debug); end;
  if select_size==k
    if debug==1 fprintf('parameters catched here => fft_size=%d\tstart address=%d\n',k,space_needed); end;
    base_addr = space_needed;
    end_addr = space_needed+select_size-1;
  end
  space_needed=space_needed+k;
  k=k/2;
end;

if debug==1 fprintf('base_addr=%d\t end_addr=%d diff=%d\n',base_addr,end_addr,end_addr-base_addr+1); end;
data_out = data_in(base_addr+1:end_addr+1);

end
