
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de0_top_tb is
end de0_top_tb;

architecture rtl of de0_top_tb is

constant clock_50_const : time := 20 ns;

signal clock_50 : std_logic;
signal clock_50_2 : std_logic;
signal button : std_logic_vector(2 downto 0);
signal sw : std_logic_vector(9 downto 0);
signal ledg : std_logic_vector(9 downto 0);


begin

    -----------------------------------------
    -- clock_50 generation
    -----------------------------------------
    clock_50_gen_pr: process
    begin
        clock_50 <= '1';
        wait for clock_50_const;

        clock_50 <= '0';
        wait for clock_50_const;
    end process;
    
    button  <= (others=>'0');
    sw      <= (others=>'0');

    de0_top_inst : entity work.de0_top
    port map
        (
        clock_50 => clock_50,
        clock_50_2 => clock_50_2,
        button => button,
        sw => sw,
        ledg => ledg
);

end rtl;
