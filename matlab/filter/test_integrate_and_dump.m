clc;
clear all;
close all;

%Initialize a rand seed
rand('state',1);

%Parameter
nb_size=32;
ovr=4;

%Generate a random stream NRZ-L
data=round(rand(1,nb_size))*2-1;

%Oversample the NRZ-L data
data_ovr=zeros(1,length(data)*ovr);
for m=1:ovr
  data_ovr(m:ovr:end)=data;
end

%Oversample the NRZ-L data
sample_offset=0; %Zero means no offset
if sample_offset==0
else
  data_ovr=[data_ovr(1+sample_offset:end) data_ovr(1:sample_offset)];
end


%Integrate and Dump on data ovr
local_k=0;
I_and_D=zeros(1,length(data_ovr));
I_and_D_out=zeros(1,length(data_ovr));
for k=1:length(data_ovr)
    if local_k==0
      integrator=data_ovr(k);
    else
      integrator=integrator+data_ovr(k);
    end;
    I_and_D(k)=integrator;
    if local_k==ovr-1
      I_and_D_out(k)=integrator;
    end
    if local_k==ovr-1
        local_k=0;
    else
        local_k=local_k+1;
    end;
end;

%Compute Gardner algorithm on this
for k=ovr:ovr:length(I_and_D_out)-ovr
          E=I_and_D_out(k);
          P=I_and_D_out(k+ovr/2);
          L=I_and_D_out(k+ovr);
          timing_error=(L-E)/2;
          fprintf("E=%f\t P=%f\t L=%f\t error=%f\n",E,P,L,timing_error);
end

%Plot selected data
subplot(311);
plot(data_ovr);
ylim([-1.5 1.5]);
subplot(312);
plot(I_and_D);
subplot(313);
plot(I_and_D_out);


