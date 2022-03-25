clear all;
close all;
clc;

%Data input
data_string=[];
##data_string =  [data_string; '78977180']; 
##data_string =  [data_string; '42ad010b']; 
##data_string =  [data_string; 'c98be95d']; 
##data_string =  [data_string; '13dddef0']; 
##data_string =  [data_string; '6533ab95']; 
##data_string =  [data_string; '426fafc7']; 
##data_string =  [data_string; '4976cd99']; 
##data_string =  [data_string; 'adb74562'];
data_string =  [data_string; '5c97a47b9266a231'];
data_string =  [data_string; '68b46e46b3bca17a'];
data_string =  [data_string; '51e9b97fdce45638'];
data_string =  [data_string; '3f4cf7c78951bc25'];
data_string =  [data_string; '5c1a27bfafc35223'];
data_string =  [data_string; 'e250959a81f35ff8'];
data_string =  [data_string; '1b4e0fba02291468'];
data_string =  [data_string; '1dc7d55e3b1c0f21'];

##%Stuff with zeros
##data_string =  [data_string; repmat('0',26,8)];

% Big endian - LSB MSB
data_string_out=[];
data_string_size=size(data_string)
for m=1:data_string_size(1)
  for n=1:2:data_string_size(2)
    tmp = data_string(m,n:n+1);
    data_string_out=[data_string_out tmp];
  end;
end;
fprintf("Big endian - LSB MSB: %s\n",data_string_out);

% Big endian - MSB LSB
data_string_out=[];
data_string_size=size(data_string)
for m=1:2:data_string_size(1)
  
  for n=1:2:data_string_size(2)
    tmp = data_string(m+1,n:n+1);
    data_string_out=[data_string_out tmp];
  end;
  
  for n=1:2:data_string_size(2)
    tmp = data_string(m,n:n+1);
    data_string_out=[data_string_out tmp];
  end;
  
end;
fprintf("Big endian - MSB LSB: %s\n",data_string_out);

% Little endian - LSB MSB
data_string_out=[];
data_string_size=size(data_string)
for m=1:data_string_size(1)
  for n=data_string_size(2):-2:1
    tmp = data_string(m,n-1:n);
    data_string_out=[data_string_out tmp];
  end;
end;
fprintf("Little endian - LSB MSB: %s\n",data_string_out);

% Little endian - MSB LSB
data_string_out=[];
data_string_size=size(data_string)
for m=1:2:data_string_size(1)
  
  for n=data_string_size(2):-2:1
    tmp = data_string(m+1,n-1:n);
    data_string_out=[data_string_out tmp];
  end;
  
  for n=data_string_size(2):-2:1
    tmp = data_string(m,n-1:n);
    data_string_out=[data_string_out tmp];
  end;
  
end;
fprintf("Little endian - MSB LSB : %s\n",data_string_out);

