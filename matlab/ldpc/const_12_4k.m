clear all;
close all;
clc;

%------------------------------------------
%-Build H matrix for 1/2 4K
%------------------------------------------

M=2048; %Defined in table R2

pi_k_const_1_2_4096_2048 =   [ 1 3 108 0 0 0;
                            2 0 126 375 219 312;
                            3 1 238 436 16 503;
                            4 2 481 350 263 388;
                            5 2 96 260 415 48;
                            6 3 28 84 403 7;
                            7 0 59 318 184 185;
                            8 1 225 382 279 328;];

%Static elements of Parity check matrix                        
zero_M = zeros(M,M);
Id_M = eye(M);

%------------------------------------------
%-Permutation matrix build
%------------------------------------------

%Parameters k
k=1;

%Init empty PI_k
PI_k=zeros(8,M);

for k=1:8
    for i=0:M-1
        teta_k = pi_k_const_1_2_4096_2048(k,2);
        phi_k = pi_k_const_1_2_4096_2048 ( k, 3+floor(4*i/M) );
        PI_k(k,i+1) = M/4*mod(teta_k + floor(4*i/M),4) + mod((phi_k+i),M/4);
        
        if k==1
          % teta_k %ok
          % floor(4*i/M) %ok
        end
    end
end


%Init the submat
PI_k_submat = zeros(M,M,8);

%Fill the submat
for k=1:8
    for i=0:M-1
        index = PI_k(k,i+1);
        PI_k_submat(i+1,index+1,k) = 1;
    end
end

##plot(PI_k(7,:));


H_submat_1_1 = zero_M;
H_submat_1_2 = zero_M;
H_submat_1_3 = Id_M;
H_submat_1_4 = zero_M;
H_submat_1_5 = mod(Id_M .+ PI_k_submat(:,:,1),2);

H_submat_2_1 = Id_M;
H_submat_2_2 = Id_M;
H_submat_2_3 = zero_M;
H_submat_2_4 = Id_M;
H_submat_2_5 = mod(PI_k_submat(:,:,2) .+ PI_k_submat(:,:,3) .+ PI_k_submat(:,:,4),2);

H_submat_3_1 = Id_M;
H_submat_3_2 = mod(PI_k_submat(:,:,5) .+ PI_k_submat(:,:,6),2);
H_submat_3_3 = zero_M;
H_submat_3_4 = mod(PI_k_submat(:,:,7) .+ PI_k_submat(:,:,8),2);
H_submat_3_5 = Id_M;

H1 =    [ H_submat_1_1 H_submat_1_2 H_submat_1_3 H_submat_1_4 H_submat_1_5];
      
H2 =   [H_submat_2_1 H_submat_2_2 H_submat_2_3 H_submat_2_4 H_submat_2_5;];
  
H3 =   [H_submat_3_1 H_submat_3_2 H_submat_3_3 H_submat_3_4 H_submat_3_5;];

      
H = [H1; H2; H3];
H_12_4k = H;
save H_12_4k.mat H_12_4k

##%Plot H matrix
##figure(1)
##for m=1:6144
##  tmp = (6144-m+1)*H(m,:);
##  plot(tmp,'.');
##  hold on;
##  fprintf('printing %d row\n',m);
##end
##fprintf('finished to print\n');


####%Print to a file
####print (1, "test.pdf", "-dpdflatexstandalone");
####fprintf('finished to print in file\n');
####close all;

