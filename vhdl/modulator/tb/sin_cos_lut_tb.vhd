
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity sin_cos_lut_tb is
end sin_cos_lut_tb;

architecture rtl of sin_cos_lut_tb is

constant clk_const                   : time := 5 ns;
constant rst_const                   : time := 123 ns;

constant phase_in_size               : integer:=4096;
constant phase_in_bit_size           : integer:=12;
constant sin_cos_data_size           : integer:=12;

signal clk                           : std_logic;
signal rst                           : std_logic;
signal phase_in_en                   : std_logic;
signal phase_in                      : std_logic_vector(phase_in_bit_size-1 downto 0);
signal sin_out                       : std_logic_vector(sin_cos_data_size-1 downto 0);
signal cos_out                       : std_logic_vector(sin_cos_data_size-1 downto 0);
signal sin_out_en                    : std_logic;

signal tick_in                       : std_logic;



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
    -- Input  generation
    -----------------------------------------
    input_pr:process
    variable I : integer:=0;
    begin
        -- init
        phase_in_en     <= '0';
        phase_in        <= (others=>'0');

        -- wait for reset
        wait until falling_edge(rst);
        wait until rising_edge(clk);


        --for I in 1 to (2**n_bits_phase)-1 loop 
        while (I<phase_in_size) loop

            wait until rising_edge(clk);
            phase_in_en <='1';
            phase_in <= std_logic_vector(to_unsigned(I,phase_in_bit_size));
            wait until rising_edge(clk);
            phase_in_en <='0';

            --wait
            wait for 0.1 us;

            --step
            I := I + 1;

        end loop;

        wait for 1 us;
        stop;

    end process;

    sin_cos_lut_inst : entity work.sin_cos_lut
    generic map(
        phase_in_size       => phase_in_size,
        phase_in_bit_size   => phase_in_bit_size,
        sin_cos_data_size   => sin_cos_data_size
    )
    port map
        (
        clk             => clk,
        rst             => rst,
        phase_in_en     => phase_in_en,
        phase_in        => phase_in,
        sin_out         => sin_out,
        cos_out         => cos_out,
        sin_out_en      => sin_out_en
);

end rtl;
