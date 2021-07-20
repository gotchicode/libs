

function data_out = block_inv_modulo_m_n(data_in,disp_debug)

    [m n] = size(data_in);
    
    %With the constraint that m=n and is a power of 2
    
    if disp_debug==1
      fprintf('******************************\n');
      fprintf('m=%d \t\t n=%d\n',m,n);
      fprintf('******************************\n');
      fprintf('\n');
    end
       
    if (m>2 && n>2 && m==n)

        % Get 4 elements of the Matrix
        A = data_in(1:2,1:2);
        B = data_in(1:2,3:end);
        C = data_in(3:end,1:2);
        D = data_in(3:end,3:end);
        
        if disp_debug==1
          fprintf('\nCall 2 block_inv_modulo_m_n\n');
        end;  
        
        %Recursive calc of A_inv
        A_inv = block_inv_modulo_m_n(A,disp_debug);
        
        %Schur complement
        Schur_comp = D - C * A_inv * B;
        Schur_comp_inv = block_inv_modulo_m_n(Schur_comp,disp_debug);

        %First Part 
        First_part = [A_inv zeros(m-2,n-2); zeros(m-2,n-2) zeros(m-2,n-2)];
        
        Second_part = [-1 * A_inv B; eye(m-2,n)];
        
        %last Part
        Last_part = [-1 * C * A_inv  eye(m/2)];
        
        First_part
        Second_part
        Schur_comp_inv
        Last_part
        
        %Total
        Total = First_part + Second_part*Schur_comp_inv*Last_part;
        
        data_out = Total;
    
    else

        data_out = inv(data_in);
    if disp_debug==1
      fprintf('\nCall inv\n');
    end;

    end;
    
 end;