

function h = gmsk_function(BT, Tb, L, k)

  B = BT/Tb;%bandwidth of the filter
  t=-k*Tb:Tb/L:k*Tb; %truncated time limits for the filter
  h = sqrt(2*pi*B^2/(log(2)))*exp(-t.^2*2*pi^2*B^2/(log(2)));
  h=h/sum(h);
  
end