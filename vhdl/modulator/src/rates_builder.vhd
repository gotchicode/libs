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
    bit_in_en                : in std_logic;
    bit_in                  : in std_logic;
    rf_on_off_in            : in std_logic;
    modu_on_off_in          : in std_logic;
    power_level_in          : in std_logic_vector(15 downto 0);
    phase_in                : in std_logic_vector(31 downto 0);
    bit_in_en_ack           : out std_logic;
    
    bit_out                 : out std_logic;
    bit_out_en              : out std_logic;
    symbol_out_en           : out std_logic;
    sample_out_en           : out std_logic;
    sample_instant          : out std_logic_vector(31 downto 0);
    rf_on_off_out           : out std_logic;
    modu_on_off_out         : out std_logic;
    power_level_out         : out std_logic_vector(15 downto 0);
    phase_out               : out std_logic_vector(31 downto 0) 

 );
end entity rates_builder;

architecture rtl of rates_builder is

signal sample_rate_nco      : unsigned(31 downto 0);
signal sample_rate_nco_d1   : unsigned(31 downto 0);
signal sample_rate_nco_d2   : unsigned(31 downto 0);
signal sample_rate_nco_d3   : unsigned(31 downto 0);
signal sample_pulse         : std_logic;
signal sample_pulse_d1      : std_logic;
signal sample_pulse_d2      : std_logic;
signal bit_pulse_cnt        : unsigned(15 downto 0);
signal bit_pulse            : std_logic;
signal bit_pulse_d1         : std_logic;
signal symbol_pulse_cnt     : unsigned(7 downto 0);
signal symbol_pulse         : std_logic;


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
        sample_rate_nco_d2      <=(others=>'0');
        sample_rate_nco_d3      <=(others=>'0');
        
        sample_pulse            <='0';
        sample_pulse_d1         <='0';
        sample_pulse_d2         <='0';
        
        bit_pulse_cnt           <=(others=>'0');
        bit_pulse               <='0';
        bit_pulse_d1            <='0';
        
        symbol_pulse_cnt        <=(others=>'0');
        symbol_pulse            <='0';  

        
    elsif rising_edge(clk) then
    
        --Sampling rate generation with a phase integrator
        sample_rate_nco     <= sample_rate_nco+unsigned(sample_rate);
        sample_rate_nco_d1  <= sample_rate_nco;
        sample_rate_nco_d2  <= sample_rate_nco_d1;
        sample_rate_nco_d3  <= sample_rate_nco_d2;
        
        --Pulse generation with the MSB of the phase integrator
        sample_pulse        <= not(sample_rate_nco(31)) and (sample_rate_nco_d1(31)); -- Falling edge detection
        sample_pulse_d1     <= sample_pulse;
        sample_pulse_d2     <= sample_pulse_d1;
        
        --Bit rate generation
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
        bit_pulse_d1 <= bit_pulse;
        
        --Symbol rate generation
        case symbol_bit_ratio is
            when x"00"=>
                symbol_pulse_cnt        <= (others=>'0');
                symbol_pulse            <= bit_pulse;
            when others =>
                if bit_pulse='1' and symbol_pulse_cnt=unsigned(symbol_bit_ratio) then
                    symbol_pulse_cnt <= (others=>'0');
                    symbol_pulse     <= '1';
                elsif bit_pulse='1' then
                    symbol_pulse_cnt <= symbol_pulse_cnt+1;
                    symbol_pulse     <= '0';
                else
                    symbol_pulse     <= '0';
                end if;
        end case;
    end if;
end process;

------------------------------------------                                                           
-- Input signal interfacing                                                                              
------------------------------------------ 

--Bit request
bit_request <= bit_pulse;

------------------------------------------                                                           
-- Output signal interfacing                                                                              
------------------------------------------ 
output_interface_pr: process(clk, rst)
begin
    if rst='1' then
    
        -- Signals for forward modules
        bit_out             <= '0';
        bit_out_en          <= '0';  
        symbol_out_en       <= '0';  
        sample_out_en       <= '0';  
        sample_instant      <= (others=>'0');
        rf_on_off_out       <= '0';
        modu_on_off_out     <= '0';        
        power_level_out     <= (others=>'0');    
        phase_out           <= (others=>'0');       
        
        -- Signal to backward module - ack of the received bit
        bit_in_en_ack      <= '0';  
        
    
    elsif rising_edge(clk) then
    
        -- Signals for forward modules
        bit_out_en      <= bit_pulse_d1;
        bit_out         <= bit_in;
        symbol_out_en   <= symbol_pulse;
        sample_out_en   <= sample_pulse_d2;
        sample_instant  <= std_logic_vector(sample_rate_nco_d3);
        
        -- Signal to backward module - ack of the received bit
        bit_in_en_ack   <= bit_pulse_d1 and bit_in_en;
        
        -- Signal to pass through the modules
        rf_on_off_out       <= rf_on_off_in; 
        modu_on_off_out     <= modu_on_off_in;     
        power_level_out     <= power_level_in;     
        phase_out           <= phase_in;    
        
    
    end if;
end process;



end rtl;