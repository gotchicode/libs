function [ofdm_frame_struct,nb_data,nb_gsbcdc,nb_pl]=generate_ofdm_frame_struct(Nfft, Ngsbc, Ndc, Npilotspacing, Npilotspacingsymb2symb, Nsymbperframe)
  

  
ofdm_symbol_struct=ones(1,Nfft);
ofdm_symbol_struct(Nfft/2+1)=0; %DC
ofdm_symbol_struct(1:Ngsbc/2)=0; %Guard subcarriers
ofdm_symbol_struct(end-Ngsbc/2+1:end)=0; %Guard subcarriers

ofdm_frame_struct=zeros(Nsymbperframe,Nfft);
tmp=0;
for k=1:Nsymbperframe
  symb_with_pilot=mod(k-1,Npilotspacingsymb2symb)+1; %if one, add pilots inside the symbol
  
  if symb_with_pilot==1
    tmp++;
    pilot_pos_offset=mod(tmp-1,Npilotspacing)+1;
  end
  
  ind=0;
  ind_fill=0;
  if symb_with_pilot==1
    ofdm_symbol_struct_tmp = ofdm_symbol_struct;
    for index=1:Nfft
      if ofdm_symbol_struct_tmp(index)==1
        ind++;
        if ind>=pilot_pos_offset
          ind_fill++;
          if mod(ind_fill,Npilotspacing)==1
             ofdm_symbol_struct_tmp(index)=2; 
           end
        end
      end
    end
    ofdm_frame_struct(k,:)=ofdm_symbol_struct_tmp;
  else
    ofdm_frame_struct(k,:)=ofdm_symbol_struct;
  end;
end;

%Returns numbers
nb_data=0;
nb_gsbcdc=0;
nb_pl=0;
ofdm_frame_struct_size=size(ofdm_frame_struct);
for k=1:ofdm_frame_struct_size(1)
  for m=1:ofdm_frame_struct_size(2)
    
    if ofdm_frame_struct(k,m)==0 
      nb_gsbcdc++;
    end
    
    if ofdm_frame_struct(k,m)==1 
      nb_data++;
    end
    
    if ofdm_frame_struct(k,m)==2 
      nb_pl++;
    end
  end
end


##%Generate an output file
##fid=fopen('ofdm_frame_struct.html','w');
##  
##fclose(fid);

end
