clc;
clear all;
close all;

%Parameters
nb_size = 2^12;
scale = 2^12;

%Create a vector to store occurences
data_test_occurence = zeros(1,40001);

y=0;
while(y<20)
    
    y=y+1;
    fprintf('%d iteration\n',y);
    
    %Generate a random test vector
    data_test = randn(1,nb_size)*scale;
    data_test = round(data_test);

    %Check min and max
    min_val = min(data_test);
    max_val = max(data_test);

    %counter occurances
    for k=-20000:20000
      tmp = sum(data_test == k);
      %tmp=count (k, data_test);
      if tmp>0
        %fprintf('%d is inside and %d times\n',k, sum(tmp));
        data_test_occurence(20000+k)=data_test_occurence(20000+k)+sum(tmp);
      end
    end
    
    %save
    save('test.mat', 'data_test_occurence', 'y');


##    figure(1);
##    plot(data_test);
##    hold on;
##    figure(2);
##    plot(data_test_occurence);
##    hold on;
##    pause(0.001);
    
end