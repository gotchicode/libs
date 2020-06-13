
function [taps_raw_quant,taps_quant] =  taps_to_pw2(taps,nb_iter)

taps_raw_quant=[];
taps_sign=[];
taps_quant=[];
for m=1:length(taps)
    sample=taps(m);
    fprintf('sample=%f\n',sample);
    if sample>0
      sample = sample;
      sample_sign=1;
    else
      sample = abs(sample);
      sample_sign=-1;
    end;
      
    sample_quant=[];
    for k=1:nb_iter
      sample_log=log2(sample);
      floor_coeff=floor(sample_log);
      rest=sample-2^floor_coeff;
      fprintf('floor_coeff=%d rest=%f\n',floor_coeff,rest);
      sample= rest;
      sample_quant=[sample_quant floor_coeff];
    end
    taps_raw_quant=[taps_raw_quant; sample_quant];
    taps_sign=[taps_sign sample_sign];

    taps_quant_tmp=0;
    for k=1:length(sample_quant)
      taps_quant_tmp = taps_quant_tmp-2^(sample_quant(k));
    end
    taps_quant=[taps_quant abs(taps_quant_tmp)*sample_sign];
    fprintf('taps_quant_tmp=%f\n',abs(taps_quant_tmp)*sample_sign); 
    fprintf('\n');
end

end
