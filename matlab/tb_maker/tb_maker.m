clc
clear all
close all

%------------------------------
%-- Parameters
%------------------------------

%path_for_sources = './';
%path_for_testbench = './';
%path_for_sim_do = './';
%path_for_inside_do_src = './';
%path_for_inside_do_tb = './';
%filename = 'file.vhd';

path_for_sources = '../../vhdl/frame_synchronization/src/';
path_for_testbench = '../../vhdl/frame_synchronization/tb/';
path_for_sim_do = '../../vhdl/frame_synchronization/sim/';
path_for_inside_do_src = '../src/';
path_for_inside_do_tb = '../tb/';
filename = 'sync.vhd';

%------------------------------
%-- Read the file
%------------------------------
fid = fopen([path_for_sources filename],'r');
file_data=[];
while ~feof(fid)
    tline = fgetl(fid);
    file_data=[file_data; tline];
end
fclose(fid);
file_data_low_case = tolower(file_data);
clear tline fid file_data filename;

%------------------------------
%-- Remove comments
%------------------------------
file_data_low_case_new=[];
file_data_low_case_size = size(file_data_low_case);
for k=1:file_data_low_case_size(1)
 
  tmp = file_data_low_case(k,:);
  comment_index=strfind(tmp, '--');
  [comment_index_i comment_index_k] = size(comment_index);

  if comment_index_i>0 && comment_index_k>0
   
    if comment_index(1)==1
      %do not add
    elseif comment_index(1)>1
      file_data_low_case_new=[file_data_low_case_new; tmp(1:comment_index-1)];
    end
   
   else
      file_data_low_case_new=[file_data_low_case_new; tmp];
   end

end
file_data_low_case = file_data_low_case_new;
clear file_data_low_case_new comment_index tmp comment_index_i comment_index_k tmp;

%------------------------------
%-- In the same line
%------------------------------
file_data_low_case_new=[];
file_data_low_case_size = size(file_data_low_case);
for k=1:file_data_low_case_size(1)
  tmp = file_data_low_case(k,:);
  file_data_low_case_new =[file_data_low_case_new tmp];
end
file_data_low_case = file_data_low_case_new;
clear tmp file_data_low_case_size file_data_low_case_new k;

##%------------------------------
##%-- Remove generics
##%------------------------------
##%Find 'generic'
##index_generic=strfind(file_data_low_case, 'generic');
##index_bracket_last =strfind(file_data_low_case, ');');
##found_flag=0;
##for k=1:length(index_bracket_last)
##  if index_bracket_last(k)>index_generic(1) && found_flag==0
##    found_flag=1;
##    index_bracket_found=index_bracket_last(k);
##  end
##end
##
##%remove the generic from the code
##file_data_low_case=[file_data_low_case(1:index_generic-1) file_data_low_case(index_bracket_found+2:end)];
##clear k found_flag index_bracket_found index_bracket_last index_generic;

%------------------------------
%-- Parse to ports
%------------------------------

%Find 'entity'
index_entity=strfind(file_data_low_case, 'entity');
%Find 'is'
index_is=strfind(file_data_low_case, 'is');
%Find 'port'
index_port=strfind(file_data_low_case, 'port');
%Find '('
index_bracket_first=strfind(file_data_low_case, '(');
%Find ')'
index_bracket_last=strfind(file_data_low_case, ')');

%Find the end of entity
y=0;
y_d1=0;
y_table=[];
end_of_entity_flag=0;
for k=1:length(file_data_low_case)
    tmp = file_data_low_case(k);
    index_is_bracket_opening=strfind(tmp, '(');
    index_is_bracket_closing=strfind(tmp, ')');
    index_is_bracket_opening_size=length(index_is_bracket_opening);
    index_is_bracket_closing_size=length(index_is_bracket_closing);
   
    if index_is_bracket_opening_size>0
      %printf('( at %d \n',k);
      y=y+1;
    end
 
    if index_is_bracket_closing_size>0
      %printf(') at %d \n',k);
      y=y-1;
    end
   
    if y_d1>0 && y==0 && end_of_entity_flag==0
      %printf('end of entity at %d \n',k);
      end_of_entity_flag=1;
      index_end_of_entity=k;
    end
   
    y_table=[y_table y];
    y_d1=y;

end
clear y_d1 y_table end_of_entity_flag y index_is_bracket_opening_size index_is_bracket_opening_size;
clear index_is_bracket_closing index_is_bracket_opening tmp index_is_bracket_closing_size;


%Get name of entity
value_entity_name=strtrim(file_data_low_case(index_entity(1)+6:index_is(1)-1));

%Select data from port ( to )
ports_data = file_data_low_case(index_port(1):index_end_of_entity(1));
%Find '('
index_relative_bracket_first=strfind(ports_data, '(');
%Select data from ( to )
ports_data = ports_data(index_relative_bracket_first(1)+1:end-1);
%add a ; at the end
ports_data = [ports_data ';'];
clear index_bracket_last index_bracket_first index_entity index_is index_port index_relative_bracket_first index_end_of_entity;

%------------------------------
%-- Ports in rows
%------------------------------
%Find ';'
index_semicolon = strfind(ports_data, ';');
ports_data_row=[];
y=1;
for k=1:length(index_semicolon)
  tmp = ports_data(y:index_semicolon(k));
  y=index_semicolon(k)+1;
  ports_data_row=[ports_data_row; tmp];
end
ports_data_row=deblank(ports_data_row);
ports_data_row=strtrim(ports_data_row);
clear tmp y index_semicolon;

%------------------------------
%-- Get port Name Direction Type Init value
%------------------------------
size_ports_data_row=size(ports_data_row);
value_port_name=[];
value_port_direction=[];
value_port_type=[];
for k=1:size_ports_data_row(1)
  %Get a line
  tmp = ports_data_row(k,:);
 
  %Find port name
  index_name_end=strfind(tmp, ':');
  value_port_name=[value_port_name; strtrim(tmp(1:index_name_end-1))];
 
  %Find directions
  tmp_direction = strtrim(tmp(index_name_end+1:end));
  index_in  = strfind(tmp_direction, 'in');
  index_out = strfind(tmp_direction, 'out');
  index_inout = strfind(tmp_direction, 'inout');
  index_in_size=length(index_in);
  index_out_size=length(index_out);
  index_inout_size=length(index_inout);
 
  if index_in_size>0
    if index_in(1)==1
      value_port_direction=[value_port_direction; 'in'];
      tmp_type = tmp_direction(3:end);
    end
  end
  if index_out_size>0
    if index_out(1)==1
      value_port_direction=[value_port_direction; 'out'];
      tmp_type = tmp_direction(4:end);
    end
  end
  if index_inout_size>0
    if index_inout(1)==1
      value_port_direction=[value_port_direction; 'inout'];
      tmp_type = tmp_direction(6:end);
    end
  end
  clear index_in index_out index_inout index_in_size index_out_size index_inout_size index_name_end;
 
  %Find port std_logic_vector
  index_std_logic_vector = strfind(tmp_type, 'std_logic_vector');
 
  %Find port std_logic
  index_std_logic = strfind(tmp_type, 'std_logic');
 
  index_std_logic_vector_size= length(index_std_logic_vector);
  index_std_logic_size = length(index_std_logic);
 
  if index_std_logic_vector_size>0
    %printf('found std_logic_vector in %d\n',k);
    index_bracket_first = strfind(tmp_type, '(');
    index_bracket_last  = strfind(tmp_type, ')');
    index_downto = strfind(tmp_type, '(');
    value_port_type=[value_port_type; tmp_type(index_std_logic_vector:index_bracket_last)];
   
  elseif index_std_logic_size>0
    %printf('found std_logic in %d\n',k);
    value_port_type=[value_port_type; tmp_type(index_std_logic:index_std_logic+8)];
  else
    printf('Error: Non type found\n',k);
  end
 
end

clear index_bracket_first index_bracket_last index_downto index_std_logic index_std_logic_size
clear index_std_logic_vector index_std_logic_vector_size tmp tmp_direction tmp_type k ports_data

%Spaces
value_entity_name = deblank(strtrim(value_entity_name));
value_port_direction = deblank(strtrim(value_port_direction));
value_port_name = deblank(strtrim(value_port_name));
value_port_type = deblank(strtrim(value_port_type));

%------------------------------
%-- Menu Who is the clock
%------------------------------
printf('--------------------------\n');
printf('-- Select the clock port  \n');
printf('--------------------------\n');

%Print all ports
for k=1:size_ports_data_row(1)
  printf('%d : %s : %s %s \n', k, value_port_name(k,:), value_port_direction(k,:), value_port_type(k,:));
end

%Get selected port as a clock
input_result=0;
while(input_result<1 || input_result>size_ports_data_row(1))
  input_result = input ('Enter:');
end
value_clock_is=input_result;

%------------------------------
%-- Menu Who is the reset
%------------------------------
printf('--------------------------\n');
printf('-- Select the reset port  \n');
printf('--------------------------\n');
%Print all ports
for k=1:size_ports_data_row(1)
  printf('%d : %s : %s %s \n', k, value_port_name(k,:), value_port_direction(k,:), value_port_type(k,:));
end
printf('0 : No reset\n');

%Get selected port as a clock
input_result=-1;
while(input_result<0 || input_result>size_ports_data_row(1))
  input_result = input ('Enter:');
end
value_reset_is=input_result;

%------------------------------
%-- Create the testbench
%------------------------------
testbench_filename= [path_for_testbench value_entity_name '_tb.vhd'];
testbench_entity_name = [value_entity_name '_tb'];
testbench_clock_name = value_port_name(value_clock_is,:);
if value_reset_is>0
  testbench_reset_name = value_port_name(value_reset_is,:);
end

fid = fopen(testbench_filename,'w');

fprintf(fid,'\n');
fprintf(fid,'library ieee;\n');
fprintf(fid,'use ieee.std_logic_1164.all;\n');
fprintf(fid,'use ieee.numeric_std.all;\n');
fprintf(fid,'\n');
fprintf(fid,'entity %s is\n',strtrim(testbench_entity_name));
fprintf(fid,'end %s;\n',strtrim(testbench_entity_name));
fprintf(fid,'\n');
fprintf(fid,'architecture rtl of %s is\n',strtrim(testbench_entity_name));
fprintf(fid,'\n');
fprintf(fid,'constant %s_const : time := 5 ns;\n',strtrim(testbench_clock_name));
if value_reset_is>0
  fprintf(fid,'constant %s_const : time := 123 ns;\n',strtrim(testbench_reset_name));
end
fprintf(fid,'\n');
for k=1:size_ports_data_row(1)
 fprintf(fid,'signal %s : %s;\n',strtrim(value_port_name(k,:)),strtrim(value_port_type(k,:)));
end

fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
fprintf(fid,'\n');
fprintf(fid,'    -----------------------------------------\n');
fprintf(fid,'    -- %s generation\n',strtrim(value_port_name(value_clock_is,:)));
fprintf(fid,'    -----------------------------------------\n');
fprintf(fid,'    %s_gen_pr: process\n',strtrim(value_port_name(value_clock_is,:)));
fprintf(fid,'    begin\n');
fprintf(fid,"        %s <= '1';\n",strtrim(value_port_name(value_clock_is,:)));
fprintf(fid,'        wait for %s_const;\n',strtrim(testbench_clock_name));
fprintf(fid,'\n');
fprintf(fid,"        %s <= '0';\n",strtrim(value_port_name(value_clock_is,:)));
fprintf(fid,'        wait for %s_const;\n',strtrim(testbench_clock_name));
fprintf(fid,'    end process;\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

if value_reset_is>0
  fprintf(fid,'    -----------------------------------------\n');
  fprintf(fid,'    -- %s generation\n',strtrim(value_port_name(value_reset_is,:)));
  fprintf(fid,'    -----------------------------------------\n');
  fprintf(fid,'    %s_gen_pr:process\n',strtrim(value_port_name(value_reset_is,:)));
  fprintf(fid,'    begin\n');
  fprintf(fid,'\n');
  fprintf(fid,"        %s <= '1';\n",strtrim(value_port_name(value_reset_is,:)));
  fprintf(fid,'        wait for 1 us;\n');
  fprintf(fid,'\n');
  fprintf(fid,"        %s <= '0';\n",strtrim(value_port_name(value_reset_is,:)));
  fprintf(fid,'        wait for %s_const;\n',strtrim(testbench_reset_name));
  fprintf(fid,'\n');
  fprintf(fid,"        %s <= '1';\n",strtrim(value_port_name(value_reset_is,:)));
  fprintf(fid,'        wait;\n');
  fprintf(fid,'\n');
  fprintf(fid,'    end process;\n');
end

fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'    %s_inst : entity work.%s\n',strtrim(value_entity_name),strtrim(value_entity_name));
fprintf(fid,'    port map\n');
fprintf(fid,'        (\n');

for k=1:size_ports_data_row(1)
 
  if k==size_ports_data_row(1)
   fprintf(fid,'        %s => %s\n',strtrim(value_port_name(k,:)),strtrim(value_port_name(k,:)));
   fprintf(fid,');\n');
  else
   fprintf(fid,'        %s => %s,\n',strtrim(value_port_name(k,:)),strtrim(value_port_name(k,:)));
  end
 
end

fprintf(fid,'\n');
fprintf(fid,'end rtl;\n');

fclose(fid);

%------------------------------
%-- create the do file
%------------------------------
fid = fopen([path_for_sim_do 'compile.do'],'w');

fprintf(fid,'quit -sim\n');
fprintf(fid,'vlib work\n');
fprintf(fid,'\n');
fprintf(fid,'vcom -work work +acc=rn %s%s.vhd\n',path_for_inside_do_src,strtrim(value_entity_name));
fprintf(fid,'\n');
fprintf(fid,'vcom -work work +acc=rn %s%s_tb.vhd\n',path_for_inside_do_tb,strtrim(value_entity_name));
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'# Simulation launch\n');
fprintf(fid,'vsim -gui -t ps work.%s_tb\n',strtrim(value_entity_name));
fprintf(fid,'\n');
fprintf(fid,'add wave -position insertpoint sim:/%s_tb/*\n',strtrim(value_entity_name));
fprintf(fid,'add wave -position insertpoint sim:/%s_tb/%s_inst/*\n',strtrim(value_entity_name),strtrim(value_entity_name));
fprintf(fid,'\n');
fprintf(fid,'run 1 ms\n');


fclose(fid);