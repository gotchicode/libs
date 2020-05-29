function [x_out,y_out] = cordic_cos_sin(input_rad,iterations,debug)
  
  %const
  cordic_cos_sin_const;
  
  atan_const=[];
  for k=0:31
    if debug==1
      fprintf("i=%d 2^-i=%f atan=%f rad atan=%f deg\n",k,2^-k,atan(2^-k),atan(2^-k)/2/pi*const_360_val);
    end
    atan_const=[atan_const atan(2^-k)];
  end

  %Const
  K=const_K;
  n=iterations;
  
  %Rad quadrants recalc
  input_rad_recalc = cordic_cos_sin_rad_recalc(input_rad);

  %Start computing
  x=K;
  y=0;
  distance = input_rad_recalc;
  i=0;
  
    if debug==1
      fprintf("input_rad_recalc ==%f\n", input_rad_recalc);
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
      fprintf("input_rad=%f\n",input_rad);
    end
    
  %Update coordinates
  [x_new, y_new] = cordic_cos_sin_x_y_update(input_rad,x,y);


  %for debug purpose
  x_cos_of_input_rad = cos(input_rad);
  y_sin_of_input_rad = sin(input_rad);

  if debug==1
    fprintf("input_rad=%f \tcordic_x=%d \t cos_x=%f \terror=%f\n",input_rad,x_new,x_cos_of_input_rad,x_new-x_cos_of_input_rad);
    fprintf("input_rad=%f \tcordic_y=%d \t cos_y=%f \terror=%f\n",input_rad,y_new,y_sin_of_input_rad,y_new-y_sin_of_input_rad);
  end
  
  x_out = x_new;
  y_out = y_new;

endfunction
