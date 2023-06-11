clear all;
close all;
clc;

%debug
debug=0;

%Example matrix
A = [2 -1 0 ; -1 2 -1; 0 -1 2 ];
Id= eye(3);

A = [A Id]


% n are rows
% m are columns
[n,m] = size(A);

%Gauss-Jordan algorithm
r=0;
for j=1:m %j goes through all collumns
   if debug fprintf("------\nj=%d\n------\n",j) end;
   if debug A(r+1:end,j) end;
   [maxval,k]=max(abs(A(r+1:end,j)));% find the max
   k=k+r;
   if debug fprintf("Step 1.1 max=%d k=%d\n",maxval,k) end;
   if A(k,j)~=0
     r=r+1;
        if debug fprintf("Step 1.2.1 r=%d\n",r) end;
        if debug fprintf("divide line\n") end;
     A(k,:)=A(k,:)/A(k,j);
     if k~=r
          if debug fprintf("row swap\n") end;
       tmp = A(k,:);
       A(k,:) = A(r,:);
       A(r,:) = tmp;
     end;
     for i=1:n
       if i~=r
            if debug fprintf("substract\n") end;
            if debug fprintf("A(%d,%d)=%d\n",i,r,A(i,r)) end;
         A(i,:) = A(i,:)-A(r,:)*A(i,j);
       end;
     end;
   end;
end;

A