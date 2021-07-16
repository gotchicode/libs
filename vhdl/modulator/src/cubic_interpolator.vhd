library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity cubic_interpolator is
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    sample_in                       : in std_logic_vector(11 downto 0);    
    sample_in_en                    : in std_logic;    
    sample_instant_in               : in std_logic_vector(31 downto 0);
    rf_on_off_in                    : in std_logic;
    modu_on_off_in                  : in std_logic;
    power_level_in                  : in std_logic_vector(15 downto 0);
    phase_in                        : in std_logic_vector(31 downto 0);

    sample_out                      : out std_logic_vector(11 downto 0);   
    sample_out_en                   : out std_logic;      
    rf_on_off_out                   : out std_logic;
    modu_on_off_out                 : out std_logic;
    power_level_out                 : out std_logic_vector(15 downto 0);
    phase_out                       : out std_logic_vector(31 downto 0)
 );
end entity cubic_interpolator;

architecture rtl of cubic_interpolator is

signal y0   : signed(11 downto 0);
signal y1   : signed(11 downto 0);
signal y2   : signed(11 downto 0);
signal y3   : signed(11 downto 0);


begin

------------------------------------------                                                           
-- Processing                                                                    
------------------------------------------ 
processing_pr: process(clk, rst)
begin
    if rst='1' then
    
        y0 <= (others=>'0');
        y1 <= (others=>'0');   
        y2 <= (others=>'0');   
        y3 <= (others=>'0');   

    elsif rising_edge(clk) then
    
        -- Shift register of the incoming samples
        -- Delay 1
        if sample_in_en='1' then
            y0 <= y1;
            y1 <= y2;    
            y2 <= y3;   
            y3 <= sample_in;     
        end if;
        y_en                    <= sample_in_en;
        mu_tmp                  <= sample_instant_in;
        
        --Compute taps
        a0 <=y3-y2-y0+y1;
        a1 <= y0-y1-a0;
        a2 <= y2-y0;
        a3 <= y1;
        mu_bis_tmp <= mu_tmp * mu_tmp;
        
    
    end if;
end process;

------------------------------------------                                                           
-- Calculate mu                                                                         
------------------------------------------ 
mu_calc_pr: process(clk, rst)
begin
    if rst='1' then
    
    elsif rising_edge(clk) then

    
    end if;
end process;

end rtl;