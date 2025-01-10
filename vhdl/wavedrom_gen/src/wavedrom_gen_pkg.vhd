library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package wavedrom_gen_pkg is

    constant depth : integer:=64;
    constant data_width : integer:=32;
    constant name_width : integer:=32;
    constant array_depth : integer:=48;

    type data_bus is array (depth-1 downto 0) of std_logic_vector(data_width-1 downto 0);
    type  data_enable is array (depth-1 downto 0) of std_logic;
    type data_names is array (0 to depth) of string(1 to name_width);

    type array_data_bus is array (array_depth-1 downto 0) of data_bus;
    type array_data_enable is array (array_depth-1 downto 0) of data_enable;

end package wavedrom_gen_pkg;

package body wavedrom_gen_pkg is

end package body wavedrom_gen_pkg;