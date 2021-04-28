
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_generator_tb is
end clock_generator_tb;

architecture rtl of clock_generator_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal rst : std_logic;
signal clk : std_logic;
signal clock_out : std_logic;



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


    -----------------------------------------
    -- rst generation
    -----------------------------------------
    rst_gen_pr:process
    begin

        rst <= '0';
        wait for 1 us;

        rst <= '1';
        wait for rst_const;

        rst <= '0';
        wait;

    end process;


    clock_generator_inst : entity work.clock_generator
    port map
        (
        rst => rst,
        clk => clk,
        clock_out => clock_out
);

end rtl;
