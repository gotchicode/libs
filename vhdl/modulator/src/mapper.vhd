library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mapper is
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    bit_in                          : in std_logic;
    bit_in_en                       : in std_logic;    
    symbol_in_en                    : in std_logic;    
    sample_in_en                    : in std_logic;    
    sample_instant_in               : in std_logic_vector(31 downto 0);
    rf_on_off_in                    : in std_logic;
    modu_on_off_in                  : in std_logic;
    power_level_in                  : in std_logic_vector(15 downto 0);
    phase_in                        : in std_logic_vector(31 downto 0);
    
    phase_mod_incr                  : in std_logic_vector(31 downto 0);

    symbol_out                      : out std_logic_vector(31 downto 0);   
    symbol_out_en                   : out std_logic;    
    sample_out_en                   : out std_logic;    
    sample_instant_out              : out std_logic_vector(31 downto 0);    
    rf_on_off_out                   : out std_logic;
    modu_on_off_out                 : out std_logic;
    power_level_out                 : out std_logic_vector(15 downto 0);
    phase_out                       : out std_logic_vector(31 downto 0)
 );
end entity mapper;

architecture rtl of mapper is

begin

------------------------------------------                                                           
-- Mapping                                                                           
------------------------------------------ 
mapper_pr: process(clk, rst)
begin
    if rst='1' then
    
        symbol_out              <= (others=>'0');
        symbol_out_en           <= '0';    
        sample_out_en           <= '0';    
        sample_instant_out      <= (others=>'0');       
        rf_on_off_out           <= '0';    
        modu_on_off_out         <= '0';    
        power_level_out         <= (others=>'0');
        phase_out               <= (others=>'0');
    
    elsif rising_edge(clk) then
    
        if bit_in='1' then
            symbol_out <= phase_mod_incr;
        end if;
        
        if bit_in='0' then
            symbol_out <= std_logic_vector(not(unsigned(phase_mod_incr))+1);
        end if;
        
        symbol_out_en        <=  symbol_in_en;
        sample_out_en        <=  sample_in_en;
        sample_instant_out   <=  sample_instant_in;
        rf_on_off_out        <=  rf_on_off_in;
        modu_on_off_out      <=  modu_on_off_in;
        power_level_out      <=  power_level_in;
        phase_out            <=  phase_in;
        
    
    end if;
end process;


end rtl;