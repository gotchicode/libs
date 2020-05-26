library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity error_inject is
    generic (
            bit_size      : integer:=8
    );
 port (
            clk                 : in std_logic;
            rst_n               : in std_logic;
            
            error_rate          : in std_logic_vector(31 downto 0);
            error_rate_on_off   : in std_logic;
     
            data_in             : in std_logic_vector(bit_size-1 downto 0);
            data_in_en          : in std_logic;
            data_out            : out std_logic_vector(bit_size-1 downto 0);
            data_out_en         : out std_logic
 );
end entity error_inject;

architecture rtl of error_inject is

signal local_counter        : unsigned(31 downto 0);
signal gen_error            : std_logic;
signal data_in_d1           : std_logic_vector(bit_size-1 downto 0);
signal data_in_en_d1        : std_logic;

begin

--template_pr: process(clk, rst_n)
--begin
--    if rst_n='0' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

add_errors_pr: process(clk, rst_n)
begin
    if rst_n='0' then
    
        local_counter <= (others=>'0'); 
        gen_error     <= '0';

        data_in_d1    <= (others=>'0'); 
        data_in_en_d1 <= '0';  

        data_out      <= (others=>'0');   
        data_out_en   <= '0'; 
  
    elsif rising_edge(clk) then
    
        if data_in_en='1' and local_counter=(unsigned(error_rate)-1) then
            local_counter <= (others=>'0');
            gen_error     <= '1';
        elsif data_in_en='1' then
            local_counter <= local_counter+1;
            gen_error     <= '0';
        else
            local_counter <= local_counter;
            gen_error     <= '0';
        end if;
        data_in_d1        <= data_in;
        data_in_en_d1     <= data_in_en;

        if error_rate_on_off='1' then
            if gen_error='1' then
                data_out    <= data_in_d1;
                data_out(0) <= not(data_in_d1(0));
            else
                data_out    <= data_in_d1;
            end if;
        else
            data_out    <= data_in_d1;
        end if;
            data_out_en <= data_in_en_d1;
    end if;
end process;


end rtl;