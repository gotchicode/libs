
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_master_tx_tb is
end i2s_master_tx_tb;

architecture rtl of i2s_master_tx_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal data_in : std_logic_vector(32-1 downto 0);
signal data_in_en : std_logic;
signal mclk_out : std_logic;
signal lrclk_out : std_logic;
signal sclk_out : std_logic;
signal sd_out : std_logic;



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


    i2s_master_tx_inst : entity work.i2s_master_tx
    port map
        (
        clk => clk,
        rst => rst,
        data_in => data_in,
        data_in_en => data_in_en,
        mclk_out => mclk_out,
        lrclk_out => lrclk_out,
        sclk_out => sclk_out,
        sd_out => sd_out
);

end rtl;
