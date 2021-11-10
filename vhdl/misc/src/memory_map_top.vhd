library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory_map_top is
    generic (
        number_of_cells             : integer:=128;
        addr_width                  : integer:=7;
        data_width                  : integer:=32
        
    );
port(

    clk                             : in std_logic;
    
    addr                            : in std_logic_vector(addr_width-1 downto 0); 
    wr_en                           : in std_logic;  
    rd_en                           : in std_logic;
    data_write                      : in std_logic_vector(data_width-1 downto 0);
    data_read                       : out std_logic_vector(data_width-1 downto 0)
 );
end entity memory_map_top;


architecture rtl of memory_map_top is

type bank_registers_type                          is array (0 to number_of_cells-1) of std_logic_vector(data_width-1 downto 0);                
signal bank_registers_write                       : bank_registers_type;
signal bank_registers_read                        : bank_registers_type;


begin

------------------------------------------                                                           
-- write                                                               
------------------------------------------
write_pr: process(clk)
begin
    if rising_edge(clk) then

        if wr_en='1' then
            for I in 0 to number_of_cells-1 loop                                                             
                if addr=std_logic_vector(to_unsigned(I,addr_width)) then
                    bank_registers_write(I) <= data_write;
                end if;
            end loop;  
        end if;
    end if;
end process;

------------------------------------------                                                           
-- RAM read                                                               
------------------------------------------
read_pr: process(clk)
begin
    if rising_edge(clk) then

        if rd_en='1' then
            for I in 0 to number_of_cells-1 loop                                                             
                if addr=std_logic_vector(to_unsigned(I,addr_width)) then
                    data_read <= bank_registers_read(I);
                end if;
            end loop;  
        end if;
    end if;
end process;

------------------------------------------                                                           
-- Here a module to be instantiated                                                           
------------------------------------------


end rtl;