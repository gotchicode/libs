function data_out = my_dft_init(nb_size)

fft_mat=zeros(nb_size,nb_size);
for k=0:nb_size-1
  for n=0:nb_size-1
    tmp = [cos(2*pi/nb_size*k*n)-j*sin(2*pi/nb_size*k*n)];
    fft_mat(n+1,k+1)=tmp;
  end
end

data_out = fft_mat;

end



