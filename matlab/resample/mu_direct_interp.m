function data_out = mu_direct_interp(data_in, mu, interp_type,debug)
  
    mu_tmp = mu;
  
    if interp_type==0
      tmp = data_in(2)*(1-mu_tmp)+data_in(3)*mu_tmp;
      buffer_out=[tmp];
    end;

    if interp_type==1
      mu_bis_tmp = (1-cos(mu_tmp*pi))/2;
      tmp = data_in(data_cnt)*(1-mu_bis_tmp)+data_in(data_cnt+1)*mu_bis_tmp;
      buffer_out=[tmp];
    end;

    if interp_type==2
      mu_bis_tmp = mu_tmp * mu_tmp;
      y0=data_in(1);
      y1=data_in(2);
      y2=data_in(3);
      y3=data_in(4);
      a0=y3-y2-y0+y1;
      a1=y0-y1-a0;
      a2=y2-y0;
      a3=y1;
      tmp = a0*mu_tmp*mu_bis_tmp+a1*mu_bis_tmp+a2*mu_tmp+a3;
      buffer_out=[tmp];
    end;

    if interp_type==3
        mu_bis_tmp = mu_tmp * mu_tmp;
        y0=data_in(1);
        y1=data_in(2);
        y2=data_in(3);
        y3=data_in(4);
        a0= -0.5*y0 + 1.5*y1 - 1.5*y2 + 0.5*y3;
        a1= y0 - 2.5*y1 + 2*y2 -0.5*y3;
        a2= -0.5*y0 + 0.5*y2;
        a3= y1;
        tmp = a0*mu_tmp*mu_bis_tmp+a1*mu_bis_tmp+a2*mu_tmp+a3;
        buffer_out=[tmp];
      end
      
      data_out = buffer_out;

end