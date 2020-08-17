function data_out=mapper(data_in,modu)

%BPSK
if strcmp(modu,'BPSK')
  
  %Parameters
  bps=1;
  y0=[1 0];
  RE=[-1 1];
  IM=[0 0];
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:length(data_in)
    y0_tmp=data_in(k);
    for m=1:length(y0)
      if y0(m)==y0_tmp
        tmp_RE=RE(m);
        tmp_IM=IM(m);
      end
    end
    data_out_ind = data_out_ind+1;
    data_out(data_out_ind)=tmp_RE+tmp_IM;
  end
end 

if strcmp(modu,'QPSK')
  
  %QPSK
  bps=2;
  y0 = [1 0];
  y1 = y0;
  RE = [-1 1]; %y0
  IM = RE*j; %y1
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    
    for m=1:length(y0)
        if y0(m)==y0_tmp
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y1)
        if y1(n)==y1_tmp
          tmp_IM=IM(n);
        end
    end 
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end
  
end

if strcmp(modu,'16-QAM')

  %16-QAM
  bps=4;
  y0=[1 1 0 0];
  y2=[0 1 1 0];
  y1=y0;
  y3=y2;
  RE = [-3 -1 1 3]; 
  IM = RE*j;
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    y2_tmp=data_in(k+2);
    y3_tmp=data_in(k+3);
    
    for m=1:length(y0)
        if y0(m)==y0_tmp && y2(m)==y2_tmp
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y0)
        if y1(n)==y1_tmp  && y3(n)==y3_tmp
          tmp_IM=IM(n);
        end
    end 
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end

end

if strcmp(modu,'64-QAM')
  
  %64-QAM
  bps=6;
  y0=[1 1 1 1 0 0 0 0];
  y2=[0 0 1 1 1 1 0 0];
  y4=[0 1 1 0 0 1 1 0];
  y1=y0;
  y3=y2;
  y5=y4;
  RE=[-7 -5 -3 -1 1 3 5 7];
  IM=RE*j;
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    y2_tmp=data_in(k+2);
    y3_tmp=data_in(k+3);
    y4_tmp=data_in(k+4);
    y5_tmp=data_in(k+5);
    
    
    for m=1:length(y0)
        if y0(m)==y0_tmp && y2(m)==y2_tmp && y4(m)==y4_tmp 
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y0)
        if y1(n)==y1_tmp  && y3(n)==y3_tmp && y5(n)==y5_tmp
          tmp_IM=IM(n);
        end
    end 
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end

end

if strcmp(modu,'256-QAM')
  
  %256-QAM
  bps=8;
  y0=[1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
  y2=[0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0];
  y4=[0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0];
  y6=[0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0];
  y1=[y0];
  y3=[y2];
  y5=[y4];
  y7=[y6];
  RE=[-15 -13 -11 -9 -7 -5 -3 -1 1 3 5 7 9 11 13 15];
  IM=RE*j;

  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    y2_tmp=data_in(k+2);
    y3_tmp=data_in(k+3);
    y4_tmp=data_in(k+4);
    y5_tmp=data_in(k+5);
    y6_tmp=data_in(k+6);
    y7_tmp=data_in(k+7);

    for m=1:length(y0)
        if y0(m)==y0_tmp && y2(m)==y2_tmp && y4(m)==y4_tmp && y6(m)==y6_tmp  
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y0)
        if y1(n)==y1_tmp  && y3(n)==y3_tmp && y5(n)==y5_tmp && y7(n)==y7_tmp
          tmp_IM=IM(n);
        end
    end 
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end

end



if strcmp(modu,'1024-QAM')

  %1024-QAM
  bps=10;
  y0=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
  y2=[fliplr([1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]) [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]];
  y4=[fliplr([0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0]) [0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0]];
  y6=[fliplr([0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0]) [0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0]];
  y8=[fliplr([0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0]) [0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0]];
  y1=[y0];
  y3=[y2];
  y5=[y4];
  y7=[y6];
  y9=[y8];
  RE=[-31 -29 -27 -25 -23 -21 -19 -17 -15 -13 -11 -9 -7 -5 -3 -1 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31];
  IM=RE*j;
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    y2_tmp=data_in(k+2);
    y3_tmp=data_in(k+3);
    y4_tmp=data_in(k+4);
    y5_tmp=data_in(k+5);
    y6_tmp=data_in(k+6);
    y7_tmp=data_in(k+7);
    y8_tmp=data_in(k+8);
    y9_tmp=data_in(k+9);

    for m=1:length(y0)
        if y0(m)==y0_tmp && y2(m)==y2_tmp && y4(m)==y4_tmp && y6(m)==y6_tmp && y8(m)==y8_tmp 
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y0)
        if y1(n)==y1_tmp  && y3(n)==y3_tmp && y5(n)==y5_tmp && y7(n)==y7_tmp && y9(n)==y9_tmp
          tmp_IM=IM(n);
        end
    end
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end

end

if strcmp(modu,'4096-QAM')
  
  %4096-QAM
  bps=12;
  y0= [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
  y2= [fliplr([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]) [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]];
  y4= [fliplr([0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]) [0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]];
  y6= [fliplr([0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0]) [0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0]];
  y8= [fliplr([0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0]) [0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0]];
  y10= [fliplr([0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0]) [0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0]];
  y1=[y0];
  y3=[y2];
  y5=[y4];
  y7=[y6];
  y9=[y8];
  y11=[y10];
  RE=(-63:2:63);
  IM=RE*j;
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    y2_tmp=data_in(k+2);
    y3_tmp=data_in(k+3);
    y4_tmp=data_in(k+4);
    y5_tmp=data_in(k+5);
    y6_tmp=data_in(k+6);
    y7_tmp=data_in(k+7);
    y8_tmp=data_in(k+8);
    y9_tmp=data_in(k+9);
    y10_tmp=data_in(k+10);
    y11_tmp=data_in(k+11);

    for m=1:length(y0)
        if y0(m)==y0_tmp && y2(m)==y2_tmp && y4(m)==y4_tmp && y6(m)==y6_tmp && y8(m)==y8_tmp && y10(m)==y10_tmp 
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y0)
        if y1(n)==y1_tmp  && y3(n)==y3_tmp && y5(n)==y5_tmp && y7(n)==y7_tmp && y9(n)==y9_tmp && y11(n)==y11_tmp
          tmp_IM=IM(n);
        end
    end
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end

end

if strcmp(modu,'16384-QAM')
  
  %Take values from 4096-QAM
  y0_4096= [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
  y2_4096= [fliplr([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]) [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]];
  y4_4096= [fliplr([0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]) [0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]];
  y6_4096= [fliplr([0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0]) [0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0]];
  y8_4096= [fliplr([0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0]) [0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0]];
  y10_4096= [fliplr([0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0]) [0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0]];
  
  %Create for 16384-QAM
  bps=14;
  y0=   [ones(1,length([y0_4096]))  zeros(1,length([y0_4096]))];
  y2=   [fliplr([y0_4096])   [y0_4096]];
  y4=   [fliplr([y2_4096])   [y2_4096]];
  y6=   [fliplr([y4_4096])   [y4_4096]];
  y8=   [fliplr([y6_4096])   [y6_4096]];
  y10=  [fliplr([y8_4096])   [y8_4096]];
  y12=  [fliplr([y10_4096])  [y10_4096]];  
  
  y1=[y0];
  y3=[y2];
  y5=[y4];
  y7=[y6];
  y9=[y8];
  y11=[y10];
  y13=[y12];
  RE=(-127:2:127);
  IM=RE*j;
  
  %Init output buffer
  data_out = zeros(1,length(data_in)/bps);
  
  %Mapping
  data_out_ind = 0;
  for k=1:bps:length(data_in)
    
    y0_tmp=data_in(k);
    y1_tmp=data_in(k+1);
    y2_tmp=data_in(k+2);
    y3_tmp=data_in(k+3);
    y4_tmp=data_in(k+4);
    y5_tmp=data_in(k+5);
    y6_tmp=data_in(k+6);
    y7_tmp=data_in(k+7);
    y8_tmp=data_in(k+8);
    y9_tmp=data_in(k+9);
    y10_tmp=data_in(k+10);
    y11_tmp=data_in(k+11);
    y12_tmp=data_in(k+12);
    y13_tmp=data_in(k+13);

    for m=1:length(y0)
        if y0(m)==y0_tmp && y2(m)==y2_tmp && y4(m)==y4_tmp && y6(m)==y6_tmp && y8(m)==y8_tmp && y10(m)==y10_tmp && y12(m)==y12_tmp 
          tmp_RE=RE(m);
        end
    end
    for n=1:length(y0)
        if y1(n)==y1_tmp  && y3(n)==y3_tmp && y5(n)==y5_tmp && y7(n)==y7_tmp && y9(n)==y9_tmp && y11(n)==y11_tmp && y13(n)==y13_tmp 
          tmp_IM=IM(n);
        end
    end
    data_out_ind = data_out_ind+1;
    tmp = tmp_RE+tmp_IM;
    data_out(data_out_ind)= tmp;
  end


end
