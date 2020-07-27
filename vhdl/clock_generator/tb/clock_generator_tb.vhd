
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_generator_tb is
end clock_generator_tb;

architecture rtl of clock_generator_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk                  : std_logic;
signal rst                  : std_logic;
signal conf_freq_in         : std_logic_vector(31 downto 0);
signal clock_out            : std_logic;
signal clock_phase_out      : std_logic_vector(31 downto 0);
signal pulse_out            : std_logic;
signal pulse_out_phase      : std_logic_vector(31 downto 0);



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
    stim_gen_pr:process
    begin

        conf_freq_in <= std_logic_vector(to_unsigned(integer(real(real(1562500)*real(4294967296.0)/real(100000000))),32));
        wait;

    end process;

    clock_generator_inst : entity work.clock_generator
    port map
        (
        clk             => clk,
        rst             => rst,
        conf_freq_in    => conf_freq_in,
        clock_out       => clock_out,
        clock_phase_out => clock_phase_out,
        pulse_out       => pulse_out,
        pulse_out_phase => pulse_out_phase
);

end rtl;
