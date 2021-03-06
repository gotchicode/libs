

function data_out = rom_generation(entity_name,rom_nb_cells,cell_size,values,mem_or_logic)


%Calcs
filename = [entity_name '.vhd']
rom_nb_cells_calc=floor(log2(rom_nb_cells));

%File write
fid=fopen(filename,'w');
fprintf(fid,'library IEEE;                                                                 \n');
fprintf(fid,'use IEEE.std_logic_1164.all;                                                  \n');
fprintf(fid,'use IEEE.numeric_std.all;                                                     \n');
fprintf(fid,'                                                                              \n');
fprintf(fid,'entity %s is                                                                  \n',entity_name);
fprintf(fid,' port (                                                                       \n');
fprintf(fid,'            clk             : in std_logic;                                   \n');
fprintf(fid,'            addr_in         : in std_logic_vector(%d downto 0);               \n',rom_nb_cells_calc-1);
fprintf(fid,'                                                                              \n');
fprintf(fid,'            data_out        : out std_logic_vector(%d downto 0)              \n',cell_size-1);
fprintf(fid,' );                                                                           \n');
fprintf(fid,'end entity %s;                                                                \n',entity_name);
fprintf(fid,'                                                                              \n');
fprintf(fid,'architecture rtl of %s is                                                     \n',entity_name);
fprintf(fid,'                                                                              \n');
fprintf(fid,'type ROM_type is array (0 to %d) of std_logic_vector(%d downto 0);            \n',2^(rom_nb_cells_calc)-1,cell_size-1);
fprintf(fid,'function init_rom                                                           \n');
fprintf(fid,'	return ROM_type is                                                       \n');
fprintf(fid,'	variable tmp : ROM_type := (others => (others => ''0''));                  \n');
fprintf(fid,'	begin                                                                    \n');
for k=1:rom_nb_cells
  fprintf(fid,'        tmp(%d) := std_logic_vector(to_signed(%d,%d));\n',k-1,values(k),cell_size);
end;
fprintf(fid,'	return tmp;                                                              \n');
fprintf(fid,'end init_rom;                                                               \n');
fprintf(fid,'signal ROM: ROM_type:=init_rom;                                                         \n');
fprintf(fid,'                                                                              \n');
fprintf(fid,'begin                                                                         \n');

##for k=1:rom_nb_cells
##  fprintf(fid,'ROM(%d) <= std_logic_vector(to_signed(%d,%d));\n',k-1,values(k),cell_size);
##end

%Never use
##for k=rom_nb_cells+1:2^(floor(log2(rom_nb_cells))+1)
##  fprintf(fid,'ROM(%d) <= std_logic_vector(to_signed(0,%d));\n',k-1,cell_size); 
##end

fprintf(fid,'                                                                              \n');
fprintf(fid,'process(clk)                                                                  \n');
fprintf(fid,'begin                                                                         \n');
fprintf(fid,'    if rising_edge(clk) then                                                  \n');

if mem_or_logic==0 %logic
  fprintf(fid,'            for I in 0 to %d loop                                             \n',2^(rom_nb_cells_calc)-1);
  fprintf(fid,'              if to_integer(unsigned(addr_in))=I then                         \n');
  fprintf(fid,'                data_out <= ROM(I);                                           \n');
  fprintf(fid,'              end if;                                                         \n');
  fprintf(fid,'            end loop;                                                         \n');
end

if mem_or_logic==1 %logic
  fprintf(fid,'            data_out <= ROM(to_integer(unsigned(addr_in)));                                           \n');
end

fprintf(fid,'    end if;                                                                   \n');
fprintf(fid,'end process;                                                                  \n');
fprintf(fid,'                                                                              \n');
fprintf(fid,'end rtl;                                                                      \n');

fclose(fid);
end
