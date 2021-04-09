
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_unsigned_multiplier_wrapper is
port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    data_a_in   : in  std_logic_vector(32-1 downto 0);
    data_b_in   : in  std_logic_vector(32-1 downto 0);
    data_in_en  : in  std_logic;
    data_out    : out std_logic_vector(32+32-1 downto 0);
    data_out_en : out std_logic;
    busy        : out std_logic
);
end serial_unsigned_multiplier_wrapper;

architecture rtl of serial_unsigned_multiplier_wrapper is

--wrap in signals
signal wrap_in_data_a_in : std_logic_vector(32-1 downto 0);
signal wrap_in_data_b_in : std_logic_vector(32-1 downto 0);
signal wrap_in_data_in_en : std_logic;

--wrap out signals
signal wrap_out_data_out : std_logic_vector(32+32-1 downto 0);
signal wrap_out_data_out_en : std_logic;
signal wrap_out_busy : std_logic;
begin

-----------------------------------------
--Wrap process
-----------------------------------------
wrap_pr: process(clk)          
begin                            
    if rising_edge(clk) then      

        --wrap in 
        wrap_in_data_a_in <= data_a_in;
        wrap_in_data_b_in <= data_b_in;
        wrap_in_data_in_en <= data_in_en;

        --wrap out 
        data_out <= wrap_out_data_out;
        data_out_en <= wrap_out_data_out_en;
        busy <= wrap_out_busy;
    end if;                      
end process;                     


    serial_unsigned_multiplier_inst : entity work.serial_unsigned_multiplier
    generic map ( nb_bits => 32)
    port map
        (
        clk => clk,
        rst => rst,
        data_a_in => wrap_in_data_a_in,
        data_b_in => wrap_in_data_b_in,
        data_in_en => wrap_in_data_in_en,
        data_out => wrap_out_data_out,
        data_out_en => wrap_out_data_out_en,
        busy => wrap_out_busy
);

end rtl;
