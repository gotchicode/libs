
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter_numeric_tb is
end fir_filter_numeric_tb;

architecture rtl of fir_filter_numeric_tb is

constant clk_const              : time := 5 ns;
constant bits_data              : natural := 12; 

signal MainClk                  : STD_LOGIC;  
signal Rst                      : std_logic;
signal sample_input             : std_logic_vector ( (bits_data - 1) downto 0);
signal sample_output            : signed( (bits_data+bits_data - 1) downto 0);
signal FIRin                    : std_logic;
signal sample_out               : std_logic;



begin

    -----------------------------------------
    -- clk generation
    -----------------------------------------
    clk_gen_pr: process
    begin
        MainClk <= '1';
        wait for clk_const;

        MainClk <= '0';
        wait for clk_const;
    end process;
    
    -----------------------------------------
    -- Rst generation
    -----------------------------------------
    rst_gen_pr: process
    begin
    
        Rst <= '1';
        wait for clk_const;
    
        Rst <= '1';
        wait for clk_const;

        Rst <= '0';
        wait for clk_const;
        
        wait; 
    end process;



    fir_filter_numeric_inst : entity work.fir_filter_numeric 
    Port map
        (
        MainClk            => MainClk,
        Rst                => Rst,
        sample_input       => sample_input,
        sample_output      => sample_output,
        FIRin              => FIRin,
        sample_out         => sample_out
        );



    
    process
    begin
    
        sample_input     <= std_logic_vector(to_signed(-100,12));
        FIRin  <= '0';

        wait for 1 us;
        
        wait until rising_edge(MainClk);
        FIRin  <= '1';
        
        wait until rising_edge(MainClk);
        FIRin  <= '0';    
    
    end process;
    

end rtl;
