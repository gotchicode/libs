
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture rtl of top_tb is

constant clk_const : time := 5 ns;

signal clk : std_logic;
signal data_in : std_logic;
signal data_out : std_logic_vector(3 downto 0);



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


    data_in <= '0';

    top_inst : entity work.top
    port map
        (
        clk => clk,
        data_in => data_in,
        data_out => data_out
);

end rtl;
