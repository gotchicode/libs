library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity phase_integrator is
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    symbol_in                       : in std_logic_vector(31 downto 0);   
    symbol_in_en                    : in std_logic;    
    sample_in_en                    : in std_logic;    
    sample_instant_in               : in std_logic_vector(31 downto 0);
    rf_on_off_in                    : in std_logic;
    modu_on_off_in                  : in std_logic;
    power_level_in                  : in std_logic_vector(15 downto 0);
    phase_in                        : in std_logic_vector(31 downto 0);

    symbol_out                      : out std_logic_vector(31 downto 0);   
    symbol_out_en                   : out std_logic;    
    sample_out_en                   : out std_logic;    
    sample_instant_out              : out std_logic_vector(31 downto 0);    
    rf_on_off_out                   : out std_logic;
    modu_on_off_out                 : out std_logic;
    power_level_out                 : out std_logic_vector(15 downto 0);
    phase_out                       : out std_logic_vector(31 downto 0)
 );
end entity phase_integrator;

architecture rtl of phase_integrator is

signal symbol_stored            : signed(31 downto 0); 
signal symbol_stored_en         : std_logic;
signal symbol_stored_en_d1      : std_logic;

signal phase_integrator_reg     : signed(31 downto 0);

signal sample_in_en_d1                    : std_logic;    
signal sample_instant_in_d1               : std_logic_vector(31 downto 0);
signal rf_on_off_in_d1                    : std_logic;
signal modu_on_off_in_d1                  : std_logic;
signal power_level_in_d1                  : std_logic_vector(15 downto 0);
signal phase_in_d1                        : std_logic_vector(31 downto 0);

signal sample_in_en_d2                    : std_logic;    
signal sample_instant_in_d2               : std_logic_vector(31 downto 0);
signal rf_on_off_in_d2                    : std_logic;
signal modu_on_off_in_d2                  : std_logic;
signal power_level_in_d2                  : std_logic_vector(15 downto 0);
signal phase_in_d2                        : std_logic_vector(31 downto 0);

begin

------------------------------------------                                                           
-- Delays                                                                    
------------------------------------------
delays_pr: process(clk, rst)
begin
    if rst='1' then
    
        sample_in_en_d1                    <= '0';     
        sample_instant_in_d1               <= (others=>'0'); 
        rf_on_off_in_d1                    <= '0';     
        modu_on_off_in_d1                  <= '0';     
        power_level_in_d1                  <= (others=>'0'); 
        phase_in_d1                        <= (others=>'0'); 
        
        sample_in_en_d2                    <= '0';     
        sample_instant_in_d2               <= (others=>'0'); 
        rf_on_off_in_d2                    <= '0';     
        modu_on_off_in_d2                  <= '0';     
        power_level_in_d2                  <= (others=>'0'); 
        phase_in_d2                        <= (others=>'0'); 
    
    elsif rising_edge(clk) then
    
        sample_in_en_d1       <= sample_in_en;
        sample_instant_in_d1  <= sample_instant_in;
        rf_on_off_in_d1       <= rf_on_off_in;
        modu_on_off_in_d1     <= modu_on_off_in;
        power_level_in_d1     <= power_level_in;
        phase_in_d1           <= phase_in;
    
        sample_in_en_d2       <= sample_in_en_d1;
        sample_instant_in_d2  <= sample_instant_in_d1;
        rf_on_off_in_d2       <= rf_on_off_in_d1;
        modu_on_off_in_d2     <= modu_on_off_in_d1;
        power_level_in_d2     <= power_level_in_d1;
        phase_in_d2           <= phase_in_d1;
    
    end if;
end process;

------------------------------------------                                                           
-- Phase integration                                                                     
------------------------------------------ 
phase_integration_pr: process(clk, rst)
begin
    if rst='1' then
    
        symbol_stored           <= (others=>'0');
        symbol_stored_en        <= '0';
        symbol_stored_en_d1     <= '0';
        phase_integrator_reg    <= (others=>'0');
    
        symbol_out_en           <= '0';    
        sample_out_en           <= '0';    
        sample_instant_out      <= (others=>'0');        
        rf_on_off_out           <= '0';    
        modu_on_off_out         <= '0';    
        power_level_out         <= (others=>'0');
        phase_out               <= (others=>'0');
    
    elsif rising_edge(clk) then
    
        -- Integrate the phase
        if symbol_in_en='1' then
            symbol_stored       <= signed(symbol_in);
        end if;
        symbol_stored_en <= symbol_in_en;
        
        -- Integration
        phase_integrator_reg <= phase_integrator_reg+symbol_stored;
        symbol_stored_en_d1 <= symbol_stored_en;

        -- Resynchronize outputs
        symbol_out              <= std_logic_vector(phase_integrator_reg);
        symbol_out_en           <=  symbol_stored_en_d1;
        sample_out_en           <=  sample_in_en_d2;
        sample_instant_out      <=  sample_instant_in_d2;
        rf_on_off_out           <=  rf_on_off_in_d2;
        modu_on_off_out         <=  modu_on_off_in_d2;
        power_level_out         <=  power_level_in_d2;
        phase_out               <=  phase_in_d2;
    
    end if;
end process;




end rtl;