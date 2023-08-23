function [loop_out, add_prev_out, loop_integ_out] = loop_filter_2nd_order(loop_in, T, Bn, ksi, add_prev_in, loop_integ_in)
  
  %Intermediate parameters
  A = (Bn*T/(ksi+1/4/ksi));
  K1 = 4*ksi*A/(1+2*ksi*A+A^2);
  K2 = 4*A^2/(1+2*ksi*A+A^2);
  
  loop_inter1 = loop_in * K1;
  loop_inter2 = loop_in*K2 + add_prev_in;
  loop_inter = loop_inter1 + loop_inter2;
  add_prev_in = add_prev_in+loop_in * K2;
  loop_integ_in = loop_integ_in+loop_inter;
  loop_out = loop_integ_in;
  
  add_prev_out = add_prev_in;
  loop_integ_out = loop_integ_in;
  
  
end