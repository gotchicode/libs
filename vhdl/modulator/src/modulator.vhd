library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity modulator is
port(
    clk                         : in std_logic;
    rst                         : in std_logic;
    
    bit_request                 : out std_logic;
    bit_in_en                   : in std_logic;
    bit_in                      : in std_logic;
    rf_on_off_in                : in std_logic;
    modu_on_off_in              : in std_logic;
    power_level_in              : in std_logic_vector(15 downto 0);
    phase_in                    : in std_logic_vector(31 downto 0);
    bit_in_en_ack               : out std_logic;

    baseband_I_out              : out std_logic_vector(31 downto 0);
    baseband_Q_out              : out std_logic_vector(31 downto 0);
    baseband_out_en             : out std_logic;
    
    modulated_carrier_I_out     : out std_logic_vector(31 downto 0);
    modulated_carrier_Q_out     : out std_logic_vector(31 downto 0);
    modulated_carrier_out_en    : out std_logic;
    
    bit_out                     : out std_logic;
    bit_out_en                  : out std_logic;
    symbol_out_en               : out std_logic;
    sample_out_en               : out std_logic;
    sample_instant              : out std_logic_vector(31 downto 0);
    rf_on_off_out               : out std_logic;
    modu_on_off_out             : out std_logic;
    power_level_out             : out std_logic_vector(15 downto 0);
    phase_out                   : out std_logic_vector(31 downto 0) 

 );
end entity modulator;

architecture rtl of modulator is

-- Rates builder signals
signal rates_builder_sample_rate              : std_logic_vector(31 downto 0);
signal rates_builder_sample_bit_ratio         : std_logic_vector(15 downto 0);
signal rates_builder_symbol_bit_ratio         : std_logic_vector(7 downto 0);
signal rates_builder_bit_request              : std_logic;
signal rates_builder_bit_in_en                : std_logic;
signal rates_builder_bit_in                   : std_logic;
signal rates_builder_rf_on_off_in             : std_logic;
signal rates_builder_modu_on_off_in           : std_logic;
signal rates_builder_power_level_in           : std_logic_vector(15 downto 0);
signal rates_builder_phase_in                 : std_logic_vector(31 downto 0);
signal rates_builder_bit_in_en_ack            : std_logic;
signal rates_builder_bit_out                  : std_logic;
signal rates_builder_bit_out_en               : std_logic;
signal rates_builder_symbol_out_en            : std_logic;
signal rates_builder_sample_out_en            : std_logic;
signal rates_builder_sample_instant           : std_logic_vector(31 downto 0);
signal rates_builder_rf_on_off_out            : std_logic;
signal rates_builder_modu_on_off_out          : std_logic;
signal rates_builder_power_level_out          : std_logic_vector(15 downto 0);
signal rates_builder_phase_out                : std_logic_vector(31 downto 0);

begin

---------------------------------------------------------------
-- Rates builder
---------------------------------------------------------------
rates_builder_inst : entity work.rates_builder
port map
    (
    clk                 => clk,
    rst                 => rst,
    sample_rate         => rates_builer_sample_rate,
    sample_bit_ratio    => rates_builer_sample_bit_ratio,
    symbol_bit_ratio    => rates_builer_symbol_bit_ratio,
    bit_request         => rates_builer_bit_request,
    bit_in_en           => rates_builer_bit_in_en,
    bit_in              => rates_builer_bit_in,
    rf_on_off_in        => rates_builer_rf_on_off_in,
    modu_on_off_in      => rates_builer_modu_on_off_in,
    power_level_in      => rates_builer_power_level_in,
    phase_in            => rates_builer_phase_in,
    bit_in_en_ack       => rates_builer_bit_in_en_ack,
    bit_out             => rates_builer_bit_out,
    bit_out_en          => rates_builer_bit_out_en,
    symbol_out_en       => rates_builer_symbol_out_en,
    sample_out_en       => rates_builer_sample_out_en,
    sample_instant      => rates_builer_sample_instant,
    rf_on_off_out       => rates_builer_rf_on_off_out,
    modu_on_off_out     => rates_builer_modu_on_off_out,
    power_level_out     => rates_builer_power_level_out,
    phase_out           => rates_builer_phase_out
);

bit_request                 <= rates_builer_bit_request;
rates_builer_bit_in_en_ack  <= bit_in_en_ack;


---------------------------------------------------------------
-- Mapping
---------------------------------------------------------------

---------------------------------------------------------------
-- Shaping filtering & Upsaming
---------------------------------------------------------------

---------------------------------------------------------------
-- Fractional interpolating
---------------------------------------------------------------

---------------------------------------------------------------
-- Phase integrating
---------------------------------------------------------------

---------------------------------------------------------------
-- Frequency modulation
---------------------------------------------------------------



end rtl;