function test_vector_out = polyphase_filter(test_vector_in,h,Fsamp,Fsymb)

    test_vector_out = zeros(1,length(test_vector_in)*Fsamp/Fsymb);
    kk=1;

    %Create table index
    ntaps=length(h);
    table_index=(1:ntaps);

    %Display selected index
    ratio=Fsamp/Fsymb;
    for m=1:length(test_vector_in)-ntaps
      for k=1:ratio
        tmp = table_index(1+k-1:ratio:end);
        kernel_a  = h(tmp);
        kernel_b  =  test_vector_in(m:m+length(kernel_a)-1);
        sum_kernel_a_X_kernel_b = sum(kernel_a.*kernel_b);
        test_vector_out(kk)=sum_kernel_a_X_kernel_b;
        kk = kk+1;
      end
    end
    
end 