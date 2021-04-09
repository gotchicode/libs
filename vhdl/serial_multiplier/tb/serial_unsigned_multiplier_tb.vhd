
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_unsigned_multiplier_tb is
end serial_unsigned_multiplier_tb;

architecture rtl of serial_unsigned_multiplier_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

constant nb_bits    : integer := 32;

signal clk : std_logic;
signal rst : std_logic;
signal data_a_in : std_logic_vector(nb_bits-1 downto 0);
signal data_b_in : std_logic_vector(nb_bits-1 downto 0);
signal data_in_en : std_logic;
signal data_out : std_logic_vector(nb_bits+nb_bits-1 downto 0);
signal data_out_en : std_logic;
signal busy : std_logic;



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
    -- Signal gen
    -----------------------------------------
    data_gen_pr:process
    begin
    
        data_a_in   <= std_logic_vector(to_unsigned(4096,nb_bits));
        data_b_in   <= std_logic_vector(to_unsigned(4096,nb_bits));
        data_in_en  <= '0';
        
        wait for 100 us;
        
        wait until rising_edge(clk);
        data_in_en  <= '1';
        
        wait until rising_edge(clk);
        data_in_en  <= '0';
 
        wait;

    end process;


    serial_unsigned_multiplier_inst : entity work.serial_unsigned_multiplier
    generic map( nb_bits => nb_bits)
    port map
        (
        clk => clk,
        rst => rst,
        data_a_in => data_a_in,
        data_b_in => data_b_in,
        data_in_en => data_in_en,
        data_out => data_out,
        data_out_en => data_out_en,
        busy => busy
);

end rtl;
