clear all;
close all;
clc;

%------------------------------------------
%-Build H matrix for 2/3 1K
%------------------------------------------

M=1024; %Defined in table R2

pi_k_const_2_3_4096_1024 =      [1 3 160 0 0 0;
                                2 0 241 182 35 162;
                                3 1 185 249 167 7;
                                4 2 251 65 214 31;
                                5 2 209 70 84 164;
                                6 3 103 141 206 11;
                                7 0 90 237 122 237;
                                8 1 184 77 67 125;
                                9 0 248 55 147 133;
                                10 1 12 12 54 99;
                                11 2 111 227 23 105;
                                12 0 66 42 93 17;
                                13 2 173 52 20 97;
                                14 3 42 243 197 91];


%Static elements of Parity check matrix                        
zero_M = zeros(M,M);
Id_M = eye(M);

%------------------------------------------
%-Permutation matrix build
%------------------------------------------

%Parameters k
k=1;

%Init empty PI_k
PI_k=zeros(14,M);

for k=1:14
    for i=0:M-1
        teta_k = pi_k_const_2_3_4096_1024(k,2);
        phi_k = pi_k_const_2_3_4096_1024 ( k, 3+floor(4*i/M) );
        PI_k(k,i+1) = M/4*mod(teta_k + floor(4*i/M),4) + mod((phi_k+i),M/4);
        
        if k==1
          % teta_k %ok
          % floor(4*i/M) %ok
        end
    end
end


%Init the submat
PI_k_submat = zeros(M,M,14);

%Fill the submat
for k=1:14
    for i=0:M-1
        index = PI_k(k,i+1);
        PI_k_submat(i+1,index+1,k) = 1;
    end
end

##plot(PI_k(7,:));


H_submat_1_1 = zero_M;
H_submat_1_2 = zero_M;
H_submat_1_3 = zero_M;
H_submat_1_4 = zero_M;
H_submat_1_5 = Id_M;
H_submat_1_6 = zero_M;
H_submat_1_7 = mod(Id_M .+ PI_k_submat(:,:,1),2);

H_submat_2_1 =  mod(PI_k_submat(:,:,9) .+ PI_k_submat(:,:,10) .+ PI_k_submat(:,:,11),2);
H_submat_2_2 = Id_M;
H_submat_2_3 = Id_M;
H_submat_2_4 = Id_M;
H_submat_2_5 = zero_M;
H_submat_2_6 = Id_M;
H_submat_2_7 = mod(PI_k_submat(:,:,2) .+ PI_k_submat(:,:,3) .+ PI_k_submat(:,:,4),2);

H_submat_3_1 = Id_M;
H_submat_3_2 = mod(PI_k_submat(:,:,12) .+ PI_k_submat(:,:,13) .+ PI_k_submat(:,:,14),2);
H_submat_3_3 = Id_M;
H_submat_3_4 = mod(PI_k_submat(:,:,5) .+ PI_k_submat(:,:,6),2);
H_submat_3_5 = zero_M;
H_submat_3_6 = mod(PI_k_submat(:,:,7) .+ PI_k_submat(:,:,8),2);
H_submat_3_7 = Id_M;

H1 =    [ H_submat_1_1 H_submat_1_2 H_submat_1_3 H_submat_1_4 H_submat_1_5 H_submat_1_6 H_submat_1_7];
      
H2 =   [H_submat_2_1 H_submat_2_2 H_submat_2_3 H_submat_2_4 H_submat_2_5 H_submat_2_6 H_submat_2_7];
  
H3 =   [H_submat_3_1 H_submat_3_2 H_submat_3_3 H_submat_3_4 H_submat_3_5 H_submat_3_6 H_submat_3_7];

      
H = [H1; H2; H3];
H_23_4k = H;
save H_23_4k.mat H_23_4k

##%Plot H matrix
##figure(1)
##for m=1:3072
##  tmp = (3072-m+1)*H(m,:);
##  plot(tmp,'.');
##  hold on;
##  fprintf('printing %d row\n',m);
##end
##fprintf('finished to print\n');
####
####%Print to a file
####print (1, "test.pdf", "-dpdflatexstandalone");
####fprintf('finished to print in file\n');
####close all;

