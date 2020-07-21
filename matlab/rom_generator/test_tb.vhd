
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end test_tb;

architecture rtl of test_tb is

constant clk_const : time := 5 ns;

signal clk : std_logic;
signal addr_in : std_logic_vector(7 downto 0):=(others=>'0');
signal rd_en : std_logic;
signal data_out : std_logic_vector(31 downto 0);
signal data_out_en : std_logic;



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
    -- clk generation
    -----------------------------------------
    stim_pr: process
    begin
        
        rd_en <='0';
        wait until rising_edge(clk);
        addr_in <= std_logic_vector(unsigned(addr_in)+1);
        rd_en <='1';
        wait until rising_edge(clk);
        rd_en <='0';
        wait for 1 us;
    
    end process;

    test_inst : entity work.test
    port map
        (
        clk => clk,
        addr_in => addr_in,
        rd_en => rd_en,
        data_out => data_out,
        data_out_en => data_out_en
);

end rtl;
