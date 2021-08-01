library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity single_ram is
    generic (
        number_of_cells             : integer:=4096;
        addr_width                  : integer:=12;
        data_width                  : integer:=16
        
    );
port(

    clk                             : in std_logic;
    
    add_write                       : in std_logic_vector(addr_width-1 downto 0); 
    data_write                      : in std_logic_vector(data_width-1 downto 0);
    wr_en                           : in std_logic;  

    add_read                        : in std_logic_vector(addr_width-1 downto 0); 
    rd_en                           : in std_logic; 
    data_read                       : out std_logic_vector(data_width-1 downto 0)
 );
end entity single_ram;

architecture rtl of single_ram is

type ram_type                          is array (0 to number_of_cells-1) of std_logic_vector(data_width-1 downto 0);                
signal ram                             : ram_type;    

begin

------------------------------------------                                                           
-- RAM write                                                               
------------------------------------------
ram_write_pr: process(clk)
begin
    if rising_edge(clk) then

        if wr_en='1' then
            for I in 0 to number_of_cells-1 loop                                                             
                if add_write=std_logic_vector(to_unsigned(I,addr_width)) then
                    ram(I) <= data_write;
                end if;
            end loop;  
        end if;
    end if;
end process;

------------------------------------------                                                           
-- RAM read                                                               
------------------------------------------
ram_read_pr: process(clk)
begin
    if rising_edge(clk) then

        if rd_en='1' then
            for I in 0 to number_of_cells-1 loop                                                             
                if add_read=std_logic_vector(to_unsigned(I,addr_width)) then
                    data_read <= ram(I);
                end if;
            end loop;  
        end if;
    end if;
end process;


end rtl;
    