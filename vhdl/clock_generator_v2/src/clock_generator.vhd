library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_generator is
 port (
        rst             : in std_logic;
        clk             : in std_logic;
        clock_out       : out std_logic
 );
end entity clock_generator;

architecture rtl of clock_generator is

-- Constant  formula: frequency * 2^32 * 2^8 / 100 e6
constant counter_incr_const : unsigned(39 downto 0) := to_unsigned(integer(real(real(41.67)*real(4294967296.0)*real(256.0)/real(100000000))),40); 


signal phase_reg    : unsigned(39 downto 0):=(others=>'0');
signal phase_incr   : unsigned(39 downto 0):=(others=>'0');

begin

process(clk, rst)
begin
    if rst='1' then
        phase_reg       <= (others=>'0');
        clock_out       <= '0';
        phase_incr      <= counter_incr_const;
    elsif rising_edge(clk) then
        phase_reg       <= phase_reg + phase_incr;
        clock_out       <= phase_reg(39);
    end if;
end process;

end rtl;