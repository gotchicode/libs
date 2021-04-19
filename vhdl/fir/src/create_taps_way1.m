clear all;
close all;
clc;

%Parameters
nb_taps=7;
nb_quant=2^14;
cut_off=0.125;

%VHDL parameters
filename='fir_with_tree.vhd';
data_in_bus_size=12;
data_out_bus_size=12;
taps_size=log2(nb_quant);

%calculate Filter
f = [0 cut_off cut_off 1];
mhi = [1 1 0 0];
taps_ideal = fir2(nb_taps,f,mhi);

%ideal
h_ideal=freqz(taps_ideal,1,512);
h_ideal_dB=20*log10(abs(h_ideal));

%Quantified
compensate=31760.000000 / 16384.000000 ; %Here apply value from quant_taps_correct when compensate at 1
taps_quant= round( [ (nb_quant/2-1) / max(taps_ideal) * taps_ideal/compensate] );
h_quant=freqz(taps_quant,1,512);
h_quant_dB=20*log10(abs(h_quant));

%Identify the gain
quant_gain_lin=10^(max(h_quant_dB)/20);
quant_gain_log2=log2(quant_gain_lin);
quant_gain_lin_floor=2^floor(quant_gain_log2);
quant_taps_correct=quant_gain_lin/quant_gain_lin_floor;

%Display
figure(1);
plot(h_ideal_dB);
figure(2);
plot(h_quant_dB);

%Generate taps
##fid = fopen('taps.txt','w');
##for k=1:length(taps_quant)
##  fprintf(fid,'taps(%d) <= to_signed(%d,%d);\n',k-1,taps_quant(k),log2(nb_quant));
##end
##
##fclose(fid);

%----------------------------------------------------------
% Generate VHDL
%----------------------------------------------------------
fid=fopen(filename,'w');

fprintf(fid,'library IEEE;                                                                                            \n');
fprintf(fid,'use IEEE.std_logic_1164.all;                                                                             \n');
fprintf(fid,'use IEEE.numeric_std.all;                                                                                \n');
fprintf(fid,'use     ieee.math_real.all;                                                                              \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'entity fir_with_tree is                                                                                            \n');
fprintf(fid,' port (                                                                                                  \n');
fprintf(fid,'            clk             : in std_logic;                                                              \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            data_in         : in std_logic_vector(%d downto 0);                                          \n',data_in_bus_size-1);
fprintf(fid,'            data_in_en      : in std_logic;                                                              \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'			data_out		: out std_logic_vector(%d downto 0);                                          \n',data_out_bus_size-1);
fprintf(fid,'			data_out_en		: out std_logic                                                               \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,' );                                                                                                      \n');
fprintf(fid,'end entity fir_with_tree;                                                                                          \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'architecture rtl of fir_with_tree is                                                                               \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'constant nb_taps                        : integer:=%d;                                                   \n',length(taps_quant));
fprintf(fid,'type taps_type                          is array (0 to nb_taps-1) of signed(%d downto 0);                \n',taps_size-1);
fprintf(fid,'signal taps                             : taps_type;                                                     \n');
fprintf(fid,'type fir_reg_type                       is array (0 to nb_taps-1) of signed(%d downto 0);                \n',data_in_bus_size-1);
fprintf(fid,'signal fir_reg                          : fir_reg_type:=(others=>(others=>''0''));                        \n');
fprintf(fid,'type taps_x_fir_reg_type                is array (0 to nb_taps-1) of signed(%d downto 0);                \n',data_in_bus_size+taps_size-1);
fprintf(fid,'signal taps_x_fir_reg                   : taps_x_fir_reg_type;                                           \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'type adder_tree_subtype                 is array (0 to nb_taps) of signed(63 downto 0);                  \n');
fprintf(fid,'type adder_tree_type                    is array (0 to nb_taps-1) of adder_tree_subtype;                 \n');
fprintf(fid,'signal adder_tree                       : adder_tree_type:=(others=>(others=>(others=>''0'')));          \n');
fprintf(fid,'signal adder_tree_en                    : std_logic_vector(nb_taps-1 downto 0);                          \n');  
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'signal data_in_en_r1               : std_logic;                                                          \n');
fprintf(fid,'signal data_in_en_r2               : std_logic;                                                          \n');
fprintf(fid,'signal data_in_en_r3               : std_logic;                                                          \n');
fprintf(fid,'signal data_out_prepare            : std_logic_vector(%d downto 0);                                      \n',data_out_bus_size-1);
fprintf(fid,'signal data_out_prepare_en         : std_logic;                                                          \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'begin                                                                                                    \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'    ------------------------------------------                                                           \n');
fprintf(fid,'    -- Fir implementation                                                                                \n');
fprintf(fid,'    ------------------------------------------                                                           \n');
fprintf(fid,'    process(clk)                                                                                         \n');
fprintf(fid,'    variable v_round : signed(1 downto 0);                                                               \n');
fprintf(fid,'    begin                                                                                                \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'        if rising_edge(clk) then                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            --shift registers                                                                            \n');
fprintf(fid,'            if data_in_en=''1'' then                                                                     \n');
fprintf(fid,'                fir_reg(0) <= signed(data_in);                                                           \n');
fprintf(fid,'                for I in 1 to nb_taps-1 loop                                                             \n');
fprintf(fid,'                       fir_reg(I) <= fir_reg(I-1);                                                       \n');
fprintf(fid,'                    end loop;                                                                            \n');
fprintf(fid,'            end if;                                                                                      \n');
fprintf(fid,'            data_in_en_r1 <= data_in_en;                                                                 \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            --multiply                                                                                   \n');
fprintf(fid,'            for I in 0 to nb_taps-1 loop                                                                 \n');
fprintf(fid,'                taps_x_fir_reg(I) <= fir_reg(I) * taps(I); -- %d + %d = %d bits                          \n',data_in_bus_size,taps_size,data_in_bus_size+taps_size);
fprintf(fid,'            end loop;                                                                                    \n');
fprintf(fid,'            data_in_en_r2 <= data_in_en_r1;                                                              \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            --Pipe                                                                                       \n');
fprintf(fid,'            for I in 0 to nb_taps-1 loop                                                                 \n');
fprintf(fid,'                adder_tree(0)(I)         <= resize(taps_x_fir_reg(I),64);                                \n');
fprintf(fid,'            end loop;                                                                                    \n');
fprintf(fid,'            data_in_en_r3 <= data_in_en_r2;                                                              \n');
fprintf(fid,'                                                                                                         \n');

%Generation of the adder tree
K = nb_taps;
s = 0;
while(K > 2)

  for I=0:(K/2)
    %fprintf('s=%d I=%d I=%d\n',s,I*2,(I*2)+1);
    fprintf(fid,'            adder_tree(%d)(%d) <= adder_tree(%d)(%d) + adder_tree(%d)(%d); --%d bits \n',s+1,I,s,I*2,s,(I*2)+1,data_in_bus_size+taps_size+s+1);
  end;
  s=s+1;
  K=ceil(K/2);
end
fprintf(fid,'            adder_tree(%d)(%d) <= adder_tree(%d)(%d) + adder_tree(%d)(%d);\n',s+1,0,s,0,s,1);

%Connect the adder to the output
fprintf(fid,'                                                                                                         \n');
%fprintf(fid,' data_out <= std_logic_vector(adder_tree(%d)(%d));                                                                         \n',s+1,0);
fprintf(fid,'            v_round := ''0'' & adder_tree(%d)(0)(%d);                                                     \n',s+1,quant_gain_log2-1);
fprintf(fid,'            data_out_prepare <= std_logic_vector(adder_tree(%d)(%d)(%d downto %d) + v_round);                                                                         \n',s+1,0,quant_gain_log2+data_out_bus_size-1,quant_gain_log2);
fprintf(fid,'            data_out_prepare_en <= adder_tree_en(%d);                                                    \n',s+1);
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            adder_tree_en(0) <= data_in_en_r2;                                                           \n');
fprintf(fid,'            adder_tree_en(nb_taps-1 downto 1) <= adder_tree_en(nb_taps-2 downto 0);                      \n');
fprintf(fid,'                                                                                                         \n');
%End the process
fprintf(fid,'       end if;                                                                                           \n');
fprintf(fid,'    end process;                                                                                         \n');

fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,' data_out     <= data_out_prepare;                                                                       \n');
fprintf(fid,' data_out_en  <= data_out_prepare_en;                                                                    \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');

%Prints taps to the file
for k=1:length(taps_quant)
  fprintf(fid,' taps(%d) <= to_signed(%d,%d);\n',k-1,taps_quant(k),log2(nb_quant));
end;

%End RTL
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,' end rtl;                                                                                                \n');

fclose(fid);

fprintf('!!!!!!! Check that everything is ok with gain !!!!!!!!!!!!!\n');
fprintf('%f / %f\n', quant_gain_lin,quant_gain_lin_floor);
fprintf('\n');

if mod(length(taps_ideal),2)==1
  fprintf('!!!!!!! Error, the number of taps is odd !!!!!!!!!!!!!\n');
end