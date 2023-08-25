function [ted_out, ted_out_en] = gardner_ted(data_in_early, data_in_prompt, data_in_late)
  
  ted_out=0;
  ted_out_en=0;
  
  %Real
    if (real(data_in_late)>0 && real(data_in_early)<0)
      ted_out=real(data_in_prompt) * (real(data_in_late) - real(data_in_early));
      ted_out_en=1;
    end
    
    if (real(data_in_late)<0 && real(data_in_early)>0)
      ted_out=real(data_in_prompt) * (real(data_in_late) - real(data_in_early));
      ted_out_en=1;
    end

  %Imag
    if (imag(data_in_late)>0 && imag(data_in_early)<0)
      ted_out= ted_out + imag(data_in_prompt) * (imag(data_in_late) - imag(data_in_early));
      ted_out_en=ted_out_en+1;
    end
    
    if (imag(data_in_late)<0 && imag(data_in_early)>0)
      ted_out= ted_out + imag(data_in_prompt) * (imag(data_in_late) - imag(data_in_early));
      ted_out_en=ted_out_en+1;
    end
    
    if ted_out_en==0
      
    end
    
    if ted_out_en==1
      ted_out = ted_out;
    end
    
    if ted_out_en==2
      ted_out = ted_out/2;
    end

  
end