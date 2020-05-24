function test_dft_out =  my_dft(test_in,nb_size)

%% This is a loop version

##test_dft_out = zeros(1,nb_size);
##for k=0:nb_size-1
##  accu=0;
##  for n=0:nb_size-1
##    tmp = [cos(2*pi/nb_size*k*n)-j*sin(2*pi/nb_size*k*n)];
##    accu_tmp=test_in(n+1)*tmp;
##    accu = accu+accu_tmp;
##  end;
##  test_dft_out(k+1)=accu;
##end;

%This is the matrix version
test_dft_out = zeros(1,nb_size);

fft_mat=zeros(nb_size,nb_size);
for k=0:nb_size-1
  for n=0:nb_size-1
    tmp = [cos(2*pi/nb_size*k*n)-j*sin(2*pi/nb_size*k*n)];
    fft_mat(n+1,k+1)=tmp;
  end
end

fprintf("One dft done\n");

test_dft_out = test_in*fft_mat;