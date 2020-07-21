
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gain_mult_tb is
end gain_mult_tb;

architecture rtl of gain_mult_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk                  : std_logic;
signal rst                  : std_logic;
signal data_in              : std_logic_vector(31 downto 0);
signal data_in_en           : std_logic;
signal gain_exponent_begin  : std_logic_vector(3 downto 0);
signal gain_exponent_end    : std_logic_vector(3 downto 0);
signal gain_mult            : std_logic_vector(17 downto 0);
signal data_out             : std_logic_vector(56 downto 0);
signal data_out_en          : std_logic;


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
    
    -----------------------------------------
    -- Stim
    -----------------------------------------
    stim_pr:process
    begin
    
        data_in             <= x"00001000";
        gain_exponent_begin <= x"0";
        gain_exponent_end   <= x"0";
        gain_mult           <= "00" & x"0001";
        data_in_en          <= '0';
        wait for 10 us;
        wait until rising_edge(clk);
        data_in_en          <= '1';
        wait until rising_edge(clk);
        data_in_en          <= '0';
        
        wait for 1 us;
        wait until rising_edge(clk);
        data_in             <= x"00001000";
        gain_exponent_begin <= x"2";
        gain_exponent_end   <= x"0";
        gain_mult           <= "00" & x"0001";
        data_in_en          <= '1';
        wait until rising_edge(clk);
        data_in_en          <= '0';
        
        wait for 1 us;
        wait until rising_edge(clk);
        data_in             <= x"00001000";
        gain_exponent_begin <= x"E";
        gain_exponent_end   <= x"0";
        gain_mult           <= "00" & x"0001";
        data_in_en          <= '1';
        wait until rising_edge(clk);
        data_in_en          <= '0';
        
        wait;

    end process;


    gain_mult_inst : entity work.gain_mult
    port map
        (
        clk                 => clk,
        rst                 => rst,
        data_in             => data_in,
        data_in_en          => data_in_en,
        gain_exponent_begin => gain_exponent_begin,
        gain_exponent_end   => gain_exponent_end,
        gain_mult           => gain_mult,
        data_out            => data_out,
        data_out_en         => data_out_en
);

end rtl;
