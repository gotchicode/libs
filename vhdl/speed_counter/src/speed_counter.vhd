library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity speed_counter is
generic(
    use_async_reset    :  boolean:=true;
    use_sync_reset     :  boolean:=true;
    async_reset_active :  std_logic:='1';
    sync_reset_active  :  std_logic:='1'
);
port(
    clock_from      : in std_logic;
    arst_clock_from : in std_logic;
    srst_clock_from : in std_logic;
    clock_to        : in std_logic;
    arst_clock_to   : in std_logic;
    srst_clock_to   : in std_logic;
    counter_a       : out std_logic_vector(15 downto 0);
    counter_b       : out std_logic_vector(15 downto 0)
);
end entity;

architecture rtl of speed_counter is

signal cnt_from                     : unsigned(15 downto 0);
signal cnt_from_msb                 : unsigned(0 downto 0);
signal cnt_from_msb_d1_metastable   : unsigned(0 downto 0);
signal cnt_from_msb_d2              : unsigned(0 downto 0);
signal cnt_from_msb_d3              : unsigned(0 downto 0);
signal counter_a_t                  : unsigned(15 downto 0);
signal counter_b_t                  : unsigned(15 downto 0);
    
begin


from_pr: process(clock_from, arst_clock_from)     
begin                               
    if (arst_clock_from=async_reset_active) and (use_async_reset=true) then
        cnt_from <= (others=>'0');
        cnt_from_msb <= "0";
    elsif rising_edge(clock_from) then  
        if (srst_clock_from=sync_reset_active) and (use_sync_reset=true) then
            cnt_from <= (others=>'0');
            cnt_from_msb <= "0";
        else
            cnt_from <= cnt_from+1; 
            cnt_from_msb <= cnt_from(cnt_from'left downto cnt_from'left);
        end if;
    end if;                         
end process;      

to_pr: process(clock_to, arst_clock_to)     
begin                               
    if (arst_clock_to=async_reset_active) and (use_async_reset=true) then
        cnt_from_msb_d1_metastable <= "0";
        cnt_from_msb_d2 <= "0";    
        cnt_from_msb_d3 <= "0";
        counter_a_t   <= (others=>'0');
        counter_b_t   <= (others=>'0');        
    elsif rising_edge(clock_to) then  
        if (srst_clock_to=sync_reset_active) and (use_sync_reset=true) then
            cnt_from_msb_d1_metastable <= "0";
            cnt_from_msb_d2 <= "0";    
            cnt_from_msb_d3 <= "0";
            counter_a_t   <= (others=>'0');
            counter_b_t   <= (others=>'0');  
        else
            cnt_from_msb_d1_metastable <= cnt_from_msb; 
            cnt_from_msb_d2 <= cnt_from_msb_d1_metastable;       
            cnt_from_msb_d3 <= cnt_from_msb_d2; 
            if cnt_from_msb_d2="1" and cnt_from_msb_d3="0" then
                counter_a_t <= (others=>'0');
                counter_a   <= std_logic_vector(counter_a_t);
                counter_b_t <= counter_b_t+1;
            else
                counter_a_t <= counter_a_t+1;
            end if;
            counter_b <= std_logic_vector(counter_b_t);
        end if;
    end if;                         
end process;




end rtl;
