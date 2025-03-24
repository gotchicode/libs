library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package reduced_msb_mult_pkg is

constant C_MAX_NB_ELEMENTS : integer:=13;
constant C_MAX_BIT_WIDTH   : integer:=32;
type data_array is array (0 to C_MAX_NB_ELEMENTS-1) of std_logic_vector(C_MAX_BIT_WIDTH-1 downto 0);
type data_array_array is array (0 to C_MAX_NB_ELEMENTS-1) of data_array;
end package reduced_msb_mult_pkg;

package body reduced_msb_mult_pkg is
end package body reduced_msb_mult_pkg;