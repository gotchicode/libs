
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mapper_tb is
end mapper_tb;

architecture rtl of mapper_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal bit_in : std_logic;
signal bit_in_en : std_logic;
signal symbol_in_en : std_logic;
signal sample_in_en : std_logic;
signal sample_instant_in : std_logic_vector(31 downto 0);
signal phase_mod_incr : std_logic_vector(31 downto 0);
signal symbol_out : std_logic_vector(31 downto 0);
signal symbol_out_en : std_logic;
signal sample_out_en : std_logic;
signal sample_instant_out : std_logic_vector(31 downto 0);
signal rf_on_off_out : std_logic;
signal modu_on_off_out : std_logic;
signal power_level_out : std_logic_vector(15 downto 0);
signal phase_out : std_logic_vector(31 downto 0);

signal tick_in          : std_logic;
signal pattern_register : std_logic_vector(31 downto 0);



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
    -- Input tick generation
    -----------------------------------------
    tick_gen_pr:process
    begin

    tick_in     <= '0';
    wait for 1 us;
    wait until rising_edge(clk);
    tick_in     <= '1';
    wait until rising_edge(clk);
    tick_in     <= '0';

    end process;
    


    mapper_inst : entity work.mapper
    port map
        (
        clk => clk,
        rst => rst,
        bit_in => bit_in,
        bit_in_en => bit_in_en,
        symbol_in_en => symbol_in_en,
        sample_in_en => sample_in_en,
        sample_instant_in => sample_instant_in,
        phase_mod_incr => phase_mod_incr,
        symbol_out => symbol_out,
        symbol_out_en => symbol_out_en,
        sample_out_en => sample_out_en,
        sample_instant_out => sample_instant_out,
        rf_on_off_out => rf_on_off_out,
        modu_on_off_out => modu_on_off_out,
        power_level_out => power_level_out,
        phase_out => phase_out
);

end rtl;
