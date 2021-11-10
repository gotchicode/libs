
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_map_top_tb is
end memory_map_top_tb;

architecture rtl of memory_map_top_tb is

constant clk_const : time := 5 ns;
constant addr_width : integer := 7;
constant data_width : integer := 32;

signal clk : std_logic;
signal addr : std_logic_vector(addr_width-1 downto 0);
signal wr_en : std_logic;
signal rd_en : std_logic;
signal data_write : std_logic_vector(data_width-1 downto 0);
signal data_read : std_logic_vector(data_width-1 downto 0);



begin

    -----------------------------------------
    -- clk generation
    -----------------------------------------
    clk_gen_pr: process
    begin
        clk <= '1';
        wait for clk_const;

        clk <= '0';
        wait for clk_const;
    end process;




    memory_map_top_inst : entity work.memory_map_top
    port map
        (
        clk => clk,
        addr => addr,
        wr_en => wr_en,
        rd_en => rd_en,
        data_write => data_write,
        data_read => data_read
);

end rtl;
