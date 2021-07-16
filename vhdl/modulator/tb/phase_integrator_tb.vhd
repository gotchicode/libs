
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_integrator_tb is
end phase_integrator_tb;

architecture rtl of phase_integrator_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal symbol_in : std_logic_vector(31 downto 0);
signal symbol_in_en : std_logic;
signal sample_in_en : std_logic;
signal sample_instant_in : std_logic_vector(31 downto 0);
signal rf_on_off_in : std_logic;
signal modu_on_off_in : std_logic;
signal power_level_in : std_logic_vector(15 downto 0);
signal phase_in : std_logic_vector(31 downto 0);
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
    
    -----------------------------------------
    -- Input  generation
    -----------------------------------------
    input_pr: process(clk, rst)
    variable v_sample_instant_in    : std_logic_vector(31 downto 0);
    variable v_power_level_in       : std_logic_vector(15 downto 0);
    variable v_phase_in             : std_logic_vector(31 downto 0);
    begin    
        if rst='1' then  
        
            -- pattern register
            pattern_register <= x"AAAAAAAA";
            
            -- dynamic input          
            symbol_in_en            <= '0';            
            sample_in_en            <= '0';            
            sample_instant_in       <= (others=>'0');            
            rf_on_off_in            <= '0';            
            modu_on_off_in          <= '0';            
            power_level_in          <= (others=>'0');            
            phase_in                <= (others=>'0');   

            -- variables              
            v_sample_instant_in     := (others=>'0'); 
            v_power_level_in        := (others=>'0');             
            v_phase_in              := (others=>'0');        

        elsif rising_edge(clk) then   
        
            --Pattern shifter
            if tick_in='1' then
                pattern_register(31 downto 1) <= pattern_register(30 downto 0);
                pattern_register(0) <= pattern_register(31);
            end if;
            
            -- variables increment
            if tick_in='1' then
                v_sample_instant_in    := std_logic_vector(unsigned(v_sample_instant_in )+1);
                v_power_level_in       := std_logic_vector(unsigned(v_power_level_in)+1);           
                v_phase_in             := std_logic_vector(unsigned(v_phase_in)+1);        
            end if;

            -- Dynamic inputs
            symbol_in_en            <= tick_in;
            sample_in_en            <= tick_in;
            sample_instant_in       <= v_sample_instant_in;
            rf_on_off_in            <= tick_in;
            modu_on_off_in          <= tick_in;
            power_level_in          <= v_power_level_in;
            phase_in                <= v_phase_in;
            
            
        end if;
    end process;
    
    --Bit in
    symbol_in <=std_logic_vector(to_signed(100,32)) when pattern_register(0) = '0' else std_logic_vector(to_signed(-100,32));

    phase_integrator_inst : entity work.phase_integrator
    port map
        (
        clk => clk,
        rst => rst,
        symbol_in => symbol_in,
        symbol_in_en => symbol_in_en,
        sample_in_en => sample_in_en,
        sample_instant_in => sample_instant_in,
        rf_on_off_in => rf_on_off_in,
        modu_on_off_in => modu_on_off_in,
        power_level_in => power_level_in,
        phase_in => phase_in,
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
