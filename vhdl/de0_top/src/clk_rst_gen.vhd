
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_rst_gen is
    generic (  simu       : integer:=0
    );
 port (
            clk             : in std_logic;
            rst             : in std_logic;

            clk0            : out std_logic;
            rst0            : out std_logic;
            rstn0           : out std_logic

 );
end entity clk_rst_gen;

architecture rtl of clk_rst_gen is

signal locked           : std_logic;
signal locked_r1        : std_logic;
signal locked_r2        : std_logic;
signal locked_r3        : std_logic;

signal debounce_counter : unsigned(7 downto 0);
signal locked_debounced : std_logic;

signal clk0_inside      : std_logic;
signal rstn0_p1         : std_logic;
signal rstn0_p2         : std_logic;

begin

--template_pr: process(clk, rst)
--begin
--    if rst='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

label_on_simu: if simu = 1 generate 

    clk0_pr: process
    begin
    
        clk0_inside <= '0';
        wait for 5 ns;
        clk0_inside <= '1';
        wait for 5 ns;
        
    end process;
    
    locked_pr: process
    begin
    
        locked <= '0';
        wait for 1 us;
        locked <= '1';
        wait;

    end process;
    
end generate; 

label_not_on_simu: if simu = 0 generate 

    pll_inst: entity work.pll 
        PORT MAP
        (
            areset		=> rst,
            inclk0		=> clk,
            c0		    => clk0_inside,
            locked		=> locked
    );

end generate; 

clk0 <= clk0_inside;

--------------------------------------------------------
-- LOCK DEBOUNCE
--------------------------------------------------------

lock_debounce_pr: process(clk, rst)
begin
    if rst='1' then
    
        locked_r1 <= '0';
        locked_r2 <= '0';    
        locked_r3 <= '0'; 

        debounce_counter <= (others=>'0');
        locked_debounced <= '0'; 
        
    elsif rising_edge(clk) then
    
        locked_r1 <= locked; 
        locked_r2 <= locked_r1;     
        locked_r3 <= locked_r2;  

        if locked='0' then
            debounce_counter <= (others=>'0');
            locked_debounced <= '0';
        elsif locked='1' and debounce_counter=to_unsigned(100,8) then
            debounce_counter <= debounce_counter;
            locked_debounced <= '1';
        elsif locked='1' then
            debounce_counter <= debounce_counter+1;
            locked_debounced <= '0';
        end if;
        
    end if;
end process;

--------------------------------------------------------
-- CLK0 RESETS
--------------------------------------------------------

clk0_rst_sync_pr: process(clk0_inside, locked_debounced)
begin
    if locked_debounced='0' then
    
        rstn0_p1    <= '0';
        rstn0_p2    <= '0';
        rstn0       <= '0';
        rst0        <= '1';
        
    elsif rising_edge(clk0_inside) then
    
        rstn0_p1    <= locked_debounced;
        rstn0_p2    <= rstn0_p1;
        rstn0       <= rstn0_p2;
        rst0        <= not(rstn0_p2);
        
    end if;
end process;


end rtl;