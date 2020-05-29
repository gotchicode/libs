function [x_new, y_new] = cordic_cos_sin_x_y_update(input_rad,x,y,quant)

  %const
  [const_1em9_val, const_45_val, const_90_val, const_135_val, const_180_val, const_225_val, const_270_val, const_315_val, const_360_val, const_K, atan_const]=cordic_cos_sin_const(quant);

  % input radians between 0 and 45
  if (input_rad>0 && input_rad<=const_45_val)
   x_new = x;
   y_new = y;
  end

  % input radians between 45 and const_90_val
  if (input_rad>const_45_val && input_rad<=const_90_val)
   x_new = y;
   y_new = x;
  end

  % input radians between const_90_val and const_135_val
  if (input_rad>const_90_val && input_rad<=const_135_val)
   x_new = -y;
   y_new = x;
  end

  % input radians between const_135_val and const_180_val
  if (input_rad>const_135_val && input_rad<=const_180_val)
   x_new = -x;
   y_new = y;
  end

  % input radians between const_180_val and const_225_val
  if (input_rad>const_180_val && input_rad<=const_225_val)
   x_new = -x;
   y_new = -y;
  end

  % input radians between const_225_val and const_270_val
  if (input_rad>const_225_val && input_rad<=const_270_val)
   x_new = -y;
   y_new = -x;
  end

  % input radians between const_270_val and const_315_val
  if (input_rad>const_270_val && input_rad<=const_315_val)
   x_new = y;
   y_new = -x;
  end

  % input radians between const_315_val and const_360_val
  if (input_rad>const_315_val && input_rad<=const_360_val)
   x_new = x;
   y_new = -y;
  end
  
end