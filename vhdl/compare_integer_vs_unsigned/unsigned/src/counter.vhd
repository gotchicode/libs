library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
        clk     : in std_logic;
        
        enable  : in std_logic;
        reset   : in std_logic;
        
        flag    : out std_logic
);
end entity;

architecture rtl of counter is

constant max_cnt    : unsigned(31 downto 0):=to_unsigned(1000000,32);
signal cnt          : unsigned(31 downto 0):=to_unsigned(0,32);

begin


process(clk)
begin
    if rising_edge(clk) then
        if reset='1' then
            cnt <= (others=>'0');
            flag <= '0';
        elsif enable='1' then
            if cnt=max_cnt then
                flag <= '1';
            else
                cnt <= cnt+1;
                flag <= '0';
            end if;             
        end if;
    end if;
end process;

end rtl;