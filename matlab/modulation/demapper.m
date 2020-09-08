function data_out=demapper(data_in,modu)
  
 data_modulated = data_in;
  
if strcmp(modu,'QPSK')
  %QPSK
  bps=2;
  y0 = [1 0];
  y1 = y0;
  RE = [-1 1]; %y0
  IM = RE*j; %y1
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
  
end

if strcmp(modu,'BPSK')

    %Init output buffer
    data_out = zeros(1,length(data_modulated)*1);

    for k=1:length(data_modulated)
        if real(data_modulated(k))>0
            data_out(k) = 0;
        end 
        if real(data_modulated(k))<=0
            data_out(k) = 1;
        end
    end
end

if strcmp(modu,'QPSK')

  
  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          %Check for Im
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
    end
    
    %Build output
    data_out(data_out_ind)=y0_tmp;
    data_out(data_out_ind+1)=y1_tmp;
    data_out_ind = data_out_ind+bps;

  end
    
end

if strcmp(modu,'16-QAM')

  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          if RE_up(m-1)<tmp_re && tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
          end
          %Check for Im
          if RE_up(m-1)<tmp_im && tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
          end
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
      y2_tmp = y2(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
      y3_tmp = y3(m+1);
    end
    
    %Build output
    data_out(data_out_ind)      =   y0_tmp;
    data_out(data_out_ind+1)    =   y1_tmp;
    data_out(data_out_ind+2)    =   y2_tmp;
    data_out(data_out_ind+3)    =   y3_tmp;
    
    data_out_ind = data_out_ind+bps;

  end
    
end


if strcmp(modu,'64-QAM')

  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          if RE_up(m-1)<tmp_re && tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
          end
          %Check for Im
          if RE_up(m-1)<tmp_im && tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m); 
          end
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
      y2_tmp = y2(m+1);
      y4_tmp = y4(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
      y3_tmp = y3(m+1);
      y5_tmp = y5(m+1);
    end
    
    %Build output
    data_out(data_out_ind)      =   y0_tmp;
    data_out(data_out_ind+1)    =   y1_tmp;
    data_out(data_out_ind+2)    =   y2_tmp;
    data_out(data_out_ind+3)    =   y3_tmp;
    data_out(data_out_ind+4)    =   y4_tmp;
    data_out(data_out_ind+5)    =   y5_tmp;
    
    data_out_ind = data_out_ind+bps;

  end
    
end

if strcmp(modu,'256-QAM')

  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m);
            y7_tmp = y7(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          if RE_up(m-1)<tmp_re && tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
          end
          %Check for Im
          if RE_up(m-1)<tmp_im && tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m); 
            y7_tmp = y7(m);  
          end
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
      y2_tmp = y2(m+1);
      y4_tmp = y4(m+1);
      y6_tmp = y6(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
      y3_tmp = y3(m+1);
      y5_tmp = y5(m+1);
      y7_tmp = y7(m+1);
    end
    
    %Build output
    data_out(data_out_ind)      =   y0_tmp;
    data_out(data_out_ind+1)    =   y1_tmp;
    data_out(data_out_ind+2)    =   y2_tmp;
    data_out(data_out_ind+3)    =   y3_tmp;
    data_out(data_out_ind+4)    =   y4_tmp;
    data_out(data_out_ind+5)    =   y5_tmp;
    data_out(data_out_ind+6)    =   y6_tmp;
    data_out(data_out_ind+7)    =   y7_tmp;
    data_out_ind = data_out_ind+bps;

  end
    
end

if strcmp(modu,'1024-QAM')

  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
            y8_tmp = y8(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m);
            y7_tmp = y7(m);
            y9_tmp = y9(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          if RE_up(m-1)<tmp_re && tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
            y8_tmp = y8(m);
          end
          %Check for Im
          if RE_up(m-1)<tmp_im && tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m); 
            y7_tmp = y7(m);  
            y9_tmp = y9(m);  
          end
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
      y2_tmp = y2(m+1);
      y4_tmp = y4(m+1);
      y6_tmp = y6(m+1);
      y8_tmp = y8(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
      y3_tmp = y3(m+1);
      y5_tmp = y5(m+1);
      y7_tmp = y7(m+1);
      y9_tmp = y9(m+1);
    end
    
    %Build output
    data_out(data_out_ind)      =   y0_tmp;
    data_out(data_out_ind+1)    =   y1_tmp;
    data_out(data_out_ind+2)    =   y2_tmp;
    data_out(data_out_ind+3)    =   y3_tmp;
    data_out(data_out_ind+4)    =   y4_tmp;
    data_out(data_out_ind+5)    =   y5_tmp;
    data_out(data_out_ind+6)    =   y6_tmp;
    data_out(data_out_ind+7)    =   y7_tmp;
    data_out(data_out_ind+8)    =   y8_tmp;
    data_out(data_out_ind+9)    =   y9_tmp;
    data_out_ind = data_out_ind+bps;

  end
    
end

if strcmp(modu,'4096-QAM')

  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
            y8_tmp = y8(m);
            y10_tmp = y10(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m);
            y7_tmp = y7(m);
            y9_tmp = y9(m);
            y11_tmp = y11(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          if RE_up(m-1)<tmp_re && tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
            y8_tmp = y8(m);
            y10_tmp = y10(m);
          end
          %Check for Im
          if RE_up(m-1)<tmp_im && tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m); 
            y7_tmp = y7(m);  
            y9_tmp = y9(m); 
            y11_tmp = y11(m); 
          end
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
      y2_tmp = y2(m+1);
      y4_tmp = y4(m+1);
      y6_tmp = y6(m+1);
      y8_tmp = y8(m+1);
      y10_tmp = y10(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
      y3_tmp = y3(m+1);
      y5_tmp = y5(m+1);
      y7_tmp = y7(m+1);
      y9_tmp = y9(m+1);
      y11_tmp = y11(m+1);
    end
    
    %Build output
    data_out(data_out_ind)      =   y0_tmp;
    data_out(data_out_ind+1)    =   y1_tmp;
    data_out(data_out_ind+2)    =   y2_tmp;
    data_out(data_out_ind+3)    =   y3_tmp;
    data_out(data_out_ind+4)    =   y4_tmp;
    data_out(data_out_ind+5)    =   y5_tmp;
    data_out(data_out_ind+6)    =   y6_tmp;
    data_out(data_out_ind+7)    =   y7_tmp;
    data_out(data_out_ind+8)    =   y8_tmp;
    data_out(data_out_ind+9)    =   y9_tmp;
    data_out(data_out_ind+10)   =   y10_tmp;
    data_out(data_out_ind+11)   =   y11_tmp;
    data_out_ind = data_out_ind+bps;

  end
    
end

if strcmp(modu,'16384-QAM')

  %Init output buffer
  data_out = zeros(1,length(data_modulated)*bps);
    
  %DeMapping
  data_out_ind = 1;

  %Proceed the demapping
  RE_diff=diff(RE)/2;
  RE_up = RE(1:end-1)+RE_diff;

  for k=1:length(data_modulated)

    tmp_re=real(data_modulated(k));
    tmp_im=imag(data_modulated(k));
    
    for m=1:length(RE_up)
        if m==1
          %fprintf('test sample <= %d     it is a %d\n',RE_up(m),RE(m));
          %Check for Re
          if tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
            y8_tmp = y8(m);
            y10_tmp = y10(m);
            y12_tmp = y12(m);
          end
          %Check for Im
          if tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m);
            y7_tmp = y7(m);
            y9_tmp = y9(m);
            y11_tmp = y11(m);
            y13_tmp = y13(m);
          end
        else
          %fprintf('test %d<sample<=%d     it is a %d\n',RE_up(m-1),RE_up(m),RE(m));
          %Check for Re
          if RE_up(m-1)<tmp_re && tmp_re<=RE_up(m)
            y0_tmp = y0(m);
            y2_tmp = y2(m);
            y4_tmp = y4(m);
            y6_tmp = y6(m);
            y8_tmp = y8(m);
            y10_tmp = y10(m);
            y12_tmp = y12(m);
          end
          %Check for Im
          if RE_up(m-1)<tmp_im && tmp_im<=RE_up(m)
            y1_tmp = y1(m);
            y3_tmp = y3(m);
            y5_tmp = y5(m); 
            y7_tmp = y7(m);  
            y9_tmp = y9(m); 
            y11_tmp = y11(m); 
            y13_tmp = y13(m); 
          end
        end
    end
    %fprintf('test %d<sample     it is a %d\n',RE_up(m),RE(m+1));
    %Check for Re
    if tmp_re>RE_up(m)
      y0_tmp = y0(m+1);
      y2_tmp = y2(m+1);
      y4_tmp = y4(m+1);
      y6_tmp = y6(m+1);
      y8_tmp = y8(m+1);
      y10_tmp = y10(m+1);
      y12_tmp = y12(m+1);
    end
    %Check for Im
    if tmp_im>RE_up(m)
      y1_tmp = y1(m+1);
      y3_tmp = y3(m+1);
      y5_tmp = y5(m+1);
      y7_tmp = y7(m+1);
      y9_tmp = y9(m+1);
      y11_tmp = y11(m+1);
      y13_tmp = y13(m+1);
    end
    
    %Build output
    data_out(data_out_ind)      =   y0_tmp;
    data_out(data_out_ind+1)    =   y1_tmp;
    data_out(data_out_ind+2)    =   y2_tmp;
    data_out(data_out_ind+3)    =   y3_tmp;
    data_out(data_out_ind+4)    =   y4_tmp;
    data_out(data_out_ind+5)    =   y5_tmp;
    data_out(data_out_ind+6)    =   y6_tmp;
    data_out(data_out_ind+7)    =   y7_tmp;
    data_out(data_out_ind+8)    =   y8_tmp;
    data_out(data_out_ind+9)    =   y9_tmp;
    data_out(data_out_ind+10)   =   y10_tmp;
    data_out(data_out_ind+11)   =   y11_tmp;
    data_out(data_out_ind+12)   =   y12_tmp;
    data_out(data_out_ind+13)   =   y13_tmp;
    data_out_ind = data_out_ind+bps;

  end
    
end

