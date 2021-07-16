
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sin_cos_lut_tb is
end sin_cos_lut_tb;

architecture rtl of sin_cos_lut_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal phase_in_en : std_logic;
signal phase_in : std_logic_vector(11 downto 0);
signal sin_out : std_logic_vector(15 downto 0);
signal cos_out : std_logic_vector(15 downto 0);
signal sin_out_en : std_logic;

signal tick_in          : std_logic;



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
    
    -----------------------------------------
    -- Input  generation
    -----------------------------------------
    input_pr: process(clk, rst)
    begin    
        if rst='1' then  

            phase_in_en     <= '0';
            phase_in        <= (others=>'0');

        elsif rising_edge(clk) then   
        
            --Pattern shifter
            if tick_in='1' then
                phase_in <= std_logic_vector(unsigned(phase_in)+1);
            end if;
            
            phase_in_en <=  tick_in;
            

        end if;
    end process;

    sin_cos_lut_inst : entity work.sin_cos_lut
    port map
        (
        clk => clk,
        rst => rst,
        phase_in_en => phase_in_en,
        phase_in => phase_in,
        sin_out => sin_out,
        cos_out => cos_out,
        sin_out_en => sin_out_en
);

end rtl;
