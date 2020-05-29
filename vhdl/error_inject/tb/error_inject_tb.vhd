
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity error_inject_tb is
end error_inject_tb;

architecture rtl of error_inject_tb is

constant clk_const : time := 5 ns;
constant rst_n_const : time := 123 ns;

constant const_all_ones : std_logic_vector(63 downto 0):=x"FFFFFFFFFFFFFFFF";
constant const_all_zeros : std_logic_vector(63 downto 0):=x"0000000000000000";

constant bit_size       : integer:=32;

signal clk : std_logic;
signal rst_n : std_logic;
signal error_rate : std_logic_vector(31 downto 0);
signal error_rate_on_off : std_logic;
signal data_in : std_logic_vector(bit_size-1 downto 0);
signal data_in_en : std_logic;
signal data_out : std_logic_vector(bit_size-1 downto 0);
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
    -- rst_n generation
    -----------------------------------------
    rst_n_gen_pr:process
    begin

        rst_n <= '1';
        wait for 1 us;

        rst_n <= '0';
        wait for rst_n_const;

        rst_n <= '1';
        wait;

    end process;
    
    -----------------------------------------
    -- stim generation
    -----------------------------------------
    stim_gen_pr:process
    begin

        data_in    <= (others=>'0');
        data_in_en <= '0';
        
        error_rate_on_off   <= '1';
        error_rate          <= std_logic_vector(to_unsigned(1000,32)); 
        
        wait for 500 us;
        wait until rising_edge(clk);

        for I in 0 to 65000 loop
            wait until rising_edge(clk);
            data_in    <= const_all_ones(bit_size-1 downto 0);
            data_in_en <= '1';
            wait until rising_edge(clk);
         
            data_in_en <= '0';
            
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
         
        end loop;
        
        wait until rising_edge(clk);
        error_rate_on_off   <= '0';
        
        for I in 0 to 65000 loop
            wait until rising_edge(clk);
            data_in    <= const_all_ones(bit_size-1 downto 0);
            data_in_en <= '1';
            wait until rising_edge(clk);
         
            data_in_en <= '0';
            
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
         
        end loop;

        wait;

    end process;


    error_inject_inst : entity work.error_inject
    generic map(
        bit_size =>bit_size
        )
    port map
        (
        clk => clk,
        rst_n => rst_n,
        error_rate => error_rate,
        error_rate_on_off => error_rate_on_off,
        data_in => data_in,
        data_in_en => data_in_en,
        data_out => data_out,
        data_out_en => data_out_en
);

end rtl;