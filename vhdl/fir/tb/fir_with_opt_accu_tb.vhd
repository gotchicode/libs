
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_with_opt_accu_tb is
end fir_with_opt_accu_tb;

architecture rtl of fir_with_opt_accu_tb is

constant clk_const : time := 5 ns;

signal clk : std_logic;
signal data_in : std_logic_vector(11 downto 0);
signal data_in_en : std_logic;
signal data_out : std_logic_vector(11 downto 0);
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




    fir_with_opt_accu_inst : entity work.fir_with_opt_accu
    port map
        (
        clk => clk,
        data_in => data_in,
        data_in_en => data_in_en,
        data_out => data_out,
        data_out_en => data_out_en
);  
    
    process
    begin
    
        data_in     <= std_logic_vector(to_signed(-100,12));
        data_in_en  <= '0';

        wait for 1 us;
        
        wait until rising_edge(clk);
        data_in_en  <= '1';
        
        wait until rising_edge(clk);
        data_in_en  <= '0';    
    
    end process;
    

end rtl;
