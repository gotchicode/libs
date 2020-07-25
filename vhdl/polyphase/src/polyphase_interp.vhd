library IEEE;                                                                 
use IEEE.std_logic_1164.all;                                                  
use IEEE.numeric_std.all;                                                     
                                                                              
entity polyphase_interp is                                                                  
 port (                                                                       
            clk             : in std_logic;                                   
            rst             : in std_logic;              

            data_in         : in std_logic_vector(15 downto 0);
            data_in_en      : in std_logic;
            data_in_phase   : in std_logic_vector(31 downto 0); 
            
            data_out        : out std_logic_vector(15 downto 0);
            data_out_en     : out std_logic;

            frequency_prog  : in std_logic_vector(15 downto 0) 
            
 );                                                                           
end entity polyphase_interp;                                                                
                                                                              
architecture rtl of polyphase_interp is    

begin

process(clk, rst)                                                                  
begin                                                                         
    if rst='1' then
    elsif rising_edge(clk) then                                                                                        
    end if;                                                                   
end process; 

end rtl;