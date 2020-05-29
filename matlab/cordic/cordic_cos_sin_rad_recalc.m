function [input_rad_recalc] = cordic_cos_sin_rad_recalc(input_rad)

  %const
  cordic_cos_sin_const;

  %Recalc
  input_rad_recalc=input_rad;

  % input radians between 45 and const_90_val
  if (input_rad>const_45_val && input_rad<=const_90_val)
    input_rad_recalc=const_90_val-input_rad;
  end

  % input radians between const_90_val and const_135_val
  if (input_rad>const_90_val && input_rad<=const_135_val)
    input_rad_recalc=input_rad-const_90_val;
  end

  % input radians between const_135_val and const_180_val
  if (input_rad>const_135_val && input_rad<=const_180_val)
    input_rad_recalc=const_180_val-input_rad;
  end

  % input radians between const_180_val and const_225_val
  if (input_rad>const_180_val && input_rad<=const_225_val)
    input_rad_recalc=input_rad-const_180_val;
  end

  % input radians between const_225_val and const_270_val
  if (input_rad>const_225_val && input_rad<=const_270_val)
    input_rad_recalc=const_90_val-(input_rad-const_180_val);
  end

  % input radians between const_270_val and const_315_val
  if (input_rad>const_270_val && input_rad<=const_315_val)
    input_rad_recalc=(input_rad-const_180_val)-const_90_val;
  end

  % input radians between const_315_val and const_360_val
  if (input_rad>const_315_val && input_rad<=const_360_val)
    input_rad_recalc=const_180_val-(input_rad-const_180_val);
  end

  %  and degres exceptions
  if input_rad_recalc==0
    input_rad_recalc=const_1em9_val;
  end
  if input_rad_recalc==const_45_val
    input_rad_recalc=const_45_val-const_1em9_val;
  end
  
end