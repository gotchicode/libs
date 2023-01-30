clear all;
close all;
clc;

%Parameters
nb_taps=20;
nb_quant=2^14;
cut_off=0.125;

%VHDL parameters
filename='fir_with_opt_accu.vhd';
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
compensate=64139.000000 / 32768.000000 ; %Here apply value from quant_taps_correct when compensate at 1
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
fprintf(fid,'entity fir_with_opt_accu is                                                                                            \n');
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
fprintf(fid,'end entity fir_with_opt_accu;                                                                                          \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'architecture rtl of fir_with_opt_accu is                                                                               \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'constant nb_taps                        : integer:=%d;                                                   \n',length(taps_quant));
fprintf(fid,'type taps_type                          is array (0 to nb_taps-1) of signed(%d downto 0);                \n',taps_size-1);
fprintf(fid,'signal taps                             : taps_type;                                                     \n');
fprintf(fid,'type fir_reg_type                       is array (0 to nb_taps-1) of signed(%d downto 0);                \n',data_in_bus_size-1);
fprintf(fid,'signal fir_reg                          : fir_reg_type:=(others=>(others=>''0''));                        \n');

for k=1:length(taps_quant)
  fprintf(fid,'signal fir_reg_d%d                          : fir_reg_type:=(others=>(others=>''0''));                        \n',k);
end

fprintf(fid,'type taps_x_fir_reg_type                is array (0 to nb_taps-1) of signed(%d downto 0);                \n',data_in_bus_size+taps_size-1);
fprintf(fid,'signal taps_x_fir_reg                   : taps_x_fir_reg_type;                                           \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'type taps_x_fir_reg_accu_type           is array (0 to nb_taps) of signed(63 downto 0);                  \n');
fprintf(fid,'signal taps_x_fir_reg_accu              : taps_x_fir_reg_accu_type:=(others=>(others=>''0'')); \n');
fprintf(fid,'signal taps_x_fir_reg_accu_en           : std_logic_vector(nb_taps-1 downto 0);                          \n');  
fprintf(fid,'                                                                                                         \n');
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
fprintf(fid,'            data_in_en_r2 <= data_in_en_r1;                                                                 \n');
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            --multiply                                                                                   \n');
fprintf(fid,'            --First tap                                                                                  \n');
fprintf(fid,'            taps_x_fir_reg_accu(0) <= resize(fir_reg(0) *  taps(0),64);                                  \n');
fprintf(fid,'            fir_reg_d1 <= fir_reg;                                                                       \n');
fprintf(fid,'            taps_x_fir_reg_accu_en(0)<= data_in_en_r2;                                                   \n');                          

fprintf(fid,'                                                                                                         \n');

for k=2:length(taps_quant)
  fprintf(fid,'            fir_reg_d%d <= fir_reg_d%d;                                                                 \n',k,k-1);
  fprintf(fid,'            taps_x_fir_reg(%d)           <= fir_reg_d%d(%d) *  taps(%d);                                                 \n',k-1,k-1,k-1,k-1);
  fprintf(fid,'            taps_x_fir_reg_accu(%d)      <= taps_x_fir_reg(%d) + taps_x_fir_reg_accu(%d);                                    \n',k-1,k-1,k-2);
  fprintf(fid,'            taps_x_fir_reg_accu_en(%d)   <= taps_x_fir_reg_accu_en(%d);                                  \n',k-1,k-2);
  fprintf(fid,'                                                                                                         \n');
end

fprintf(fid,'                                                                                                         \n');
fprintf(fid,'            v_round := ''0'' & taps_x_fir_reg_accu(%d)(%d);                                                     \n',k-1,quant_gain_log2-1);
fprintf(fid,'            data_out_prepare <= std_logic_vector(taps_x_fir_reg_accu(%d)(%d downto %d) + v_round);                                                                         \n',k-1,quant_gain_log2+data_out_bus_size-1,quant_gain_log2);
fprintf(fid,'            data_out_prepare_en <= taps_x_fir_reg_accu_en(%d);--;                                                    \n\n',k-1);
fprintf(fid,'                                                                                                         \n');
fprintf(fid,'       end if;                                                                                           \n');
fprintf(fid,'                                                                                                         \n');
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