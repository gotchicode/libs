library IEEE;                                                                                                                            
use IEEE.std_logic_1164.all;                                                                                                             
use IEEE.numeric_std.all;                                                                                                                
                                                                                                                                         
entity top is                                                                                                                            
 port (                                                                                                                                  
            clk             : in std_logic;                                                                                              
                                                                                                                                         
            data_in         : in std_logic;                                                                                              
			data_out		: out std_logic_vector(3 downto 0)                                                                            
                                                                                                                                         
 );                                                                                                                                      
end entity top;                                                                                                                          
                                                                                                                                         
architecture rtl of top is                                                                                                               
                                                                                                                                         
constant USE_MITIGATION             : integer:=2;                                                                                        
                                                                                                                                         
constant nb_reg                     : integer:=10; --(nb_reg-1 LUT on Xilinx target without mitigation)                                  
                                                                                                                                         
--signal lut_in                   : std_logic_vector(nb_reg-1 downto 0);                                                                 
--signal lut_out                  : std_logic_vector(nb_reg-1 downto 0);                                                                 
                                                                                                                                         
signal registers                    : std_logic_vector(nb_reg-1 downto 0);                                                               
--signal registers_d1             : std_logic_vector(nb_reg-1 downto 0);                                                                 
                                                                                                                                         
type tmr_reg_type                   is array (0 to 2) of std_logic_vector(nb_reg-1 downto 0);                                            
signal tmr_registers                : tmr_reg_type;                                                                                      
signal local_tmr_voter              : std_logic_vector(nb_reg-1 downto 0);                                                               
signal global_tmr_voter             : tmr_reg_type;                                                                                      
                                                                                                                                         
attribute keep                      : string;                                                                                            
attribute keep of registers         : signal is "true";                                                                                  
attribute keep of tmr_registers     : signal is "true";                                                                                  
attribute keep of local_tmr_voter   : signal is "true";                                                                                  
attribute keep of global_tmr_voter  : signal is "true";                                                                                  
                                                                                                                                         
begin                                                                                                                                    
                                                                                                                                         
----------------------------------------------------------------------------------------------------------------------------             
--                                                                                                                                       
--                                                                                                                                       
--              NO MITIGATION IN THE DESIGN                                                                                              
--                                                                                                                                       
--                                                                                                                                       
----------------------------------------------------------------------------------------------------------------------------             
                                                                                                                                         
NO_MITIGATION: if USE_MITIGATION=0 generate                                                                                              
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Input                                                                                                                             
    ------------------------------------------                                                                                           
    registers(0) <= data_in;                                                                                                             
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Combinatiorial + Registers                                                                                                        
    ------------------------------------------                                                                                           
    process(clk)                                                                                                                         
    begin                                                                                                                                
                                                                                                                                         
        if rising_edge(clk) then                                                                                                         
                                                                                                                                         
                registers(1)    <= not(registers(0));                                                                              
                registers(2)    <= not(registers(1));                                                                              
                registers(3)    <= not(registers(2));                                                                              
                registers(4)    <= not(registers(3));                                                                              
                registers(5)    <= not(registers(4));                                                                              
                registers(6)    <= not(registers(5));                                                                              
                registers(7)    <= not(registers(6));                                                                              
                registers(8)    <= not(registers(7));                                                                              
                registers(9)    <= not(registers(8));                                                                              
                                                                                                                                         
        end if;                                                                                                                          
    end process;                                                                                                                         
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Outputs                                                                                                                           
    ------------------------------------------                                                                                           
    process(clk)                                                                                                                         
    begin                                                                                                                                
                                                                                                                                         
        if rising_edge(clk) then                                                                                                         
                                                                                                                                         
            data_out(0) <= registers(nb_reg-4);                                                                                          
            data_out(1) <= registers(nb_reg-3);                                                                                          
            data_out(2) <= registers(nb_reg-2);                                                                                          
            data_out(3) <= registers(nb_reg-1);                                                                                          
                                                                                                                                         
        end if;                                                                                                                          
    end process;                                                                                                                         
                                                                                                                                         
end generate NO_MITIGATION;                                                                                                              
                                                                                                                                         
----------------------------------------------------------------------------------------------------------------------------             
--                                                                                                                                       
--                                                                                                                                       
--              Local TMR                                                                                                                
--                                                                                                                                       
--                                                                                                                                       
----------------------------------------------------------------------------------------------------------------------------             
                                                                                                                                         
LOCAL_TMR_MITIGATION: if USE_MITIGATION=1 generate                                                                                       
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Input                                                                                                                             
    ------------------------------------------                                                                                           
                                                                                                                                         
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Combinatiorial + Registers                                                                                                        
    ------------------------------------------                                                                                           
    process(clk)                                                                                                                         
    begin                                                                                                                                
                                                                                                                                         
        if rising_edge(clk) then                                                                                                         
                                                                                                                                         
                tmr_registers(0)(1)    <= not(local_tmr_voter(0));                                                                           
                tmr_registers(1)(1)    <= not(local_tmr_voter(0));                                                                           
                tmr_registers(2)(1)    <= not(local_tmr_voter(0));                                                                           
 
                tmr_registers(0)(2)    <= not(local_tmr_voter(1));                                                                           
                tmr_registers(1)(2)    <= not(local_tmr_voter(1));                                                                           
                tmr_registers(2)(2)    <= not(local_tmr_voter(1));                                                                           
 
                tmr_registers(0)(3)    <= not(local_tmr_voter(2));                                                                           
                tmr_registers(1)(3)    <= not(local_tmr_voter(2));                                                                           
                tmr_registers(2)(3)    <= not(local_tmr_voter(2));                                                                           
 
                tmr_registers(0)(4)    <= not(local_tmr_voter(3));                                                                           
                tmr_registers(1)(4)    <= not(local_tmr_voter(3));                                                                           
                tmr_registers(2)(4)    <= not(local_tmr_voter(3));                                                                           
 
                tmr_registers(0)(5)    <= not(local_tmr_voter(4));                                                                           
                tmr_registers(1)(5)    <= not(local_tmr_voter(4));                                                                           
                tmr_registers(2)(5)    <= not(local_tmr_voter(4));                                                                           
 
                tmr_registers(0)(6)    <= not(local_tmr_voter(5));                                                                           
                tmr_registers(1)(6)    <= not(local_tmr_voter(5));                                                                           
                tmr_registers(2)(6)    <= not(local_tmr_voter(5));                                                                           
 
                tmr_registers(0)(7)    <= not(local_tmr_voter(6));                                                                           
                tmr_registers(1)(7)    <= not(local_tmr_voter(6));                                                                           
                tmr_registers(2)(7)    <= not(local_tmr_voter(6));                                                                           
 
                tmr_registers(0)(8)    <= not(local_tmr_voter(7));                                                                           
                tmr_registers(1)(8)    <= not(local_tmr_voter(7));                                                                           
                tmr_registers(2)(8)    <= not(local_tmr_voter(7));                                                                           
 
                tmr_registers(0)(9)    <= not(local_tmr_voter(8));                                                                           
                tmr_registers(1)(9)    <= not(local_tmr_voter(8));                                                                           
                tmr_registers(2)(9)    <= not(local_tmr_voter(8));                                                                           
 
                                                                                                                                         
        end if;                                                                                                                          
    end process;                                                                                                                         
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Voter                                                                                                                             
    ------------------------------------------                                                                                           
                                                                                                                                         
        local_tmr_voter(0)  <= data_in;                                                                                                        
                                                                                                                                         
        local_tmr_voter(1)  <=    (tmr_registers(0)(1) and tmr_registers(1)(1)) or                                                             
                            (tmr_registers(1)(1) and tmr_registers(2)(1)) or                                                             
                            (tmr_registers(0)(1) and tmr_registers(2)(1));                                                               
                                                                                                                                         
        local_tmr_voter(2)  <=    (tmr_registers(0)(2) and tmr_registers(1)(2)) or                                                             
                            (tmr_registers(1)(2) and tmr_registers(2)(2)) or                                                             
                            (tmr_registers(0)(2) and tmr_registers(2)(2));                                                               
                                                                                                                                         
        local_tmr_voter(3)  <=    (tmr_registers(0)(3) and tmr_registers(1)(3)) or                                                             
                            (tmr_registers(1)(3) and tmr_registers(2)(3)) or                                                             
                            (tmr_registers(0)(3) and tmr_registers(2)(3));                                                               
                                                                                                                                         
        local_tmr_voter(4)  <=    (tmr_registers(0)(4) and tmr_registers(1)(4)) or                                                             
                            (tmr_registers(1)(4) and tmr_registers(2)(4)) or                                                             
                            (tmr_registers(0)(4) and tmr_registers(2)(4));                                                               
                                                                                                                                         
        local_tmr_voter(5)  <=    (tmr_registers(0)(5) and tmr_registers(1)(5)) or                                                             
                            (tmr_registers(1)(5) and tmr_registers(2)(5)) or                                                             
                            (tmr_registers(0)(5) and tmr_registers(2)(5));                                                               
                                                                                                                                         
        local_tmr_voter(6)  <=    (tmr_registers(0)(6) and tmr_registers(1)(6)) or                                                             
                            (tmr_registers(1)(6) and tmr_registers(2)(6)) or                                                             
                            (tmr_registers(0)(6) and tmr_registers(2)(6));                                                               
                                                                                                                                         
        local_tmr_voter(7)  <=    (tmr_registers(0)(7) and tmr_registers(1)(7)) or                                                             
                            (tmr_registers(1)(7) and tmr_registers(2)(7)) or                                                             
                            (tmr_registers(0)(7) and tmr_registers(2)(7));                                                               
                                                                                                                                         
        local_tmr_voter(8)  <=    (tmr_registers(0)(8) and tmr_registers(1)(8)) or                                                             
                            (tmr_registers(1)(8) and tmr_registers(2)(8)) or                                                             
                            (tmr_registers(0)(8) and tmr_registers(2)(8));                                                               
                                                                                                                                         
        local_tmr_voter(9)  <=    (tmr_registers(0)(9) and tmr_registers(1)(9)) or                                                             
                            (tmr_registers(1)(9) and tmr_registers(2)(9)) or                                                             
                            (tmr_registers(0)(9) and tmr_registers(2)(9));                                                               
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Outputs                                                                                                                           
    ------------------------------------------                                                                                           
                                                                                                                                         
    data_out(0) <= local_tmr_voter(nb_reg-4);                                                                                                  
    data_out(1) <= local_tmr_voter(nb_reg-3);                                                                                                  
    data_out(2) <= local_tmr_voter(nb_reg-2);                                                                                                  
    data_out(3) <= local_tmr_voter(nb_reg-1);                                                                                                  
                                                                                                                                         
                                                                                                                                         
end generate LOCAL_TMR_MITIGATION;                                                                                                       
                                                                                                                                         
----------------------------------------------------------------------------------------------------------------------------             
--                                                                                                                                       
--                                                                                                                                       
--              Global TMR                                                                                                               
--                                                                                                                                       
--                                                                                                                                       
----------------------------------------------------------------------------------------------------------------------------             
                                                                                                                                         
GLOBAL_TMR_MITIGATION: if USE_MITIGATION=2 generate                                                                                      
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Input                                                                                                                             
    ------------------------------------------                                                                                           
                                                                                                                                         
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Combinatiorial + Registers                                                                                                        
    ------------------------------------------                                                                                           
    process(clk)                                                                                                                         
    begin                                                                                                                                
                                                                                                                                         
        if rising_edge(clk) then                                                                                                         
                                                                                                                                         
                tmr_registers(0)(1)    <= not(global_tmr_voter(0)(0));                                                             
                tmr_registers(1)(1)    <= not(global_tmr_voter(1)(0));                                                             
                tmr_registers(2)(1)    <= not(global_tmr_voter(2)(0));                                                             
 
                tmr_registers(0)(2)    <= not(global_tmr_voter(0)(1));                                                             
                tmr_registers(1)(2)    <= not(global_tmr_voter(1)(1));                                                             
                tmr_registers(2)(2)    <= not(global_tmr_voter(2)(1));                                                             
 
                tmr_registers(0)(3)    <= not(global_tmr_voter(0)(2));                                                             
                tmr_registers(1)(3)    <= not(global_tmr_voter(1)(2));                                                             
                tmr_registers(2)(3)    <= not(global_tmr_voter(2)(2));                                                             
 
                tmr_registers(0)(4)    <= not(global_tmr_voter(0)(3));                                                             
                tmr_registers(1)(4)    <= not(global_tmr_voter(1)(3));                                                             
                tmr_registers(2)(4)    <= not(global_tmr_voter(2)(3));                                                             
 
                tmr_registers(0)(5)    <= not(global_tmr_voter(0)(4));                                                             
                tmr_registers(1)(5)    <= not(global_tmr_voter(1)(4));                                                             
                tmr_registers(2)(5)    <= not(global_tmr_voter(2)(4));                                                             
 
                tmr_registers(0)(6)    <= not(global_tmr_voter(0)(5));                                                             
                tmr_registers(1)(6)    <= not(global_tmr_voter(1)(5));                                                             
                tmr_registers(2)(6)    <= not(global_tmr_voter(2)(5));                                                             
 
                tmr_registers(0)(7)    <= not(global_tmr_voter(0)(6));                                                             
                tmr_registers(1)(7)    <= not(global_tmr_voter(1)(6));                                                             
                tmr_registers(2)(7)    <= not(global_tmr_voter(2)(6));                                                             
 
                tmr_registers(0)(8)    <= not(global_tmr_voter(0)(7));                                                             
                tmr_registers(1)(8)    <= not(global_tmr_voter(1)(7));                                                             
                tmr_registers(2)(8)    <= not(global_tmr_voter(2)(7));                                                             
 
                tmr_registers(0)(9)    <= not(global_tmr_voter(0)(8));                                                             
                tmr_registers(1)(9)    <= not(global_tmr_voter(1)(8));                                                             
                tmr_registers(2)(9)    <= not(global_tmr_voter(2)(8));                                                             
 
                                                                                                                                         
        end if;                                                                                                                          
    end process;                                                                                                                         
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Voter                                                                                                                             
    ------------------------------------------                                                                                           
                                                                                                                                         
        global_tmr_voter(0)(0)  <= data_in;                                                                                              
        global_tmr_voter(1)(0)  <= data_in;                                                                                              
        global_tmr_voter(2)(0)  <= data_in;                                                                                              
                                                                                                                                     
        global_tmr_voter(0)(1)  <=    (tmr_registers(0)(1) and tmr_registers(1)(1)) or                                            
                            (tmr_registers(1)(1) and tmr_registers(2)(1)) or                                                       
                            (tmr_registers(0)(1) and tmr_registers(2)(1));                                                         
                                                                                                                                     
        global_tmr_voter(0)(2)  <=    (tmr_registers(0)(2) and tmr_registers(1)(2)) or                                            
                            (tmr_registers(1)(2) and tmr_registers(2)(2)) or                                                       
                            (tmr_registers(0)(2) and tmr_registers(2)(2));                                                         
                                                                                                                                     
        global_tmr_voter(0)(3)  <=    (tmr_registers(0)(3) and tmr_registers(1)(3)) or                                            
                            (tmr_registers(1)(3) and tmr_registers(2)(3)) or                                                       
                            (tmr_registers(0)(3) and tmr_registers(2)(3));                                                         
                                                                                                                                     
        global_tmr_voter(0)(4)  <=    (tmr_registers(0)(4) and tmr_registers(1)(4)) or                                            
                            (tmr_registers(1)(4) and tmr_registers(2)(4)) or                                                       
                            (tmr_registers(0)(4) and tmr_registers(2)(4));                                                         
                                                                                                                                     
        global_tmr_voter(0)(5)  <=    (tmr_registers(0)(5) and tmr_registers(1)(5)) or                                            
                            (tmr_registers(1)(5) and tmr_registers(2)(5)) or                                                       
                            (tmr_registers(0)(5) and tmr_registers(2)(5));                                                         
                                                                                                                                     
        global_tmr_voter(0)(6)  <=    (tmr_registers(0)(6) and tmr_registers(1)(6)) or                                            
                            (tmr_registers(1)(6) and tmr_registers(2)(6)) or                                                       
                            (tmr_registers(0)(6) and tmr_registers(2)(6));                                                         
                                                                                                                                     
        global_tmr_voter(0)(7)  <=    (tmr_registers(0)(7) and tmr_registers(1)(7)) or                                            
                            (tmr_registers(1)(7) and tmr_registers(2)(7)) or                                                       
                            (tmr_registers(0)(7) and tmr_registers(2)(7));                                                         
                                                                                                                                     
        global_tmr_voter(0)(8)  <=    (tmr_registers(0)(8) and tmr_registers(1)(8)) or                                            
                            (tmr_registers(1)(8) and tmr_registers(2)(8)) or                                                       
                            (tmr_registers(0)(8) and tmr_registers(2)(8));                                                         
                                                                                                                                     
        global_tmr_voter(0)(9)  <=    (tmr_registers(0)(9) and tmr_registers(1)(9)) or                                            
                            (tmr_registers(1)(9) and tmr_registers(2)(9)) or                                                       
                            (tmr_registers(0)(9) and tmr_registers(2)(9));                                                         
                                                                                                                                         
                                                                                                                                     
        global_tmr_voter(1)(1)  <=    (tmr_registers(0)(1) and tmr_registers(1)(1)) or                                            
                            (tmr_registers(1)(1) and tmr_registers(2)(1)) or                                                       
                            (tmr_registers(0)(1) and tmr_registers(2)(1));                                                         
                                                                                                                                     
        global_tmr_voter(1)(2)  <=    (tmr_registers(0)(2) and tmr_registers(1)(2)) or                                            
                            (tmr_registers(1)(2) and tmr_registers(2)(2)) or                                                       
                            (tmr_registers(0)(2) and tmr_registers(2)(2));                                                         
                                                                                                                                     
        global_tmr_voter(1)(3)  <=    (tmr_registers(0)(3) and tmr_registers(1)(3)) or                                            
                            (tmr_registers(1)(3) and tmr_registers(2)(3)) or                                                       
                            (tmr_registers(0)(3) and tmr_registers(2)(3));                                                         
                                                                                                                                     
        global_tmr_voter(1)(4)  <=    (tmr_registers(0)(4) and tmr_registers(1)(4)) or                                            
                            (tmr_registers(1)(4) and tmr_registers(2)(4)) or                                                       
                            (tmr_registers(0)(4) and tmr_registers(2)(4));                                                         
                                                                                                                                     
        global_tmr_voter(1)(5)  <=    (tmr_registers(0)(5) and tmr_registers(1)(5)) or                                            
                            (tmr_registers(1)(5) and tmr_registers(2)(5)) or                                                       
                            (tmr_registers(0)(5) and tmr_registers(2)(5));                                                         
                                                                                                                                     
        global_tmr_voter(1)(6)  <=    (tmr_registers(0)(6) and tmr_registers(1)(6)) or                                            
                            (tmr_registers(1)(6) and tmr_registers(2)(6)) or                                                       
                            (tmr_registers(0)(6) and tmr_registers(2)(6));                                                         
                                                                                                                                     
        global_tmr_voter(1)(7)  <=    (tmr_registers(0)(7) and tmr_registers(1)(7)) or                                            
                            (tmr_registers(1)(7) and tmr_registers(2)(7)) or                                                       
                            (tmr_registers(0)(7) and tmr_registers(2)(7));                                                         
                                                                                                                                     
        global_tmr_voter(1)(8)  <=    (tmr_registers(0)(8) and tmr_registers(1)(8)) or                                            
                            (tmr_registers(1)(8) and tmr_registers(2)(8)) or                                                       
                            (tmr_registers(0)(8) and tmr_registers(2)(8));                                                         
                                                                                                                                     
        global_tmr_voter(1)(9)  <=    (tmr_registers(0)(9) and tmr_registers(1)(9)) or                                            
                            (tmr_registers(1)(9) and tmr_registers(2)(9)) or                                                       
                            (tmr_registers(0)(9) and tmr_registers(2)(9));                                                         
                                                                                                                                     
        global_tmr_voter(2)(1)  <=    (tmr_registers(0)(1) and tmr_registers(1)(1)) or                                            
                            (tmr_registers(1)(1) and tmr_registers(2)(1)) or                                                       
                            (tmr_registers(0)(1) and tmr_registers(2)(1));                                                         
                                                                                                                                     
        global_tmr_voter(2)(2)  <=    (tmr_registers(0)(2) and tmr_registers(1)(2)) or                                            
                            (tmr_registers(1)(2) and tmr_registers(2)(2)) or                                                       
                            (tmr_registers(0)(2) and tmr_registers(2)(2));                                                         
                                                                                                                                     
        global_tmr_voter(2)(3)  <=    (tmr_registers(0)(3) and tmr_registers(1)(3)) or                                            
                            (tmr_registers(1)(3) and tmr_registers(2)(3)) or                                                       
                            (tmr_registers(0)(3) and tmr_registers(2)(3));                                                         
                                                                                                                                     
        global_tmr_voter(2)(4)  <=    (tmr_registers(0)(4) and tmr_registers(1)(4)) or                                            
                            (tmr_registers(1)(4) and tmr_registers(2)(4)) or                                                       
                            (tmr_registers(0)(4) and tmr_registers(2)(4));                                                         
                                                                                                                                     
        global_tmr_voter(2)(5)  <=    (tmr_registers(0)(5) and tmr_registers(1)(5)) or                                            
                            (tmr_registers(1)(5) and tmr_registers(2)(5)) or                                                       
                            (tmr_registers(0)(5) and tmr_registers(2)(5));                                                         
                                                                                                                                     
        global_tmr_voter(2)(6)  <=    (tmr_registers(0)(6) and tmr_registers(1)(6)) or                                            
                            (tmr_registers(1)(6) and tmr_registers(2)(6)) or                                                       
                            (tmr_registers(0)(6) and tmr_registers(2)(6));                                                         
                                                                                                                                     
        global_tmr_voter(2)(7)  <=    (tmr_registers(0)(7) and tmr_registers(1)(7)) or                                            
                            (tmr_registers(1)(7) and tmr_registers(2)(7)) or                                                       
                            (tmr_registers(0)(7) and tmr_registers(2)(7));                                                         
                                                                                                                                     
        global_tmr_voter(2)(8)  <=    (tmr_registers(0)(8) and tmr_registers(1)(8)) or                                            
                            (tmr_registers(1)(8) and tmr_registers(2)(8)) or                                                       
                            (tmr_registers(0)(8) and tmr_registers(2)(8));                                                         
                                                                                                                                     
        global_tmr_voter(2)(9)  <=    (tmr_registers(0)(9) and tmr_registers(1)(9)) or                                            
                            (tmr_registers(1)(9) and tmr_registers(2)(9)) or                                                       
                            (tmr_registers(0)(9) and tmr_registers(2)(9));                                                         
                                                                                                                                         
    ------------------------------------------                                                                                           
    -- Outputs                                                                                                                           
    ------------------------------------------                                                                                           
                                                                                                                                         
    data_out(0) <= global_tmr_voter(0)(nb_reg-4);                                                                                        
    data_out(1) <= global_tmr_voter(1)(nb_reg-3);                                                                                        
    data_out(2) <= global_tmr_voter(2)(nb_reg-2);                                                                                        
    data_out(3) <= '0';                                                                                                                
                                                                                                                                         
                                                                                                                                         
end generate GLOBAL_TMR_MITIGATION;                                                                                                      
                                                                                                                                         
                                                                                                                                         
end rtl;                                                                                                                                 
