library IEEE;                                                                 
use IEEE.std_logic_1164.all;                                                  
use IEEE.numeric_std.all;                                                     

entity polyphase_interp is      
generic(
    phase_mode : integer:=0
);
 port (                                                                       
            clk                 : in std_logic;                                   
            rst                 : in std_logic;              
    
            data_in             : in std_logic_vector(15 downto 0);
            data_in_en          : in std_logic;
            data_in_phase       : in std_logic_vector(31 downto 0); 
                
            data_out            : out std_logic_vector(15 downto 0);
            data_out_en         : out std_logic;

            resampling_clock    : in std_logic
            
 );                                                                           
end entity polyphase_interp;                                                                

architecture rtl of polyphase_interp is  

-- Phase difference calculation signals
signal data_saved                   : signed(15 downto 0);
signal phase_saved                  : signed(31 downto 0);
signal phase_sync                   : signed(31 downto 0);
signal data_saved_en                : std_logic;
signal resampling_clock_d1          : std_logic;
    
signal phase_difference             : signed(32 downto 0);
signal phase_difference_en          : std_logic;
    
signal data_saved_d1                : signed(15 downto 0);
signal data_saved_en_d1             : std_logic;

signal phase_difference_ready       : signed(32 downto 0);  
signal phase_difference_6b_ready    : signed(6 downto 0);
signal phase_difference_ready_en    : std_logic;  
signal data_ready                   : signed(15 downto 0);  
signal data_ready_en                : std_logic;  

    
begin

------------------------------------------------------------
-- Phase difference calculation
------------------------------------------------------------
process(clk, rst)                                                                  
begin                                                                         
    if rst='1' then
    
        data_saved                  <= (others=>'0');
        data_saved_en               <= '0';   
        phase_saved                 <= (others=>'0');    
        phase_sync                  <= (others=>'0'); 
        resampling_clock_d1         <= '0';

        phase_difference            <= (others=>'0');
        phase_difference_en         <= '0';    
        data_saved_d1               <= (others=>'0');
        data_saved_en_d1            <= '0';  

        phase_difference_ready      <= (others=>'0');   
        phase_difference_6b_ready   <= (others=>'0');
        phase_difference_ready_en   <= '0';
        data_ready                  <= (others=>'0');
        data_ready_en               <= '0';             

    elsif rising_edge(clk) then   

        --Stage 1
        if data_in_en='1' then
            phase_sync <= signed(data_in_phase);
            data_saved <= signed(data_in);
        end if;
        data_saved_en       <= data_in_en;
        resampling_clock_d1 <= resampling_clock;
        phase_saved         <= signed(data_in_phase); 
        
        --Stage 2
        if data_saved_en='1' and resampling_clock_d1='1' then
            phase_difference <= resize(phase_sync,33);
        elsif resampling_clock_d1='1' then
            phase_difference <= resize(phase_saved,33)-resize(phase_sync,33);
        end if;
        phase_difference_en <= resampling_clock_d1;
        data_saved_d1       <= data_saved;
        data_saved_en_d1    <= data_saved_en;
        
        --Stage 3
        phase_difference_ready      <= phase_difference;
        phase_difference_6b_ready   <= phase_difference(32 downto 26); --this should be rounded
        phase_difference_ready_en   <= phase_difference_en;
        data_ready                  <= data_saved_d1;
        data_ready_en               <= data_saved_en_d1;
        
    end if;                                                                   
end process; 

------------------------------------------------------------
-- Delaying samples
------------------------------------------------------------

end rtl;