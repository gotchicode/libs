clear all;
close all;
clc;

%------------------------------------------
%-Build H matrix for 1/2 1K
%------------------------------------------

M=512; %Defined in table R2

pi_k_const_1_2_1024_512 =   [1 3 16 0 0 0;
                            2 0 103 53 8 35;
                            3 1 105 74 119 97;
                            4 2 0 45 89 112;
                            5 2 50 47 31 64;
                            6 3 29 0 122 93;
                            7 0 115 59 1 99;
                            8 1 30 102 69 94];

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
        teta_k = pi_k_const_1_2_1024_512(k,2);
        phi_k = pi_k_const_1_2_1024_512 ( k, 3+floor(4*i/M) );
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
H_12_1k = H;
##save H_12_1k.mat H_12_1k

##%Plot H matrix
##figure(1)
##for m=1:1536
##  tmp = (1536-m+1)*H(m,:);
##  plot(tmp,'.');
##  hold on;
##  fprintf('printing %d row\n',m);
##end
##fprintf('finished to print\n');


##%Print to a file
##print (1, "test.pdf", "-dpdflatexstandalone");
##fprintf('finished to print in file\n');
##close all;

% Create a blank image of size 200x200 pixels
width = 2560;
height =  1536;
image = zeros(height, width, 3); % 3 for RGB channels
####% Set a pixel at position (100, 100) to red (255, 0, 0)
####image(100, 100, :) = [255, 0, 0];
####% Set a pixel at position (150, 50) to green (0, 255, 0)
####image(150, 50, :) = [0, 255, 0];
####% Set a pixel at position (75, 175) to blue (0, 0, 255)
####image(75, 175, :) = [0, 0, 255];
for m=1:1536
  for n=1:2560
    if H(m,n)==1
      image(m, n, :) = [255, 0, 0];
    else
      image(m, n, :) = [255, 255, 255];
    end
  end
end
% Save the image as a bitmap
imwrite(image, 'output.bmp');


%------------------------------------------
%-Build G matrix for 1/2 1K
%------------------------------------------

%Let P be the 3M × 3M submatrix of H consisting of the last 3M columns.
P = H(:,end-3*M+1:end);

%Let Q be the 3M × MK submatrix of H consisting of the first MK columns
K = 2; %from 1/2 code rate
Q = H(1:3*M,1:M*K);

##Compute W, where the arithmetic is performed modulo-2.
P_inv = inv(P);
tmp_W = P_inv*Q;
W = tmp_W';
##W = mod(abs(floor(P_inv*Q')),2);
Id_MK = eye(M*K);
G = [Id_MK W];

##%The last M colums of G shall be punctured
G = G(:,1:end-M);

##P_inv_test = block_inv_modulo_2(P,1);

##max_recursion_depth (2048);
##P_inv_test = block_inv_modulo_m_n(P,1)
