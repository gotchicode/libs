library IEEE;                                                                 
use IEEE.std_logic_1164.all;                                                  
use IEEE.numeric_std.all;                                                     
                                                                              
entity clock_generator is                                                                  
 port (                                                                       
            clk             : in std_logic;                                   
            rst             : in std_logic;              

            conf_freq_in    : in std_logic_vector(31 downto 0);
            
            clock_out       : out std_logic;
            clock_phase_out : out std_logic_vector(31 downto 0);
            pulse_out       : out std_logic;
            pulse_phase_out : out std_logic_vector(31 downto 0)
 );                                                                           
end entity clock_generator;                                                                

architecture rtl of clock_generator is 
   
signal phase_reg    : std_logic_vector(31 downto 0):=(others=>'0');
signal phase_reg_d1 : std_logic_vector(31 downto 0):=(others=>'0');


begin

process(clk, rst)                                                                  
begin                                                                         
    if rst='1' then
        phase_reg       <= (others=>'0');
        phase_reg_d1    <= (others=>'0');
        clock_out       <= '0';
        clock_phase_out <= (others=>'0');
        pulse_out       <= '0';
        pulse_phase_out <= (others=>'0'); 
    elsif rising_edge(clk) then   
        phase_reg       <= std_logic_vector(unsigned(phase_reg) + unsigned(conf_freq_in));
        phase_reg_d1    <= phase_reg;
        clock_out       <= phase_reg(31);
        clock_phase_out <= phase_reg;
        pulse_out       <= phase_reg(31) and not(phase_reg_d1(31));
        if phase_reg(31)='1' and phase_reg_d1(31)='0' then
            pulse_phase_out <= phase_reg;
        end if;
    end if;                                                                   
end process; 

end rtl;