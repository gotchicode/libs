library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity de0_top is
    generic (
              simu      : integer:=0
    );
 port (
            CLOCK_50                : in std_logic;
            CLOCK_50_2              : in std_logic;
     
            BUTTON                  : in std_logic_vector(2 downto 0);
            SW                      : in std_logic_vector(9 downto 0); 
            
            LEDG                    : out std_logic_vector(9 downto 0);
            
            
            GPIO0_D_31              : out std_logic;
            GPIO0_D_30              : out std_logic;
            GPIO0_D_29              : out std_logic;
            GPIO0_D_28              : out std_logic;
            GPIO0_D_27              : out std_logic;
            GPIO0_D_26              : out std_logic;
            GPIO0_D_25              : out std_logic;
            GPIO0_D_24              : out std_logic;
            GPIO0_D_23              : out std_logic;
            GPIO0_D_22              : out std_logic;
            GPIO0_D_21              : out std_logic;
            GPIO0_D_20              : out std_logic;
            GPIO0_D_19              : out std_logic;
            GPIO0_D_18              : out std_logic;
            GPIO0_D_17              : out std_logic;
            GPIO0_D_16              : out std_logic;
            GPIO0_D_15              : out std_logic;
            GPIO0_D_14              : out std_logic;
            GPIO0_D_13              : out std_logic;
            GPIO0_D_12              : out std_logic;
            GPIO0_D_11              : out std_logic;
            GPIO0_D_10              : out std_logic;
            GPIO0_D_9               : out std_logic;
            GPIO0_D_8               : out std_logic;
            GPIO0_D_7               : out std_logic;
            GPIO0_D_6               : out std_logic;
            GPIO0_D_5               : out std_logic;
            GPIO0_D_4               : out std_logic;
            GPIO0_D_3               : out std_logic;
            GPIO0_D_2               : out std_logic;
            GPIO0_D_1               : out std_logic;
            GPIO0_D_0               : out std_logic
     
 );
end entity de0_top;

architecture rtl of de0_top is

--------------------------------------------------------
--Global
--------------------------------------------------------
signal rst                                          : std_logic;
signal clk_main                                     : std_logic; 
signal rst_main                                     : std_logic; 
signal rst_n_main                                   : std_logic; 


--------------------------------------------------------
--NCO generation signals
--------------------------------------------------------
signal nco_accu										: unsigned(31 downto 0):=(others=>'0');
signal nco_accu_incr_const							: unsigned(31 downto 0):=to_unsigned(43,32);
signal nco_accu_incr							    : unsigned(31 downto 0):=nco_accu_incr_const;
signal nco_clock                                    : std_logic;
signal nco_clock_d1									: std_logic;
signal nco_clock_top                                : std_logic;


begin


rst         <= SW(0);

--template_pr: process(clk, rst_n)
--begin
--    if rst_n='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

--------------------------------------------------------
-- Clock and reset generation
--------------------------------------------------------
clk_rst_gen_inst:  entity work.clk_rst_gen
    generic map (  simu => simu
    )
    port map(
            clk             => CLOCK_50,
            rst             => rst,
            clk0            => clk_main,
            rst0            => rst_main,
            rstn0           => rst_n_main
 );
 
--------------------------------------------------------
--NCO
--------------------------------------------------------
nco_pro: process(clk_main, rst_main)
begin
	if rst_main='1' then
        nco_accu        <= (others=>'0');	     
        nco_clock	    <= '0';    
        nco_clock_d1    <= '0';      
        nco_clock_top   <= '0';   
        nco_accu_incr   <= nco_accu_incr_const;
    elsif rising_edge(clk_main) then
		nco_accu 	        <= nco_accu + nco_accu_incr;
		nco_clock	        <=nco_accu(31);
		nco_clock_d1        <=nco_clock;
		if nco_clock='1' and nco_clock_d1='0' then
            nco_clock_top   <= not(nco_clock_top);
        end if;
	end if;
end process;

--------------------------------------------------------
--Outputs
--------------------------------------------------------   

LEDG <= nco_clock & nco_clock & nco_clock & nco_clock & nco_clock & nco_clock_top & nco_clock_top & nco_clock_top & nco_clock_top & nco_clock_top;

GPIO0_D_31 <= nco_clock;
GPIO0_D_30 <= nco_clock;
GPIO0_D_29 <= nco_clock;
GPIO0_D_28 <= nco_clock;
GPIO0_D_27 <= nco_clock;
GPIO0_D_26 <= nco_clock;
GPIO0_D_25 <= nco_clock;
GPIO0_D_24 <= nco_clock;
GPIO0_D_23 <= nco_clock;
GPIO0_D_22 <= nco_clock;
GPIO0_D_21 <= nco_clock;
GPIO0_D_20 <= nco_clock;
GPIO0_D_19 <= nco_clock;
GPIO0_D_18 <= nco_clock;
GPIO0_D_17 <= nco_clock;
GPIO0_D_16 <= nco_clock;
GPIO0_D_15 <= nco_clock;
GPIO0_D_14 <= nco_clock;
GPIO0_D_13 <= nco_clock;
GPIO0_D_12 <= nco_clock;
GPIO0_D_11 <= nco_clock;
GPIO0_D_10 <= nco_clock;
GPIO0_D_9  <= nco_clock;
GPIO0_D_8  <= nco_clock;
GPIO0_D_7  <= nco_clock;
GPIO0_D_6  <= nco_clock;
GPIO0_D_5  <= nco_clock;
GPIO0_D_4  <= nco_clock;
GPIO0_D_3  <= nco_clock;
GPIO0_D_2  <= nco_clock;
GPIO0_D_1  <= nco_clock;
GPIO0_D_0  <= nco_clock;


end rtl;