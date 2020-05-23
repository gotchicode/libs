function [x_out,y_out] = cordic_cos_sin(input_degres,iterations,debug)
  
  %const
  const_1em9_val=1e-9;
  const_45_val=45;
  const_90_val=90;
  const_135_val=135;
  const_180_val=180;
  const_225_val=225;
  const_270_val=270;
  const_315_val=315;
  const_360_val=360;
  const_K=0.6072529350088814;
  
  atan_const=[];
  for k=0:31
    if debug==1
      fprintf("i=%d 2^-i=%f atan=%f rad atan=%f deg\n",k,2^-k,atan(2^-k),atan(2^-k)/2/pi*const_360_val);
    end
    atan_const=[atan_const atan(2^-k)];
  end
  
  %const gain

  input_rad = input_degres/const_360_val*2*pi;

  %Const
  K=const_K;
  n=iterations;

  %Recalc
  input_degres_recalc=input_degres;

  % input degress between 45 and const_90_val
  if (input_degres>const_45_val && input_degres<=const_90_val)
    input_degres_recalc=const_90_val-input_degres;
  end

  % input degress between const_90_val and const_135_val
  if (input_degres>const_90_val && input_degres<=const_135_val)
    input_degres_recalc=input_degres-const_90_val;
  end

  % input degress between const_135_val and const_180_val
  if (input_degres>const_135_val && input_degres<=const_180_val)
    input_degres_recalc=const_180_val-input_degres;
  end

  % input degress between const_180_val and const_225_val
  if (input_degres>const_180_val && input_degres<=const_225_val)
    input_degres_recalc=input_degres-const_180_val;
  end

  % input degress between const_225_val and const_270_val
  if (input_degres>const_225_val && input_degres<=const_270_val)
    input_degres_recalc=const_90_val-(input_degres-const_180_val);
  end

  % input degress between const_270_val and const_315_val
  if (input_degres>const_270_val && input_degres<=const_315_val)
    input_degres_recalc=(input_degres-const_180_val)-const_90_val;
  end

  % input degress between const_315_val and const_360_val
  if (input_degres>const_315_val && input_degres<=const_360_val)
    input_degres_recalc=const_180_val-(input_degres-const_180_val);
  end

  %  and degres exceptions
  if input_degres_recalc==0
    input_degres_recalc=const_1em9_val;
  end
  if input_degres_recalc==const_45_val
    input_degres_recalc=const_45_val-const_1em9_val;
  end
  input_rad_recalc = input_degres_recalc/const_360_val*2*pi;

  %Start computing
  x=K;
  y=0;
  distance = input_rad_recalc;
  i=0;
  
    if debug==1
      fprintf("input_degres_recalc ==%f\n", input_degres_recalc);
    end

  for i=0:n
    s = sign(distance);
    tmp = x -( s*(y/2^i));
    y = y +( s*(x/2^i));
    x = tmp;
    distance = distance - (s*atan_const(i+1));
    if debug==1
      fprintf("n=%d distance=%d\n",i, distance);
    end
  end

  %Replace
  
    if debug==1
      fprintf("input_degres=%f\n",input_degres);
    end

  % input degress between 0 and 45
  if (input_degres>0 && input_degres<=const_45_val)
   x_new = x;
   y_new = y;
  end

  % input degress between 45 and const_90_val
  if (input_degres>const_45_val && input_degres<=const_90_val)
   x_new = y;
   y_new = x;
  end

  % input degress between const_90_val and const_135_val
  if (input_degres>const_90_val && input_degres<=const_135_val)
   x_new = -y;
   y_new = x;
  end

  % input degress between const_135_val and const_180_val
  if (input_degres>const_135_val && input_degres<=const_180_val)
   x_new = -x;
   y_new = y;
  end

  % input degress between const_180_val and const_225_val
  if (input_degres>const_180_val && input_degres<=const_225_val)
   x_new = -x;
   y_new = -y;
  end

  % input degress between const_225_val and const_270_val
  if (input_degres>const_225_val && input_degres<=const_270_val)
   x_new = -y;
   y_new = -x;
  end

  % input degress between const_270_val and const_315_val
  if (input_degres>const_270_val && input_degres<=const_315_val)
   x_new = y;
   y_new = -x;
  end

  % input degress between const_315_val and const_360_val
  if (input_degres>const_315_val && input_degres<=const_360_val)
   x_new = x;
   y_new = -y;
  end

  x_cos_of_input_rad = cos(input_rad);
  y_sin_of_input_rad = sin(input_rad);

  if debug==1
    fprintf("input_rad=%f \tcordic_x=%d \t cos_x=%f \terror=%f\n",input_rad,x_new,x_cos_of_input_rad,x_new-x_cos_of_input_rad);
    fprintf("input_rad=%f \tcordic_y=%d \t cos_y=%f \terror=%f\n",input_rad,y_new,y_sin_of_input_rad,y_new-y_sin_of_input_rad);
  end
  
  x_out = x_new;
  y_out = y_new;

endfunction
