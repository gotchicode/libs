
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rates_builder_tb is
end rates_builder_tb;

architecture rtl of rates_builder_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal sample_rate : std_logic_vector(31 downto 0);
signal sample_bit_ratio : std_logic_vector(15 downto 0);
signal symbol_bit_ratio : std_logic_vector(7 downto 0);
signal bit_request : std_logic;
signal bit_in_en : std_logic;
signal bit_in : std_logic;
signal rf_on_off_in : std_logic;
signal modu_on_off_in : std_logic;
signal power_level_in : std_logic_vector(15 downto 0);
signal phase_in : std_logic_vector(31 downto 0);
signal bit_in_en_ack : std_logic;
signal bit_out : std_logic;
signal bit_out_en : std_logic;
signal symbol_out_en : std_logic;
signal sample_out_en : std_logic;
signal sample_instant : std_logic_vector(31 downto 0);
signal rf_on_off_out     : std_logic;
signal modu_on_off_out   : std_logic;
signal power_level_out   : std_logic_vector(15 downto 0);
signal phase_out         : std_logic_vector(31 downto 0);

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
    -- Configuration
    -----------------------------------------
    --Rates builder
    sample_rate             <= std_logic_vector(to_unsigned(integer(real(real(1000000)*real(4294967296.0)/real(100000000))),32));
    sample_bit_ratio        <= std_logic_vector(to_unsigned(32-1,16));
    symbol_bit_ratio        <= std_logic_vector(to_unsigned(1-1,8));
    
    
    ------------------------------------------  
    -- Input bits                                     
    ------------------------------------------     
    input_bits_pr: process(clk, rst)
    
    begin    
        if rst='1' then  
        
            pattern_register <= x"AAAAAAAA";
            bit_in_en <= '0';
            bit_in <= '0';            
            
        elsif rising_edge(clk) then   
        
            --Pattern shifter
            if bit_request='1' then
                pattern_register(31 downto 1) <= pattern_register(30 downto 0);
                pattern_register(0) <= pattern_register(31);
            end if;
            
            --Input
            bit_in <= pattern_register(31);
            bit_in_en <= bit_request;
            
        end if;    
    end process;    
    
    
    ------------------------------------------  
    -- Input dynamic parameters                           
    ------------------------------------------
    rf_on_off_in                <= '0';
    modu_on_off_in              <= '0';
    phase_in                    <= (others=>'0');
    power_level_in              <= (others=>'0');
    
    ------------------------------------------  
    -- Rates builder module                                     
    ------------------------------------------    
    rates_builder_inst : entity work.rates_builder
    port map
        (
        clk => clk,
        rst => rst,
        sample_rate => sample_rate,
        sample_bit_ratio => sample_bit_ratio,
        symbol_bit_ratio => symbol_bit_ratio,
        bit_request => bit_request,
        bit_in_en => bit_in_en,
        bit_in => bit_in,
        rf_on_off_in => rf_on_off_in,
        modu_on_off_in => modu_on_off_in,
        power_level_in => power_level_in,
        phase_in       => phase_in,
        bit_in_en_ack => bit_in_en_ack,
        bit_out => bit_out,
        bit_out_en => bit_out_en,
        symbol_out_en => symbol_out_en,
        sample_out_en => sample_out_en,
        sample_instant => sample_instant,
        rf_on_off_out      => rf_on_off_out,
        modu_on_off_out    => modu_on_off_out,
        power_level_out    => power_level_out,
        phase_out          => phase_out
    );

end rtl;
