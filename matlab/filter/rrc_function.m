function h = rrc_function(Fsymb, Fsamp, roll_off)
  

%Init
Ts=1/Fsymb;
Tsamp=1/Fsamp;
t=(-4:Tsamp:4);

%Filter coefficients
h_zero = 1/Ts*(1+roll_off*(4/pi-1));
h_Ts_4_roll_off = roll_off/Ts/sqrt(2) * [(1+2/pi) * sin(pi/4/roll_off) + (1-2/pi) * cos(pi/4/roll_off)];
h= 1/Ts * (sin(pi*t/Ts*(1-roll_off)) + 4*roll_off*t/Ts.*cos(pi*t/Ts*(1+roll_off))) ./ (pi * t/Ts .* [1-(4*roll_off*t/Ts).^2]);

%Replace the h_zero
for k=1:length(t)
  if t(k)==0
    h(k)=h_zero;
  endif
end;

%Replace the h_Ts_4_roll_off
for k=1:length(t)
  if t(k)==Ts/4/roll_off
    h(k)=h_Ts_4_roll_off;
    printf('found h_Ts_4_roll_off\n');
  endif
  if t(k)==-Ts/4/roll_off
    h(k)=h_Ts_4_roll_off;
    printf('-found h_Ts_4_roll_off\n');
  endif
end;

%Compensate gain
taps_sum = sum(h);
h = h/taps_sum;
  
  
end