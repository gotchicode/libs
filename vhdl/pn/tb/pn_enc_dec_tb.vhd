
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pn_enc_dec_tb is
end pn_enc_dec_tb;

architecture rtl of pn_enc_dec_tb is

constant clk_const      : time := 5 ns;
constant rst_n_const    : time := 123 ns;

constant const_all_ones : std_logic_vector(63 downto 0):=x"FFFFFFFFFFFFFFFF";
constant const_all_zeros : std_logic_vector(63 downto 0):=x"0000000000000000";

constant bit_size       : integer:=32;

signal clk : std_logic;
signal rst_n : std_logic;
signal enc_data_in : std_logic_vector(bit_size-1 downto 0);
signal enc_data_in_en : std_logic;
signal enc_data_out : std_logic_vector(bit_size-1 downto 0);
signal enc_data_out_en : std_logic;
signal dec_data_in : std_logic_vector(bit_size-1 downto 0);
signal dec_data_in_en : std_logic;
signal dec_data_out : std_logic_vector(bit_size-1 downto 0);
signal dec_data_out_en : std_logic;



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

        enc_data_in    <= (others=>'0');
        enc_data_in_en <= '0';
        wait for 500 us;
        wait until rising_edge(clk);

        for I in 0 to 65535 loop
            wait until rising_edge(clk);
            enc_data_in    <= const_all_ones(bit_size-1 downto 0);
            enc_data_in_en <= '1';
            wait until rising_edge(clk);
         
            enc_data_in_en <= '0';
            
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
         
        end loop;

        wait;

    end process;
    
    -- Loopback inside same module
    dec_data_in     <= enc_data_out;
    dec_data_in_en  <= enc_data_out_en;

    -- Encode and decode inside the same module
    pn_enc_dec_inst : entity work.pn_enc_dec
    generic map(
        bit_size =>bit_size
        )
    port map
        (
        clk => clk,
        rst_n => rst_n,
        enc_data_in => enc_data_in,
        enc_data_in_en => enc_data_in_en,
        enc_data_out => enc_data_out,
        enc_data_out_en => enc_data_out_en,
        dec_data_in => dec_data_in,
        dec_data_in_en => dec_data_in_en,
        dec_data_out => dec_data_out,
        dec_data_out_en => dec_data_out_en
);

end rtl;
