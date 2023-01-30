library IEEE;                                                                                            
use IEEE.std_logic_1164.all;                                                                             
use IEEE.numeric_std.all;                                                                                
use     ieee.math_real.all;                                                                              
                                                                                                         
entity fir_with_opt_accu is                                                                                            
 port (                                                                                                  
            clk             : in std_logic;                                                              
                                                                                                         
            data_in         : in std_logic_vector(11 downto 0);                                          
            data_in_en      : in std_logic;                                                              
                                                                                                         
			data_out		: out std_logic_vector(11 downto 0);                                          
			data_out_en		: out std_logic                                                               
                                                                                                         
 );                                                                                                      
end entity fir_with_opt_accu;                                                                                          
                                                                                                         
architecture rtl of fir_with_opt_accu is                                                                               
                                                                                                         
                                                                                                         
                                                                                                         
constant nb_taps                        : integer:=21;                                                   
type taps_type                          is array (0 to nb_taps-1) of signed(13 downto 0);                
signal taps                             : taps_type;                                                     
type fir_reg_type                       is array (0 to nb_taps-1) of signed(11 downto 0);                
signal fir_reg                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d1                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d2                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d3                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d4                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d5                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d6                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d7                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d8                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d9                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d10                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d11                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d12                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d13                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d14                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d15                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d16                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d17                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d18                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d19                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d20                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d21                          : fir_reg_type:=(others=>(others=>'0'));                        
type taps_x_fir_reg_type                is array (0 to nb_taps-1) of signed(25 downto 0);                
signal taps_x_fir_reg                   : taps_x_fir_reg_type;                                           
                                                                                                         
                                                                                                         
                                                                                                         
type taps_x_fir_reg_accu_type           is array (0 to nb_taps) of signed(63 downto 0);                  
signal taps_x_fir_reg_accu              : taps_x_fir_reg_accu_type:=(others=>(others=>'0')); 
signal taps_x_fir_reg_accu_en           : std_logic_vector(nb_taps-1 downto 0);                          
                                                                                                         
                                                                                                         
                                                                                                         
signal data_in_en_r1               : std_logic;                                                          
signal data_in_en_r2               : std_logic;                                                          
signal data_in_en_r3               : std_logic;                                                          
signal data_out_prepare            : std_logic_vector(11 downto 0);                                      
signal data_out_prepare_en         : std_logic;                                                          
                                                                                                         
begin                                                                                                    
                                                                                                         
                                                                                                         
                                                                                                         
    ------------------------------------------                                                           
    -- Fir implementation                                                                                
    ------------------------------------------                                                           
    process(clk)                                                                                         
    variable v_round : signed(1 downto 0);                                                               
    begin                                                                                                
                                                                                                         
        if rising_edge(clk) then                                                                         
                                                                                                         
            --shift registers                                                                            
            if data_in_en='1' then                                                                     
                fir_reg(0) <= signed(data_in);                                                           
                for I in 1 to nb_taps-1 loop                                                             
                       fir_reg(I) <= fir_reg(I-1);                                                       
                    end loop;                                                                            
            end if;                                                                                      
            data_in_en_r1 <= data_in_en;                                                                 
            data_in_en_r2 <= data_in_en_r1;                                                                 
                                                                                                         
            --multiply                                                                                   
            --First tap                                                                                  
            taps_x_fir_reg_accu(0) <= resize(fir_reg(0) *  taps(0),64);                                  
            fir_reg_d1 <= fir_reg;                                                                       
            taps_x_fir_reg_accu_en(0)<= data_in_en_r2;                                                   
                                                                                                         
            fir_reg_d2 <= fir_reg_d1;                                                                 
            taps_x_fir_reg(1)           <= fir_reg_d1(1) *  taps(1);                                                 
            taps_x_fir_reg_accu(1)      <= taps_x_fir_reg(1) + taps_x_fir_reg_accu(0);                                    
            taps_x_fir_reg_accu_en(1)   <= taps_x_fir_reg_accu_en(0);                                  
                                                                                                         
            fir_reg_d3 <= fir_reg_d2;                                                                 
            taps_x_fir_reg(2)           <= fir_reg_d2(2) *  taps(2);                                                 
            taps_x_fir_reg_accu(2)      <= taps_x_fir_reg(2) + taps_x_fir_reg_accu(1);                                    
            taps_x_fir_reg_accu_en(2)   <= taps_x_fir_reg_accu_en(1);                                  
                                                                                                         
            fir_reg_d4 <= fir_reg_d3;                                                                 
            taps_x_fir_reg(3)           <= fir_reg_d3(3) *  taps(3);                                                 
            taps_x_fir_reg_accu(3)      <= taps_x_fir_reg(3) + taps_x_fir_reg_accu(2);                                    
            taps_x_fir_reg_accu_en(3)   <= taps_x_fir_reg_accu_en(2);                                  
                                                                                                         
            fir_reg_d5 <= fir_reg_d4;                                                                 
            taps_x_fir_reg(4)           <= fir_reg_d4(4) *  taps(4);                                                 
            taps_x_fir_reg_accu(4)      <= taps_x_fir_reg(4) + taps_x_fir_reg_accu(3);                                    
            taps_x_fir_reg_accu_en(4)   <= taps_x_fir_reg_accu_en(3);                                  
                                                                                                         
            fir_reg_d6 <= fir_reg_d5;                                                                 
            taps_x_fir_reg(5)           <= fir_reg_d5(5) *  taps(5);                                                 
            taps_x_fir_reg_accu(5)      <= taps_x_fir_reg(5) + taps_x_fir_reg_accu(4);                                    
            taps_x_fir_reg_accu_en(5)   <= taps_x_fir_reg_accu_en(4);                                  
                                                                                                         
            fir_reg_d7 <= fir_reg_d6;                                                                 
            taps_x_fir_reg(6)           <= fir_reg_d6(6) *  taps(6);                                                 
            taps_x_fir_reg_accu(6)      <= taps_x_fir_reg(6) + taps_x_fir_reg_accu(5);                                    
            taps_x_fir_reg_accu_en(6)   <= taps_x_fir_reg_accu_en(5);                                  
                                                                                                         
            fir_reg_d8 <= fir_reg_d7;                                                                 
            taps_x_fir_reg(7)           <= fir_reg_d7(7) *  taps(7);                                                 
            taps_x_fir_reg_accu(7)      <= taps_x_fir_reg(7) + taps_x_fir_reg_accu(6);                                    
            taps_x_fir_reg_accu_en(7)   <= taps_x_fir_reg_accu_en(6);                                  
                                                                                                         
            fir_reg_d9 <= fir_reg_d8;                                                                 
            taps_x_fir_reg(8)           <= fir_reg_d8(8) *  taps(8);                                                 
            taps_x_fir_reg_accu(8)      <= taps_x_fir_reg(8) + taps_x_fir_reg_accu(7);                                    
            taps_x_fir_reg_accu_en(8)   <= taps_x_fir_reg_accu_en(7);                                  
                                                                                                         
            fir_reg_d10 <= fir_reg_d9;                                                                 
            taps_x_fir_reg(9)           <= fir_reg_d9(9) *  taps(9);                                                 
            taps_x_fir_reg_accu(9)      <= taps_x_fir_reg(9) + taps_x_fir_reg_accu(8);                                    
            taps_x_fir_reg_accu_en(9)   <= taps_x_fir_reg_accu_en(8);                                  
                                                                                                         
            fir_reg_d11 <= fir_reg_d10;                                                                 
            taps_x_fir_reg(10)           <= fir_reg_d10(10) *  taps(10);                                                 
            taps_x_fir_reg_accu(10)      <= taps_x_fir_reg(10) + taps_x_fir_reg_accu(9);                                    
            taps_x_fir_reg_accu_en(10)   <= taps_x_fir_reg_accu_en(9);                                  
                                                                                                         
            fir_reg_d12 <= fir_reg_d11;                                                                 
            taps_x_fir_reg(11)           <= fir_reg_d11(11) *  taps(11);                                                 
            taps_x_fir_reg_accu(11)      <= taps_x_fir_reg(11) + taps_x_fir_reg_accu(10);                                    
            taps_x_fir_reg_accu_en(11)   <= taps_x_fir_reg_accu_en(10);                                  
                                                                                                         
            fir_reg_d13 <= fir_reg_d12;                                                                 
            taps_x_fir_reg(12)           <= fir_reg_d12(12) *  taps(12);                                                 
            taps_x_fir_reg_accu(12)      <= taps_x_fir_reg(12) + taps_x_fir_reg_accu(11);                                    
            taps_x_fir_reg_accu_en(12)   <= taps_x_fir_reg_accu_en(11);                                  
                                                                                                         
            fir_reg_d14 <= fir_reg_d13;                                                                 
            taps_x_fir_reg(13)           <= fir_reg_d13(13) *  taps(13);                                                 
            taps_x_fir_reg_accu(13)      <= taps_x_fir_reg(13) + taps_x_fir_reg_accu(12);                                    
            taps_x_fir_reg_accu_en(13)   <= taps_x_fir_reg_accu_en(12);                                  
                                                                                                         
            fir_reg_d15 <= fir_reg_d14;                                                                 
            taps_x_fir_reg(14)           <= fir_reg_d14(14) *  taps(14);                                                 
            taps_x_fir_reg_accu(14)      <= taps_x_fir_reg(14) + taps_x_fir_reg_accu(13);                                    
            taps_x_fir_reg_accu_en(14)   <= taps_x_fir_reg_accu_en(13);                                  
                                                                                                         
            fir_reg_d16 <= fir_reg_d15;                                                                 
            taps_x_fir_reg(15)           <= fir_reg_d15(15) *  taps(15);                                                 
            taps_x_fir_reg_accu(15)      <= taps_x_fir_reg(15) + taps_x_fir_reg_accu(14);                                    
            taps_x_fir_reg_accu_en(15)   <= taps_x_fir_reg_accu_en(14);                                  
                                                                                                         
            fir_reg_d17 <= fir_reg_d16;                                                                 
            taps_x_fir_reg(16)           <= fir_reg_d16(16) *  taps(16);                                                 
            taps_x_fir_reg_accu(16)      <= taps_x_fir_reg(16) + taps_x_fir_reg_accu(15);                                    
            taps_x_fir_reg_accu_en(16)   <= taps_x_fir_reg_accu_en(15);                                  
                                                                                                         
            fir_reg_d18 <= fir_reg_d17;                                                                 
            taps_x_fir_reg(17)           <= fir_reg_d17(17) *  taps(17);                                                 
            taps_x_fir_reg_accu(17)      <= taps_x_fir_reg(17) + taps_x_fir_reg_accu(16);                                    
            taps_x_fir_reg_accu_en(17)   <= taps_x_fir_reg_accu_en(16);                                  
                                                                                                         
            fir_reg_d19 <= fir_reg_d18;                                                                 
            taps_x_fir_reg(18)           <= fir_reg_d18(18) *  taps(18);                                                 
            taps_x_fir_reg_accu(18)      <= taps_x_fir_reg(18) + taps_x_fir_reg_accu(17);                                    
            taps_x_fir_reg_accu_en(18)   <= taps_x_fir_reg_accu_en(17);                                  
                                                                                                         
            fir_reg_d20 <= fir_reg_d19;                                                                 
            taps_x_fir_reg(19)           <= fir_reg_d19(19) *  taps(19);                                                 
            taps_x_fir_reg_accu(19)      <= taps_x_fir_reg(19) + taps_x_fir_reg_accu(18);                                    
            taps_x_fir_reg_accu_en(19)   <= taps_x_fir_reg_accu_en(18);                                  
                                                                                                         
            fir_reg_d21 <= fir_reg_d20;                                                                 
            taps_x_fir_reg(20)           <= fir_reg_d20(20) *  taps(20);                                                 
            taps_x_fir_reg_accu(20)      <= taps_x_fir_reg(20) + taps_x_fir_reg_accu(19);                                    
            taps_x_fir_reg_accu_en(20)   <= taps_x_fir_reg_accu_en(19);                                  
                                                                                                         
                                                                                                         
            v_round := '0' & taps_x_fir_reg_accu(20)(14);                                                     
            data_out_prepare <= std_logic_vector(taps_x_fir_reg_accu(20)(26 downto 15) + v_round);                                                                         
            data_out_prepare_en <= taps_x_fir_reg_accu_en(20);--;                                                    

                                                                                                         
       end if;                                                                                           
                                                                                                         
    end process;                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
 data_out     <= data_out_prepare;                                                                       
 data_out_en  <= data_out_prepare_en;                                                                    
                                                                                                         
                                                                                                         
                                                                                                         
 taps(0) <= to_signed(-42,14);
 taps(1) <= to_signed(-15,14);
 taps(2) <= to_signed(58,14);
 taps(3) <= to_signed(252,14);
 taps(4) <= to_signed(629,14);
 taps(5) <= to_signed(1208,14);
 taps(6) <= to_signed(1952,14);
 taps(7) <= to_signed(2759,14);
 taps(8) <= to_signed(3490,14);
 taps(9) <= to_signed(4001,14);
 taps(10) <= to_signed(4185,14);
 taps(11) <= to_signed(4001,14);
 taps(12) <= to_signed(3490,14);
 taps(13) <= to_signed(2759,14);
 taps(14) <= to_signed(1952,14);
 taps(15) <= to_signed(1208,14);
 taps(16) <= to_signed(629,14);
 taps(17) <= to_signed(252,14);
 taps(18) <= to_signed(58,14);
 taps(19) <= to_signed(-15,14);
 taps(20) <= to_signed(-42,14);
                                                                                                         
                                                                                                         
                                                                                                         
 end rtl;                                                                                                
