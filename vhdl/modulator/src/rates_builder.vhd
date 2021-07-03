library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rates_builder is
port(
    clk                     : in std_logic;
    rst                     : in std_logic;

    sample_rate             : in std_logic_vector(31 downto 0);
    sample_bit_ratio        : in std_logic_vector(15 downto 0);
    symbol_bit_ratio        : in std_logic_vector(7 downto 0);
    
    bit_request             : out std_logic;
    bit_en                  : in std_logic;
    bit_in                  : in std_logic;
    rf_on_off_in            : in std_logic;
    modu_on_off_in          : in std_logic;
    bit_en_ack              : in std_logic;
    
    bit_out                 : out std_logic;
    bit_out_en              : out std_logic;
    symbol_out_en           : out std_logic;
    sample_out_en           : out std_logic;
    sample_instant          : out std_logic_vector(31 downto 0)
    
 );
end entity rates_builder;

architecture rtl of rates_builder is

signal sample_rate_nco      : unsigned(31 downto 0);
signal sample_rate_nco_d1   : unsigned(31 downto 0);
signal sample_pulse         : std_logic;
signal sample_pulse_d1      : std_logic;
signal bit_pulse_cnt        : unsigned(15 downto 0);
signal bit_pulse            : std_logic;


begin

--  ------------------------------------------                                                           
--  -- Template                                                                              
--  ------------------------------------------ 
--  template_pr: process(clk, rst)
--  begin
--      if rst='1' then
--      elsif rising_edge(clk) then
--      end if;
--  end process;

------------------------------------------                                                           
-- Generating all rates                                                                     
------------------------------------------ 
sampling_rate_pr: process(clk, rst)
begin
    if rst='1' then
    
        sample_rate_nco         <=(others=>'0');
        sample_rate_nco_d1      <=(others=>'0');
        sample_pulse            <='0';
        sample_pulse_d1         <='0';
        
        bit_pulse_cnt        <=(others=>'0');
        bit_pulse            <='0'; 
        
    elsif rising_edge(clk) then
    
        --Sampling rate generation
        sample_rate_nco     <= sample_rate_nco+unsigned(sample_rate);
        sample_rate_nco_d1  <= sample_rate_nco;
        sample_pulse        <= sample_rate_nco(31) and not(sample_rate_nco_d1(31));
        sample_pulse_d1     <= sample_pulse;
        
        case sample_bit_ratio is
            when x"0000"=>
                bit_pulse_cnt        <= (others=>'0');
                bit_pulse            <= sample_pulse; 
            when others =>
                if sample_pulse='1' and bit_pulse_cnt=unsigned(sample_bit_ratio) then
                    bit_pulse_cnt <= (others=>'0');
                    bit_pulse     <= '1';
                elsif sample_pulse='1' then
                    bit_pulse_cnt <= bit_pulse_cnt+1;
                    bit_pulse     <= '0';
                else
                    bit_pulse     <= '0';
                end if;
        end case;
        

    end if;
end process;

------------------------------------------                                                           
-- Generate the sampling rate                                                                         
------------------------------------------ 

end rtl;