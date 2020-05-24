function data_out =  my_fft(data_in,nb_size)
  
  if length(data_in)>8
    
    %Indexes
    mid_index=length(data_in)/2;
    max_index=length(data_in);
    
    %Prepare data in
    even_data_in=data_in(1:2:end); %0, 2 ,4 ...
    odd_data_in=data_in(2:2:end);  %1, 3 ,5 ... 
    
    %Prepare signs of butterfly
    sign_table=zeros(1,length(data_in));
    sign_table(1:length(sign_table)/2)=1;
    sign_table(length(sign_table)/2+1:end)=-1;
    
    %butterfly
    tmp = (1:length(sign_table))-1;
    gain_table = [cos(+2*pi/length(sign_table)*tmp)-j*sin(+2*pi/length(sign_table)*tmp)];
    gain_table = [gain_table(1:mid_index) gain_table(1:mid_index)];
    butterfly_factor = sign_table.*gain_table;
    
    %Call dft
    even_data_out=my_fft(even_data_in,mid_index);
    odd_data_out=my_fft(odd_data_in,mid_index);
    
    data_out(1:mid_index) = even_data_out + odd_data_out.*butterfly_factor(1:mid_index);
    data_out(mid_index+1:max_index) = even_data_out + odd_data_out.*butterfly_factor(mid_index+1:max_index);
    
    fprintf("One butterfly done of %d\n",nb_size);
    
  elseif (length(data_in)==8)
    
    mid_index=length(data_in)/2;
    max_index=length(data_in);
    
    %Prepare data in
    even_data_in=data_in(1:2:end); %0, 2 ,4 ...
    odd_data_in=data_in(2:2:end);  %1, 3 ,5 ... 
    
    %Prepare signs of butterfly
    sign_table=zeros(1,length(data_in));
    sign_table(1:length(sign_table)/2)=1;
    sign_table(length(sign_table)/2+1:end)=-1;
    
    %butterfly
    tmp = (1:length(sign_table))-1;
    gain_table = [cos(+2*pi/length(sign_table)*tmp)-j*sin(+2*pi/length(sign_table)*tmp)];
    gain_table = [gain_table(1:mid_index) gain_table(1:mid_index)];
    butterfly_factor = sign_table.*gain_table;
    
    %Call dft
    even_data_out=my_dft(even_data_in,mid_index);
    odd_data_out=my_dft(odd_data_in,mid_index);
    
    data_out(1:mid_index) = even_data_out + odd_data_out.*butterfly_factor(1:mid_index);
    data_out(mid_index+1:max_index) = even_data_out + odd_data_out.*butterfly_factor(mid_index+1:max_index);
    
    fprintf("One butterfly done of %d\n",nb_size);
    
  else
    fprintf("Error in the size of the FFT\n");
  end
  
  
end