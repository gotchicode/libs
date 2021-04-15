function data_out =  my_fft(data_in,data_in_ptr,nb_size_max,nb_size,my_dft_init_table,my_fft_init_table)
  
  %fprintf('call %d size fft\n',nb_size);
  
  if length(data_in)>8
    
    %Indexes
    mid_index=length(data_in)/2;
    max_index=length(data_in);
    
    %Prepare data in
    even_data_in=data_in(1:2:end); %0, 2 ,4 ...
    odd_data_in=data_in(2:2:end);  %1, 3 ,5 ... 
    
    %Data ptr
    even_data_in_ptr=data_in_ptr(1:2:end);
    odd_data_in_ptr=data_in_ptr(2:2:end);
    
    %Debug
    fid = fopen('debug.txt','a');
    fprintf(fid,"data_in size=%d\n",length(data_in));
    fprintf(fid,"even_data_in size=%d even_data_in size=%d\n",length(even_data_in),length(odd_data_in));
    fclose(fid);
    
    %Prepare signs of butterfly
    sign_table=zeros(1,length(data_in));
    sign_table(1:length(sign_table)/2)=1;
    sign_table(length(sign_table)/2+1:end)=-1;
    
    %butterfly
    fft_init_table_extracted=get_fft_init_table(my_fft_init_table, nb_size_max, nb_size,0);
    tmp = (1:length(sign_table))-1;
    %gain_table = [cos(+2*pi/length(sign_table)*tmp)-j*sin(+2*pi/length(sign_table)*tmp)];
    gain_table=fft_init_table_extracted;
    gain_table = [gain_table(1:mid_index) gain_table(1:mid_index)];
    butterfly_factor = sign_table.*gain_table;
    
    %Debug
    fid = fopen('debug.txt','a');fprintf(fid,"Call recursive my 2 fft\n");fclose(fid);
    
    %Call dft
    even_data_out=my_fft(even_data_in,even_data_in_ptr,nb_size_max,mid_index,my_dft_init_table,my_fft_init_table);
    odd_data_out=my_fft(odd_data_in,odd_data_in_ptr,nb_size_max,mid_index,my_dft_init_table,my_fft_init_table);
    
    data_out(1:mid_index) = even_data_out + odd_data_out.*butterfly_factor(1:mid_index);
    data_out(mid_index+1:max_index) = even_data_out + odd_data_out.*butterfly_factor(mid_index+1:max_index);
    
    %fprintf("One butterfly done of %d\n",nb_size);
    
  elseif (length(data_in)==8)
    
    mid_index=length(data_in)/2;
    max_index=length(data_in);
    
    %Prepare data in
    even_data_in=data_in(1:2:end); %0, 2 ,4 ...
    odd_data_in=data_in(2:2:end);  %1, 3 ,5 ... 
    
    %Data ptr
    even_data_in_ptr=data_in_ptr(1:2:end);
    odd_data_in_ptr=data_in_ptr(2:2:end);

    %Debug
    fid = fopen('debug.txt','a');
    fprintf(fid,"data_in size=%d\n",length(data_in));
    fprintf(fid,"even_data_in size=%d even_data_in size=%d\n",length(even_data_in),length(odd_data_in));
    fclose(fid);

    %Debug
    fid = fopen('debug.txt','a');
      for ddbg=1:length(even_data_in_ptr)
        fprintf(fid,"%d ",even_data_in_ptr(ddbg));
      end
    fprintf(fid,"\n");
    fclose(fid);
    fid = fopen('debug.txt','a');
      for ddbg=1:length(even_data_in_ptr)
        fprintf(fid,"%d ",odd_data_in_ptr(ddbg));
      end
    fprintf(fid,"\n");
    fclose(fid);
    
    %Prepare signs of butterfly
    sign_table=zeros(1,length(data_in));
    sign_table(1:length(sign_table)/2)=1;
    sign_table(length(sign_table)/2+1:end)=-1;
    
    %butterfly
    tmp = (1:length(sign_table))-1;
    gain_table = [cos(+2*pi/length(sign_table)*tmp)-j*sin(+2*pi/length(sign_table)*tmp)];
    gain_table = [gain_table(1:mid_index) gain_table(1:mid_index)];
    butterfly_factor = sign_table.*gain_table;
    
    %Debug
    fid = fopen('debug.txt','a');fprintf(fid,"Call recursive my 2 dft\n");fclose(fid);
    
    %Call dft
    even_data_out=my_dft(even_data_in,mid_index,my_dft_init_table);
    odd_data_out=my_dft(odd_data_in,mid_index,my_dft_init_table);
    
    data_out(1:mid_index) = even_data_out + odd_data_out.*butterfly_factor(1:mid_index);
    data_out(mid_index+1:max_index) = even_data_out + odd_data_out.*butterfly_factor(mid_index+1:max_index);
    
    %fprintf("One butterfly done of %d\n",nb_size);
    
  else
    fprintf("Error in the size of the FFT\n");
  end
  
  
end