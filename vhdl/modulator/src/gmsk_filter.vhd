library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gmsk_filter is
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    symbol_in                       : in std_logic_vector(11 downto 0); 
    symbol_in_en                    : in std_logic;    
    sample_in_en                    : in std_logic;    
    sample_instant_in               : in std_logic_vector(31 downto 0);
    rf_on_off_in                    : in std_logic;
    modu_on_off_in                  : in std_logic;
    power_level_in                  : in std_logic_vector(15 downto 0);
    phase_in                        : in std_logic_vector(31 downto 0);
    
    interp_factor                   : in std_logic_vector(15 downto 0);
    taps_per_bank                   : in std_logic_vector(15 downto 0);
    taps_max_index                  : in std_logic_vector(15 downto 0);

    symbol_out_en                   : out std_logic;    
    sample_out                      : out std_logic_vector(11 downto 0);
    sample_out_en                   : out std_logic;    
    sample_instant_out              : out std_logic_vector(31 downto 0);    
    rf_on_off_out                   : out std_logic;
    modu_on_off_out                 : out std_logic;
    power_level_out                 : out std_logic_vector(15 downto 0);
    phase_out                       : out std_logic_vector(31 downto 0)
 );
end entity gmsk_filter;

architecture rtl of gmsk_filter is

signal interp_counter       : unsigned(15 downto 0);
signal interp_counter_en    : std_logic;

begin

------------------------------------------                                                           
-- Filter                                                                  
------------------------------------------
Filter_pr: process(clk, rst)
begin
    if rst='1' then
    
        interp_counter       <= (others=>'0');
        interp_counter_en    <= '0';

    elsif rising_edge(clk) then
    
        -- Interpolation counter
        -- Important: symbol_in_en and sample_in_en are high together
        if symbol_in_en='1' then
            interp_counter <= (others=>'0');
        elsif sample_in_en='1' then
            interp_counter <= interp_counter+1;
        end if;
        interp_counter_en <= sample_in_en;
        
        -- Load taps
        
        -- For example, interp_factor=4, taps_max_index=interp_factor*4+1=17 and taps_per_bank=4
        -- sample0: 0 4 8 12 16
        -- sample1: 1 5 9 13 17
        -- sample2: 2 6 10 14 
        
        
    

    
    end if;
end process;

end rtl;