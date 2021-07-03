
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rates_builder_tb is
end rates_builder_tb;

architecture rtl of rates_builder_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal sample_rate : std_logic_vector(31 downto 0);
signal sample_bit_ratio : std_logic_vector(15 downto 0);
signal symbol_bit_ratio : std_logic_vector(7 downto 0);
signal bit_request : std_logic;
signal bit_en : std_logic;
signal bit_in : std_logic;
signal rf_on_off_in : std_logic;
signal modu_on_off_in : std_logic;
signal bit_en_ack : std_logic;
signal bit_out : std_logic;
signal bit_out_en : std_logic;
signal symbol_out_en : std_logic;
signal sample_out_en : std_logic;
signal sample_instant : std_logic_vector(31 downto 0);



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
    -- Configuration
    -----------------------------------------
    sample_rate             <= std_logic_vector(to_unsigned(integer(real(real(1000000)*real(4294967296.0)/real(100000000))),32));
    sample_bit_ratio        <= std_logic_vector(to_unsigned(32-1,16));
    symbol_bit_ratio        <= std_logic_vector(to_unsigned(1,8));

    rates_builder_inst : entity work.rates_builder
    port map
        (
        clk => clk,
        rst => rst,
        sample_rate => sample_rate,
        sample_bit_ratio => sample_bit_ratio,
        symbol_bit_ratio => symbol_bit_ratio,
        bit_request => bit_request,
        bit_en => bit_en,
        bit_in => bit_in,
        rf_on_off_in => rf_on_off_in,
        modu_on_off_in => modu_on_off_in,
        bit_en_ack => bit_en_ack,
        bit_out => bit_out,
        bit_out_en => bit_out_en,
        symbol_out_en => symbol_out_en,
        sample_out_en => sample_out_en,
        sample_instant => sample_instant
);

end rtl;
