function [ofdm_frame_struct,nb_data,nb_gsbcdc,nb_pl]=generate_ofdm_frame_struct(Nfft, Ngsbc, Ndc, Npilotspacing, Npilotspacingsymb2symb, Nsymbperframe,Has_SW ,SW_symbols)
  
ofdm_SW_symbol_struct=ones(SW_symbols,Nfft);
ofdm_SW_symbol_struct = ones(SW_symbols, Nfft) + 3; % initialize all to 4
ofdm_SW_symbol_struct(:, Nfft/2) = 0; % DC
ofdm_SW_symbol_struct(:, 1:Ngsbc/2) = 0; % Guard band (start)
ofdm_SW_symbol_struct(:, end - Ngsbc/2 + 1:end) = 0; % Guard band (end)
  
ofdm_symbol_struct=ones(1,Nfft);
ofdm_symbol_struct(Nfft/2)=0; %DC
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

%Add the SW_symbols
if Has_SW==1
  ofdm_frame_struct = [ofdm_SW_symbol_struct; ofdm_frame_struct];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generation of the ofdm frame in html file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generate an output HTML file
fid = fopen('ofdm_frame_struct.html', 'w');

fprintf(fid, '<!DOCTYPE html>\n<html>\n<head>\n<title>OFDM Frame Structure</title>\n');
fprintf(fid, '<style>\n');
fprintf(fid, 'table { border-collapse: collapse; font-family: monospace; }\n');
fprintf(fid, 'td, th { border: 1px solid #ccc; text-align: center; width: 25px; height: 25px; }\n');
fprintf(fid, '.type0 { background-color: #f8d7da; }  /* Guard/DC - red tint */\n');
fprintf(fid, '.type1 { background-color: #d4edda; }  /* Data - green tint */\n');
fprintf(fid, '.type2 { background-color: #cce5ff; }  /* Pilot - blue tint */\n');
fprintf(fid, '.type4 { background-color: #fff3cd; }  /* Sync - yellow tint */\n');
fprintf(fid, '</style>\n</head>\n<body>\n');

fprintf(fid, '<h2>OFDM Frame Structure</h2>\n');

fprintf(fid, '<p><strong>Legend:</strong></p>\n');
fprintf(fid, '<ul>\n');
fprintf(fid, '<li><span style="background-color:#f8d7da; padding: 2px 6px;">0</span> = Guard/DC</li>\n');
fprintf(fid, '<li><span style="background-color:#d4edda; padding: 2px 6px;">1</span> = Data</li>\n');
fprintf(fid, '<li><span style="background-color:#cce5ff; padding: 2px 6px;">2</span> = Pilot</li>\n');
fprintf(fid, '<li><span style="background-color:#fff3cd; padding: 2px 6px;">4</span> = Synchronization Word</li>\n');
fprintf(fid, '</ul>\n');

fprintf(fid, '<table>\n');

% Header row: subcarrier indices
fprintf(fid, '<tr><th></th>'); % Empty corner cell
for subcarrier = 1:Nfft
    fprintf(fid, '<th>%d</th>', subcarrier);
end
fprintf(fid, '</tr>\n');

% Table body
for symb = 1:size(ofdm_frame_struct, 1)
    fprintf(fid, '<tr><th>%d</th>', symb); % Symbol number on Y-axis
    for subc = 1:Nfft
        val = ofdm_frame_struct(symb, subc);
        fprintf(fid, '<td class="type%d">%d</td>', val, val);
    end
    fprintf(fid, '</tr>\n');
end

fprintf(fid, '</table>\n</body>\n</html>\n');
fclose(fid);


end
