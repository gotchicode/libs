
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cubic_interpolator_tb is
end cubic_interpolator_tb;

architecture rtl of cubic_interpolator_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

constant sample_size            : integer:=12;          
constant sample_instant_size    : integer:=8;         

signal clk : std_logic;
signal rst : std_logic;
signal sample_in : std_logic_vector(sample_size-1 downto 0);
signal sample_in_en : std_logic;
signal sample_instant_in : std_logic_vector(sample_instant_size-1 downto 0);
signal rf_on_off_in : std_logic;
signal modu_on_off_in : std_logic;
signal power_level_in : std_logic_vector(15 downto 0);
signal phase_in : std_logic_vector(31 downto 0);
signal sample_out : std_logic_vector(sample_size-1 downto 0);
signal sample_out_en : std_logic;
signal rf_on_off_out : std_logic;
signal modu_on_off_out : std_logic;
signal power_level_out : std_logic_vector(15 downto 0);
signal phase_out : std_logic_vector(31 downto 0);



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
    -- Generate sample input
    -----------------------------------------
    process(clk, rst)
    variable v_incr         : unsigned(31 downto 0);
    variable v_nco_reg      : unsigned(31 downto 0);
    variable v_nco_reg_d1   : unsigned(31 downto 0);
    begin
        if rst='1' then
            
            v_incr              := to_unsigned(integer(real(real(12500000)*real(4294967296.0)/real(100000000))),32);
            v_nco_reg           := (others=>'0');
            v_nco_reg_d1        := (others=>'0');

            sample_in_en        <= '0';
            sample_instant_in   <= (others=>'0');
            sample_in           <= (others=>'0');
            
            rf_on_off_in        <= '0'; 
            modu_on_off_in      <= '0';               
            power_level_in      <= (others=>'0');              
            phase_in            <= (others=>'0');              

        elsif rising_edge(clk) then
        
            if v_nco_reg(31)='0' and  v_nco_reg_d1(31)='1' then
                sample_in <= std_logic_vector( unsigned(sample_in) + to_unsigned(100,sample_size) );
            end if;
        
            sample_in_en        <= not(v_nco_reg(31)) and v_nco_reg_d1(31);
            sample_instant_in   <= std_logic_vector(v_nco_reg(31 downto 32-sample_instant_size));
        
            v_nco_reg_d1        := v_nco_reg;
            v_nco_reg           := v_nco_reg + v_incr;
            
        end if;
    end process;

    cubic_interpolator_inst : entity work.cubic_interpolator
    generic map(
        sample_size         => sample_size, 
        sample_instant_size => sample_instant_size    
    )
    port map
        (
        clk => clk,
        rst => rst,
        sample_in => sample_in,
        sample_in_en => sample_in_en,
        sample_instant_in => sample_instant_in,
        rf_on_off_in => rf_on_off_in,
        modu_on_off_in => modu_on_off_in,
        power_level_in => power_level_in,
        phase_in => phase_in,
        sample_out => sample_out,
        sample_out_en => sample_out_en,
        rf_on_off_out => rf_on_off_out,
        modu_on_off_out => modu_on_off_out,
        power_level_out => power_level_out,
        phase_out => phase_out
);

end rtl;
