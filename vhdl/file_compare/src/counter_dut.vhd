library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_dut is
    generic (
        cnt_max                     : integer:=16
    );
port(

    clk                             : in std_logic;
    rst                             : in std_logic;

    enable                          : in std_logic;

    data_out                        : out std_logic_vector(31 downto 0);
    data_out_en                     : out std_logic
    
 );
end entity counter_dut;


architecture rtl of counter_dut is

signal data_out_i                           : std_logic_vector(31 downto 0);
signal data_out_en_i                        : std_logic;

begin

main_pr: process(clk)
begin
    if rising_edge(clk) then

        if rst='1' then

            data_out_i          <= (others=>'0');
            data_out_en_i       <= '0';
        else

            if data_out_i=std_logic_vector(to_unsigned(cnt_max,32)) then
                data_out_en_i       <= '0';
            elsif enable='1' then
                data_out_i          <= std_logic_vector(unsigned(data_out_i)+1);
                data_out_en_i       <= '1';
            end if;

        end if;   

    end if;
end process;

data_out        <= data_out_i;
data_out_en     <= data_out_en_i;

end rtl;
