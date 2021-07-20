##clear all;
##close all;
##clc;
##
##%------------------------------------------
##%-Build H matrix for 2/3 1K
##%------------------------------------------
##
##M=128; %Defined in table R2
##                            
##
##pi_k_const_4_5_1024_128 =   [   1 3 1 0 0 0;
##                                2 0 22 27 12 13;
##                                3 1 0 30 30 19;
##                                4 2 26 28 18 14;
##                                5 2 0 7 10 15;
##                                6 3 10 1 16 20;
##                                7 0 5 8 13 17;
##                                8 1 18 20 9 4;
##                                9 0 3 26 7 4;
##                                10 1 22 24 15 11;
##                                11 2 3 4 16 17;
##                                12 0 8 12 18 20;
##                                13 2 25 23 4 8;
##                                14 3 25 15 23 22;
##                                15 0 2 15 5 19;
##                                16 1 27 22 3 15;
##                                17 2 7 31 29 5;
##                                18 0 7 3 11 21;
##                                19 1 15 29 4 17;
##                                20 2 10 21 8 9;
##                                21 0 4 2 2 20;
##                                22 1 19 5 11 18;
##                                23 2 7 11 11 31;
##                                24 1 9 26 3 13;
##                                25 2 26 9 15 2;
##                                26 3 17 17 13 18];  
##                            
##                            
##
##%Static elements of Parity check matrix                        
##zero_M = zeros(M,M);
##Id_M = eye(M);
##
##%------------------------------------------
##%-Permutation matrix build
##%------------------------------------------
##
##%Parameters k
##k=1;
##
##%Init empty PI_k
##PI_k=zeros(26,M);
##
##for k=1:26
##    for i=0:M-1
##        teta_k = pi_k_const_4_5_1024_128(k,2);
##        phi_k = pi_k_const_4_5_1024_128 ( k, 3+floor(4*i/M) );
##        PI_k(k,i+1) = M/4*mod(teta_k + floor(4*i/M),4) + mod((phi_k+i),M/4);
##        
##        if k==1
##          % teta_k %ok
##          % floor(4*i/M) %ok
##        end
##    end
##end
##
##
##%Init the submat
##PI_k_submat = zeros(M,M,26);
##
##%Fill the submat
##for k=1:26
##    for i=0:M-1
##        index = PI_k(k,i+1);
##        PI_k_submat(i+1,index+1,k) = 1;
##    end
##end
##
####plot(PI_k(7,:));
##
##
##H_submat_1_1 = zero_M;
##H_submat_1_2 = zero_M;
##H_submat_1_3 = zero_M;
##H_submat_1_4 = zero_M;
##H_submat_1_5 = zero_M;
##H_submat_1_6 = zero_M;
##
##H_submat_2_1 =  mod(PI_k_submat(:,:,21) .+ PI_k_submat(:,:,22) .+ PI_k_submat(:,:,23),2);
##H_submat_2_2 = Id_M;
##H_submat_2_3 = mod(PI_k_submat(:,:,15) .+ PI_k_submat(:,:,16) .+ PI_k_submat(:,:,17),2);
##H_submat_2_4 = Id_M;
##H_submat_2_5 = mod(PI_k_submat(:,:,9) .+ PI_k_submat(:,:,10) .+ PI_k_submat(:,:,11),2);
##H_submat_2_6 = Id_M;
##
##H_submat_3_1 = Id_M;
##H_submat_3_2 = mod(PI_k_submat(:,:,24) .+ PI_k_submat(:,:,25) .+ PI_k_submat(:,:,26),2);
##H_submat_3_3 = Id_M;
##H_submat_3_4 = mod(PI_k_submat(:,:,18) .+ PI_k_submat(:,:,19) .+ PI_k_submat(:,:,20),2);
##H_submat_3_5 = Id_M;
##H_submat_3_6 = mod(PI_k_submat(:,:,12) .+ PI_k_submat(:,:,13) .+ PI_k_submat(:,:,14),2);
##
##H1 =    [ H_submat_1_1 H_submat_1_2 H_submat_1_3 H_submat_1_4 H_submat_1_5 H_submat_1_6 ];
##      
##H2 =   [H_submat_2_1 H_submat_2_2 H_submat_2_3 H_submat_2_4 H_submat_2_5 H_submat_2_6 ];
##  
##H3 =   [H_submat_3_1 H_submat_3_2 H_submat_3_3 H_submat_3_4 H_submat_3_5 H_submat_3_6 ];
##
##      
##H = [H1; H2; H3];
##load('H_12_1k.mat');
H = [H H_12_1k];

##%Plot H matrix
##figure(1)
##for m=1:768
##  tmp = (768-m+1)*H(m,:);
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

