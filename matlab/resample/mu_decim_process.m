%Using algorithms from Paul Bourke website

function data_out = mu_decim_process(data_in,Fin,Fout,debug,interp_type)

%Interp type %0:Linear %1:Cosine %2:Cubic %3Cubic Paul Breeuwsma

%Create a debug file
if debug==1
  fid=fopen('buffer_out.txt','w');
end

%Init
data_cnt=0;
time_tmp=0;
nco_accu_tmp_r1=0;
nco_accu_tmp=0;
Fin_detect_flag=0;
buffer_out=[];

%Work
while(data_cnt<length(data_in))

    time_tmp = time_tmp + 1/Fout;
    nco_accu_tmp_r1 = nco_accu_tmp;
    nco_accu_tmp = mod(nco_accu_tmp+Fout/Fin*2^32,2^32);
    
    if nco_accu_tmp<nco_accu_tmp_r1
        data_cnt=data_cnt+1;
        Fin_detect_flag=1;
    end

    mu_tmp = nco_accu_tmp/2^32;

    if debug==1
        fprintf('time_tmp=%f \tnco_accu_tmp=%f \tFin_detect_flag=%d \tmu_tmp=%f \tdata_cnt=%d\n',time_tmp*1e9,nco_accu_tmp,Fin_detect_flag,mu_tmp,data_cnt);
    end;

    if interp_type==0
        if (data_cnt>0 && data_cnt<length(data_in))
            tmp = data_in(data_cnt)*(1-mu_tmp)+data_in(data_cnt+1)*mu_tmp;
            buffer_out=[buffer_out tmp];
        end
    end;

    if interp_type==1
        if (data_cnt>0 && data_cnt<length(data_in))
            mu_bis_tmp = (1-cos(mu_tmp*pi))/2;
            tmp = data_in(data_cnt)*(1-mu_bis_tmp)+data_in(data_cnt+1)*mu_bis_tmp;
            buffer_out=[buffer_out tmp];
        end
    end;

    if interp_type==2
        if (data_cnt>1 && data_cnt<length(data_in)-1)
            mu_bis_tmp = mu_tmp * mu_tmp;
            y0=data_in(data_cnt-1);
            y1=data_in(data_cnt);
            y2=data_in(data_cnt+1);
            y3=data_in(data_cnt+2);
            a0=y3-y2-y0+y1;
            a1=y0-y1-a0;
            a2=y2-y0;
            a3=y1;
            tmp = a0*mu_tmp*mu_bis_tmp+a1*mu_bis_tmp+a2*mu_tmp+a3;
            buffer_out=[buffer_out tmp];
        end
    end;

    if interp_type==3
        if (data_cnt>1 && data_cnt<length(data_in)-1)
            mu_bis_tmp = mu_tmp * mu_tmp;
            y0=data_in(data_cnt-1);
            y1=data_in(data_cnt);
            y2=data_in(data_cnt+1);
            y3=data_in(data_cnt+2);
            a0= -0.5*y0 + 1.5*y1 - 1.5*y2 + 0.5*y3;
            a1= y0 - 2.5*y1 + 2*y2 -0.5*y3;
            a2= -0.5*y0 + 0.5*y2;
            a3= y1;
            tmp = a0*mu_tmp*mu_bis_tmp+a1*mu_bis_tmp+a2*mu_tmp+a3;
            buffer_out=[buffer_out tmp];
            
            if debug==1
              fprintf(fid,'mu=%f I=%f Q=%f I_ori=%f Q_ori=%f\n',mu_tmp,real(tmp),imag(tmp),real(data_in(data_cnt)),imag(data_in(data_cnt)));
            end
            
        end
    end;
    


    Fin_detect_flag=0;
end

    if debug==1
      fclose(fid);
    end;
    
    data_out=buffer_out;
end