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
                                                                                                         
                                                                                                         
                                                                                                         
constant nb_taps                        : integer:=100;                                                   
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
signal fir_reg_d22                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d23                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d24                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d25                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d26                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d27                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d28                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d29                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d30                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d31                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d32                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d33                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d34                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d35                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d36                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d37                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d38                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d39                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d40                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d41                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d42                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d43                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d44                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d45                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d46                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d47                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d48                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d49                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d50                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d51                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d52                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d53                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d54                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d55                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d56                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d57                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d58                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d59                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d60                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d61                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d62                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d63                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d64                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d65                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d66                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d67                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d68                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d69                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d70                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d71                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d72                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d73                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d74                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d75                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d76                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d77                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d78                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d79                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d80                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d81                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d82                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d83                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d84                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d85                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d86                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d87                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d88                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d89                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d90                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d91                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d92                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d93                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d94                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d95                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d96                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d97                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d98                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d99                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d100                          : fir_reg_type:=(others=>(others=>'0'));                        
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
                                                                                                         
            fir_reg_d22 <= fir_reg_d21;                                                                 
            taps_x_fir_reg(21)           <= fir_reg_d21(21) *  taps(21);                                                 
            taps_x_fir_reg_accu(21)      <= taps_x_fir_reg(21) + taps_x_fir_reg_accu(20);                                    
            taps_x_fir_reg_accu_en(21)   <= taps_x_fir_reg_accu_en(20);                                  
                                                                                                         
            fir_reg_d23 <= fir_reg_d22;                                                                 
            taps_x_fir_reg(22)           <= fir_reg_d22(22) *  taps(22);                                                 
            taps_x_fir_reg_accu(22)      <= taps_x_fir_reg(22) + taps_x_fir_reg_accu(21);                                    
            taps_x_fir_reg_accu_en(22)   <= taps_x_fir_reg_accu_en(21);                                  
                                                                                                         
            fir_reg_d24 <= fir_reg_d23;                                                                 
            taps_x_fir_reg(23)           <= fir_reg_d23(23) *  taps(23);                                                 
            taps_x_fir_reg_accu(23)      <= taps_x_fir_reg(23) + taps_x_fir_reg_accu(22);                                    
            taps_x_fir_reg_accu_en(23)   <= taps_x_fir_reg_accu_en(22);                                  
                                                                                                         
            fir_reg_d25 <= fir_reg_d24;                                                                 
            taps_x_fir_reg(24)           <= fir_reg_d24(24) *  taps(24);                                                 
            taps_x_fir_reg_accu(24)      <= taps_x_fir_reg(24) + taps_x_fir_reg_accu(23);                                    
            taps_x_fir_reg_accu_en(24)   <= taps_x_fir_reg_accu_en(23);                                  
                                                                                                         
            fir_reg_d26 <= fir_reg_d25;                                                                 
            taps_x_fir_reg(25)           <= fir_reg_d25(25) *  taps(25);                                                 
            taps_x_fir_reg_accu(25)      <= taps_x_fir_reg(25) + taps_x_fir_reg_accu(24);                                    
            taps_x_fir_reg_accu_en(25)   <= taps_x_fir_reg_accu_en(24);                                  
                                                                                                         
            fir_reg_d27 <= fir_reg_d26;                                                                 
            taps_x_fir_reg(26)           <= fir_reg_d26(26) *  taps(26);                                                 
            taps_x_fir_reg_accu(26)      <= taps_x_fir_reg(26) + taps_x_fir_reg_accu(25);                                    
            taps_x_fir_reg_accu_en(26)   <= taps_x_fir_reg_accu_en(25);                                  
                                                                                                         
            fir_reg_d28 <= fir_reg_d27;                                                                 
            taps_x_fir_reg(27)           <= fir_reg_d27(27) *  taps(27);                                                 
            taps_x_fir_reg_accu(27)      <= taps_x_fir_reg(27) + taps_x_fir_reg_accu(26);                                    
            taps_x_fir_reg_accu_en(27)   <= taps_x_fir_reg_accu_en(26);                                  
                                                                                                         
            fir_reg_d29 <= fir_reg_d28;                                                                 
            taps_x_fir_reg(28)           <= fir_reg_d28(28) *  taps(28);                                                 
            taps_x_fir_reg_accu(28)      <= taps_x_fir_reg(28) + taps_x_fir_reg_accu(27);                                    
            taps_x_fir_reg_accu_en(28)   <= taps_x_fir_reg_accu_en(27);                                  
                                                                                                         
            fir_reg_d30 <= fir_reg_d29;                                                                 
            taps_x_fir_reg(29)           <= fir_reg_d29(29) *  taps(29);                                                 
            taps_x_fir_reg_accu(29)      <= taps_x_fir_reg(29) + taps_x_fir_reg_accu(28);                                    
            taps_x_fir_reg_accu_en(29)   <= taps_x_fir_reg_accu_en(28);                                  
                                                                                                         
            fir_reg_d31 <= fir_reg_d30;                                                                 
            taps_x_fir_reg(30)           <= fir_reg_d30(30) *  taps(30);                                                 
            taps_x_fir_reg_accu(30)      <= taps_x_fir_reg(30) + taps_x_fir_reg_accu(29);                                    
            taps_x_fir_reg_accu_en(30)   <= taps_x_fir_reg_accu_en(29);                                  
                                                                                                         
            fir_reg_d32 <= fir_reg_d31;                                                                 
            taps_x_fir_reg(31)           <= fir_reg_d31(31) *  taps(31);                                                 
            taps_x_fir_reg_accu(31)      <= taps_x_fir_reg(31) + taps_x_fir_reg_accu(30);                                    
            taps_x_fir_reg_accu_en(31)   <= taps_x_fir_reg_accu_en(30);                                  
                                                                                                         
            fir_reg_d33 <= fir_reg_d32;                                                                 
            taps_x_fir_reg(32)           <= fir_reg_d32(32) *  taps(32);                                                 
            taps_x_fir_reg_accu(32)      <= taps_x_fir_reg(32) + taps_x_fir_reg_accu(31);                                    
            taps_x_fir_reg_accu_en(32)   <= taps_x_fir_reg_accu_en(31);                                  
                                                                                                         
            fir_reg_d34 <= fir_reg_d33;                                                                 
            taps_x_fir_reg(33)           <= fir_reg_d33(33) *  taps(33);                                                 
            taps_x_fir_reg_accu(33)      <= taps_x_fir_reg(33) + taps_x_fir_reg_accu(32);                                    
            taps_x_fir_reg_accu_en(33)   <= taps_x_fir_reg_accu_en(32);                                  
                                                                                                         
            fir_reg_d35 <= fir_reg_d34;                                                                 
            taps_x_fir_reg(34)           <= fir_reg_d34(34) *  taps(34);                                                 
            taps_x_fir_reg_accu(34)      <= taps_x_fir_reg(34) + taps_x_fir_reg_accu(33);                                    
            taps_x_fir_reg_accu_en(34)   <= taps_x_fir_reg_accu_en(33);                                  
                                                                                                         
            fir_reg_d36 <= fir_reg_d35;                                                                 
            taps_x_fir_reg(35)           <= fir_reg_d35(35) *  taps(35);                                                 
            taps_x_fir_reg_accu(35)      <= taps_x_fir_reg(35) + taps_x_fir_reg_accu(34);                                    
            taps_x_fir_reg_accu_en(35)   <= taps_x_fir_reg_accu_en(34);                                  
                                                                                                         
            fir_reg_d37 <= fir_reg_d36;                                                                 
            taps_x_fir_reg(36)           <= fir_reg_d36(36) *  taps(36);                                                 
            taps_x_fir_reg_accu(36)      <= taps_x_fir_reg(36) + taps_x_fir_reg_accu(35);                                    
            taps_x_fir_reg_accu_en(36)   <= taps_x_fir_reg_accu_en(35);                                  
                                                                                                         
            fir_reg_d38 <= fir_reg_d37;                                                                 
            taps_x_fir_reg(37)           <= fir_reg_d37(37) *  taps(37);                                                 
            taps_x_fir_reg_accu(37)      <= taps_x_fir_reg(37) + taps_x_fir_reg_accu(36);                                    
            taps_x_fir_reg_accu_en(37)   <= taps_x_fir_reg_accu_en(36);                                  
                                                                                                         
            fir_reg_d39 <= fir_reg_d38;                                                                 
            taps_x_fir_reg(38)           <= fir_reg_d38(38) *  taps(38);                                                 
            taps_x_fir_reg_accu(38)      <= taps_x_fir_reg(38) + taps_x_fir_reg_accu(37);                                    
            taps_x_fir_reg_accu_en(38)   <= taps_x_fir_reg_accu_en(37);                                  
                                                                                                         
            fir_reg_d40 <= fir_reg_d39;                                                                 
            taps_x_fir_reg(39)           <= fir_reg_d39(39) *  taps(39);                                                 
            taps_x_fir_reg_accu(39)      <= taps_x_fir_reg(39) + taps_x_fir_reg_accu(38);                                    
            taps_x_fir_reg_accu_en(39)   <= taps_x_fir_reg_accu_en(38);                                  
                                                                                                         
            fir_reg_d41 <= fir_reg_d40;                                                                 
            taps_x_fir_reg(40)           <= fir_reg_d40(40) *  taps(40);                                                 
            taps_x_fir_reg_accu(40)      <= taps_x_fir_reg(40) + taps_x_fir_reg_accu(39);                                    
            taps_x_fir_reg_accu_en(40)   <= taps_x_fir_reg_accu_en(39);                                  
                                                                                                         
            fir_reg_d42 <= fir_reg_d41;                                                                 
            taps_x_fir_reg(41)           <= fir_reg_d41(41) *  taps(41);                                                 
            taps_x_fir_reg_accu(41)      <= taps_x_fir_reg(41) + taps_x_fir_reg_accu(40);                                    
            taps_x_fir_reg_accu_en(41)   <= taps_x_fir_reg_accu_en(40);                                  
                                                                                                         
            fir_reg_d43 <= fir_reg_d42;                                                                 
            taps_x_fir_reg(42)           <= fir_reg_d42(42) *  taps(42);                                                 
            taps_x_fir_reg_accu(42)      <= taps_x_fir_reg(42) + taps_x_fir_reg_accu(41);                                    
            taps_x_fir_reg_accu_en(42)   <= taps_x_fir_reg_accu_en(41);                                  
                                                                                                         
            fir_reg_d44 <= fir_reg_d43;                                                                 
            taps_x_fir_reg(43)           <= fir_reg_d43(43) *  taps(43);                                                 
            taps_x_fir_reg_accu(43)      <= taps_x_fir_reg(43) + taps_x_fir_reg_accu(42);                                    
            taps_x_fir_reg_accu_en(43)   <= taps_x_fir_reg_accu_en(42);                                  
                                                                                                         
            fir_reg_d45 <= fir_reg_d44;                                                                 
            taps_x_fir_reg(44)           <= fir_reg_d44(44) *  taps(44);                                                 
            taps_x_fir_reg_accu(44)      <= taps_x_fir_reg(44) + taps_x_fir_reg_accu(43);                                    
            taps_x_fir_reg_accu_en(44)   <= taps_x_fir_reg_accu_en(43);                                  
                                                                                                         
            fir_reg_d46 <= fir_reg_d45;                                                                 
            taps_x_fir_reg(45)           <= fir_reg_d45(45) *  taps(45);                                                 
            taps_x_fir_reg_accu(45)      <= taps_x_fir_reg(45) + taps_x_fir_reg_accu(44);                                    
            taps_x_fir_reg_accu_en(45)   <= taps_x_fir_reg_accu_en(44);                                  
                                                                                                         
            fir_reg_d47 <= fir_reg_d46;                                                                 
            taps_x_fir_reg(46)           <= fir_reg_d46(46) *  taps(46);                                                 
            taps_x_fir_reg_accu(46)      <= taps_x_fir_reg(46) + taps_x_fir_reg_accu(45);                                    
            taps_x_fir_reg_accu_en(46)   <= taps_x_fir_reg_accu_en(45);                                  
                                                                                                         
            fir_reg_d48 <= fir_reg_d47;                                                                 
            taps_x_fir_reg(47)           <= fir_reg_d47(47) *  taps(47);                                                 
            taps_x_fir_reg_accu(47)      <= taps_x_fir_reg(47) + taps_x_fir_reg_accu(46);                                    
            taps_x_fir_reg_accu_en(47)   <= taps_x_fir_reg_accu_en(46);                                  
                                                                                                         
            fir_reg_d49 <= fir_reg_d48;                                                                 
            taps_x_fir_reg(48)           <= fir_reg_d48(48) *  taps(48);                                                 
            taps_x_fir_reg_accu(48)      <= taps_x_fir_reg(48) + taps_x_fir_reg_accu(47);                                    
            taps_x_fir_reg_accu_en(48)   <= taps_x_fir_reg_accu_en(47);                                  
                                                                                                         
            fir_reg_d50 <= fir_reg_d49;                                                                 
            taps_x_fir_reg(49)           <= fir_reg_d49(49) *  taps(49);                                                 
            taps_x_fir_reg_accu(49)      <= taps_x_fir_reg(49) + taps_x_fir_reg_accu(48);                                    
            taps_x_fir_reg_accu_en(49)   <= taps_x_fir_reg_accu_en(48);                                  
                                                                                                         
            fir_reg_d51 <= fir_reg_d50;                                                                 
            taps_x_fir_reg(50)           <= fir_reg_d50(50) *  taps(50);                                                 
            taps_x_fir_reg_accu(50)      <= taps_x_fir_reg(50) + taps_x_fir_reg_accu(49);                                    
            taps_x_fir_reg_accu_en(50)   <= taps_x_fir_reg_accu_en(49);                                  
                                                                                                         
            fir_reg_d52 <= fir_reg_d51;                                                                 
            taps_x_fir_reg(51)           <= fir_reg_d51(51) *  taps(51);                                                 
            taps_x_fir_reg_accu(51)      <= taps_x_fir_reg(51) + taps_x_fir_reg_accu(50);                                    
            taps_x_fir_reg_accu_en(51)   <= taps_x_fir_reg_accu_en(50);                                  
                                                                                                         
            fir_reg_d53 <= fir_reg_d52;                                                                 
            taps_x_fir_reg(52)           <= fir_reg_d52(52) *  taps(52);                                                 
            taps_x_fir_reg_accu(52)      <= taps_x_fir_reg(52) + taps_x_fir_reg_accu(51);                                    
            taps_x_fir_reg_accu_en(52)   <= taps_x_fir_reg_accu_en(51);                                  
                                                                                                         
            fir_reg_d54 <= fir_reg_d53;                                                                 
            taps_x_fir_reg(53)           <= fir_reg_d53(53) *  taps(53);                                                 
            taps_x_fir_reg_accu(53)      <= taps_x_fir_reg(53) + taps_x_fir_reg_accu(52);                                    
            taps_x_fir_reg_accu_en(53)   <= taps_x_fir_reg_accu_en(52);                                  
                                                                                                         
            fir_reg_d55 <= fir_reg_d54;                                                                 
            taps_x_fir_reg(54)           <= fir_reg_d54(54) *  taps(54);                                                 
            taps_x_fir_reg_accu(54)      <= taps_x_fir_reg(54) + taps_x_fir_reg_accu(53);                                    
            taps_x_fir_reg_accu_en(54)   <= taps_x_fir_reg_accu_en(53);                                  
                                                                                                         
            fir_reg_d56 <= fir_reg_d55;                                                                 
            taps_x_fir_reg(55)           <= fir_reg_d55(55) *  taps(55);                                                 
            taps_x_fir_reg_accu(55)      <= taps_x_fir_reg(55) + taps_x_fir_reg_accu(54);                                    
            taps_x_fir_reg_accu_en(55)   <= taps_x_fir_reg_accu_en(54);                                  
                                                                                                         
            fir_reg_d57 <= fir_reg_d56;                                                                 
            taps_x_fir_reg(56)           <= fir_reg_d56(56) *  taps(56);                                                 
            taps_x_fir_reg_accu(56)      <= taps_x_fir_reg(56) + taps_x_fir_reg_accu(55);                                    
            taps_x_fir_reg_accu_en(56)   <= taps_x_fir_reg_accu_en(55);                                  
                                                                                                         
            fir_reg_d58 <= fir_reg_d57;                                                                 
            taps_x_fir_reg(57)           <= fir_reg_d57(57) *  taps(57);                                                 
            taps_x_fir_reg_accu(57)      <= taps_x_fir_reg(57) + taps_x_fir_reg_accu(56);                                    
            taps_x_fir_reg_accu_en(57)   <= taps_x_fir_reg_accu_en(56);                                  
                                                                                                         
            fir_reg_d59 <= fir_reg_d58;                                                                 
            taps_x_fir_reg(58)           <= fir_reg_d58(58) *  taps(58);                                                 
            taps_x_fir_reg_accu(58)      <= taps_x_fir_reg(58) + taps_x_fir_reg_accu(57);                                    
            taps_x_fir_reg_accu_en(58)   <= taps_x_fir_reg_accu_en(57);                                  
                                                                                                         
            fir_reg_d60 <= fir_reg_d59;                                                                 
            taps_x_fir_reg(59)           <= fir_reg_d59(59) *  taps(59);                                                 
            taps_x_fir_reg_accu(59)      <= taps_x_fir_reg(59) + taps_x_fir_reg_accu(58);                                    
            taps_x_fir_reg_accu_en(59)   <= taps_x_fir_reg_accu_en(58);                                  
                                                                                                         
            fir_reg_d61 <= fir_reg_d60;                                                                 
            taps_x_fir_reg(60)           <= fir_reg_d60(60) *  taps(60);                                                 
            taps_x_fir_reg_accu(60)      <= taps_x_fir_reg(60) + taps_x_fir_reg_accu(59);                                    
            taps_x_fir_reg_accu_en(60)   <= taps_x_fir_reg_accu_en(59);                                  
                                                                                                         
            fir_reg_d62 <= fir_reg_d61;                                                                 
            taps_x_fir_reg(61)           <= fir_reg_d61(61) *  taps(61);                                                 
            taps_x_fir_reg_accu(61)      <= taps_x_fir_reg(61) + taps_x_fir_reg_accu(60);                                    
            taps_x_fir_reg_accu_en(61)   <= taps_x_fir_reg_accu_en(60);                                  
                                                                                                         
            fir_reg_d63 <= fir_reg_d62;                                                                 
            taps_x_fir_reg(62)           <= fir_reg_d62(62) *  taps(62);                                                 
            taps_x_fir_reg_accu(62)      <= taps_x_fir_reg(62) + taps_x_fir_reg_accu(61);                                    
            taps_x_fir_reg_accu_en(62)   <= taps_x_fir_reg_accu_en(61);                                  
                                                                                                         
            fir_reg_d64 <= fir_reg_d63;                                                                 
            taps_x_fir_reg(63)           <= fir_reg_d63(63) *  taps(63);                                                 
            taps_x_fir_reg_accu(63)      <= taps_x_fir_reg(63) + taps_x_fir_reg_accu(62);                                    
            taps_x_fir_reg_accu_en(63)   <= taps_x_fir_reg_accu_en(62);                                  
                                                                                                         
            fir_reg_d65 <= fir_reg_d64;                                                                 
            taps_x_fir_reg(64)           <= fir_reg_d64(64) *  taps(64);                                                 
            taps_x_fir_reg_accu(64)      <= taps_x_fir_reg(64) + taps_x_fir_reg_accu(63);                                    
            taps_x_fir_reg_accu_en(64)   <= taps_x_fir_reg_accu_en(63);                                  
                                                                                                         
            fir_reg_d66 <= fir_reg_d65;                                                                 
            taps_x_fir_reg(65)           <= fir_reg_d65(65) *  taps(65);                                                 
            taps_x_fir_reg_accu(65)      <= taps_x_fir_reg(65) + taps_x_fir_reg_accu(64);                                    
            taps_x_fir_reg_accu_en(65)   <= taps_x_fir_reg_accu_en(64);                                  
                                                                                                         
            fir_reg_d67 <= fir_reg_d66;                                                                 
            taps_x_fir_reg(66)           <= fir_reg_d66(66) *  taps(66);                                                 
            taps_x_fir_reg_accu(66)      <= taps_x_fir_reg(66) + taps_x_fir_reg_accu(65);                                    
            taps_x_fir_reg_accu_en(66)   <= taps_x_fir_reg_accu_en(65);                                  
                                                                                                         
            fir_reg_d68 <= fir_reg_d67;                                                                 
            taps_x_fir_reg(67)           <= fir_reg_d67(67) *  taps(67);                                                 
            taps_x_fir_reg_accu(67)      <= taps_x_fir_reg(67) + taps_x_fir_reg_accu(66);                                    
            taps_x_fir_reg_accu_en(67)   <= taps_x_fir_reg_accu_en(66);                                  
                                                                                                         
            fir_reg_d69 <= fir_reg_d68;                                                                 
            taps_x_fir_reg(68)           <= fir_reg_d68(68) *  taps(68);                                                 
            taps_x_fir_reg_accu(68)      <= taps_x_fir_reg(68) + taps_x_fir_reg_accu(67);                                    
            taps_x_fir_reg_accu_en(68)   <= taps_x_fir_reg_accu_en(67);                                  
                                                                                                         
            fir_reg_d70 <= fir_reg_d69;                                                                 
            taps_x_fir_reg(69)           <= fir_reg_d69(69) *  taps(69);                                                 
            taps_x_fir_reg_accu(69)      <= taps_x_fir_reg(69) + taps_x_fir_reg_accu(68);                                    
            taps_x_fir_reg_accu_en(69)   <= taps_x_fir_reg_accu_en(68);                                  
                                                                                                         
            fir_reg_d71 <= fir_reg_d70;                                                                 
            taps_x_fir_reg(70)           <= fir_reg_d70(70) *  taps(70);                                                 
            taps_x_fir_reg_accu(70)      <= taps_x_fir_reg(70) + taps_x_fir_reg_accu(69);                                    
            taps_x_fir_reg_accu_en(70)   <= taps_x_fir_reg_accu_en(69);                                  
                                                                                                         
            fir_reg_d72 <= fir_reg_d71;                                                                 
            taps_x_fir_reg(71)           <= fir_reg_d71(71) *  taps(71);                                                 
            taps_x_fir_reg_accu(71)      <= taps_x_fir_reg(71) + taps_x_fir_reg_accu(70);                                    
            taps_x_fir_reg_accu_en(71)   <= taps_x_fir_reg_accu_en(70);                                  
                                                                                                         
            fir_reg_d73 <= fir_reg_d72;                                                                 
            taps_x_fir_reg(72)           <= fir_reg_d72(72) *  taps(72);                                                 
            taps_x_fir_reg_accu(72)      <= taps_x_fir_reg(72) + taps_x_fir_reg_accu(71);                                    
            taps_x_fir_reg_accu_en(72)   <= taps_x_fir_reg_accu_en(71);                                  
                                                                                                         
            fir_reg_d74 <= fir_reg_d73;                                                                 
            taps_x_fir_reg(73)           <= fir_reg_d73(73) *  taps(73);                                                 
            taps_x_fir_reg_accu(73)      <= taps_x_fir_reg(73) + taps_x_fir_reg_accu(72);                                    
            taps_x_fir_reg_accu_en(73)   <= taps_x_fir_reg_accu_en(72);                                  
                                                                                                         
            fir_reg_d75 <= fir_reg_d74;                                                                 
            taps_x_fir_reg(74)           <= fir_reg_d74(74) *  taps(74);                                                 
            taps_x_fir_reg_accu(74)      <= taps_x_fir_reg(74) + taps_x_fir_reg_accu(73);                                    
            taps_x_fir_reg_accu_en(74)   <= taps_x_fir_reg_accu_en(73);                                  
                                                                                                         
            fir_reg_d76 <= fir_reg_d75;                                                                 
            taps_x_fir_reg(75)           <= fir_reg_d75(75) *  taps(75);                                                 
            taps_x_fir_reg_accu(75)      <= taps_x_fir_reg(75) + taps_x_fir_reg_accu(74);                                    
            taps_x_fir_reg_accu_en(75)   <= taps_x_fir_reg_accu_en(74);                                  
                                                                                                         
            fir_reg_d77 <= fir_reg_d76;                                                                 
            taps_x_fir_reg(76)           <= fir_reg_d76(76) *  taps(76);                                                 
            taps_x_fir_reg_accu(76)      <= taps_x_fir_reg(76) + taps_x_fir_reg_accu(75);                                    
            taps_x_fir_reg_accu_en(76)   <= taps_x_fir_reg_accu_en(75);                                  
                                                                                                         
            fir_reg_d78 <= fir_reg_d77;                                                                 
            taps_x_fir_reg(77)           <= fir_reg_d77(77) *  taps(77);                                                 
            taps_x_fir_reg_accu(77)      <= taps_x_fir_reg(77) + taps_x_fir_reg_accu(76);                                    
            taps_x_fir_reg_accu_en(77)   <= taps_x_fir_reg_accu_en(76);                                  
                                                                                                         
            fir_reg_d79 <= fir_reg_d78;                                                                 
            taps_x_fir_reg(78)           <= fir_reg_d78(78) *  taps(78);                                                 
            taps_x_fir_reg_accu(78)      <= taps_x_fir_reg(78) + taps_x_fir_reg_accu(77);                                    
            taps_x_fir_reg_accu_en(78)   <= taps_x_fir_reg_accu_en(77);                                  
                                                                                                         
            fir_reg_d80 <= fir_reg_d79;                                                                 
            taps_x_fir_reg(79)           <= fir_reg_d79(79) *  taps(79);                                                 
            taps_x_fir_reg_accu(79)      <= taps_x_fir_reg(79) + taps_x_fir_reg_accu(78);                                    
            taps_x_fir_reg_accu_en(79)   <= taps_x_fir_reg_accu_en(78);                                  
                                                                                                         
            fir_reg_d81 <= fir_reg_d80;                                                                 
            taps_x_fir_reg(80)           <= fir_reg_d80(80) *  taps(80);                                                 
            taps_x_fir_reg_accu(80)      <= taps_x_fir_reg(80) + taps_x_fir_reg_accu(79);                                    
            taps_x_fir_reg_accu_en(80)   <= taps_x_fir_reg_accu_en(79);                                  
                                                                                                         
            fir_reg_d82 <= fir_reg_d81;                                                                 
            taps_x_fir_reg(81)           <= fir_reg_d81(81) *  taps(81);                                                 
            taps_x_fir_reg_accu(81)      <= taps_x_fir_reg(81) + taps_x_fir_reg_accu(80);                                    
            taps_x_fir_reg_accu_en(81)   <= taps_x_fir_reg_accu_en(80);                                  
                                                                                                         
            fir_reg_d83 <= fir_reg_d82;                                                                 
            taps_x_fir_reg(82)           <= fir_reg_d82(82) *  taps(82);                                                 
            taps_x_fir_reg_accu(82)      <= taps_x_fir_reg(82) + taps_x_fir_reg_accu(81);                                    
            taps_x_fir_reg_accu_en(82)   <= taps_x_fir_reg_accu_en(81);                                  
                                                                                                         
            fir_reg_d84 <= fir_reg_d83;                                                                 
            taps_x_fir_reg(83)           <= fir_reg_d83(83) *  taps(83);                                                 
            taps_x_fir_reg_accu(83)      <= taps_x_fir_reg(83) + taps_x_fir_reg_accu(82);                                    
            taps_x_fir_reg_accu_en(83)   <= taps_x_fir_reg_accu_en(82);                                  
                                                                                                         
            fir_reg_d85 <= fir_reg_d84;                                                                 
            taps_x_fir_reg(84)           <= fir_reg_d84(84) *  taps(84);                                                 
            taps_x_fir_reg_accu(84)      <= taps_x_fir_reg(84) + taps_x_fir_reg_accu(83);                                    
            taps_x_fir_reg_accu_en(84)   <= taps_x_fir_reg_accu_en(83);                                  
                                                                                                         
            fir_reg_d86 <= fir_reg_d85;                                                                 
            taps_x_fir_reg(85)           <= fir_reg_d85(85) *  taps(85);                                                 
            taps_x_fir_reg_accu(85)      <= taps_x_fir_reg(85) + taps_x_fir_reg_accu(84);                                    
            taps_x_fir_reg_accu_en(85)   <= taps_x_fir_reg_accu_en(84);                                  
                                                                                                         
            fir_reg_d87 <= fir_reg_d86;                                                                 
            taps_x_fir_reg(86)           <= fir_reg_d86(86) *  taps(86);                                                 
            taps_x_fir_reg_accu(86)      <= taps_x_fir_reg(86) + taps_x_fir_reg_accu(85);                                    
            taps_x_fir_reg_accu_en(86)   <= taps_x_fir_reg_accu_en(85);                                  
                                                                                                         
            fir_reg_d88 <= fir_reg_d87;                                                                 
            taps_x_fir_reg(87)           <= fir_reg_d87(87) *  taps(87);                                                 
            taps_x_fir_reg_accu(87)      <= taps_x_fir_reg(87) + taps_x_fir_reg_accu(86);                                    
            taps_x_fir_reg_accu_en(87)   <= taps_x_fir_reg_accu_en(86);                                  
                                                                                                         
            fir_reg_d89 <= fir_reg_d88;                                                                 
            taps_x_fir_reg(88)           <= fir_reg_d88(88) *  taps(88);                                                 
            taps_x_fir_reg_accu(88)      <= taps_x_fir_reg(88) + taps_x_fir_reg_accu(87);                                    
            taps_x_fir_reg_accu_en(88)   <= taps_x_fir_reg_accu_en(87);                                  
                                                                                                         
            fir_reg_d90 <= fir_reg_d89;                                                                 
            taps_x_fir_reg(89)           <= fir_reg_d89(89) *  taps(89);                                                 
            taps_x_fir_reg_accu(89)      <= taps_x_fir_reg(89) + taps_x_fir_reg_accu(88);                                    
            taps_x_fir_reg_accu_en(89)   <= taps_x_fir_reg_accu_en(88);                                  
                                                                                                         
            fir_reg_d91 <= fir_reg_d90;                                                                 
            taps_x_fir_reg(90)           <= fir_reg_d90(90) *  taps(90);                                                 
            taps_x_fir_reg_accu(90)      <= taps_x_fir_reg(90) + taps_x_fir_reg_accu(89);                                    
            taps_x_fir_reg_accu_en(90)   <= taps_x_fir_reg_accu_en(89);                                  
                                                                                                         
            fir_reg_d92 <= fir_reg_d91;                                                                 
            taps_x_fir_reg(91)           <= fir_reg_d91(91) *  taps(91);                                                 
            taps_x_fir_reg_accu(91)      <= taps_x_fir_reg(91) + taps_x_fir_reg_accu(90);                                    
            taps_x_fir_reg_accu_en(91)   <= taps_x_fir_reg_accu_en(90);                                  
                                                                                                         
            fir_reg_d93 <= fir_reg_d92;                                                                 
            taps_x_fir_reg(92)           <= fir_reg_d92(92) *  taps(92);                                                 
            taps_x_fir_reg_accu(92)      <= taps_x_fir_reg(92) + taps_x_fir_reg_accu(91);                                    
            taps_x_fir_reg_accu_en(92)   <= taps_x_fir_reg_accu_en(91);                                  
                                                                                                         
            fir_reg_d94 <= fir_reg_d93;                                                                 
            taps_x_fir_reg(93)           <= fir_reg_d93(93) *  taps(93);                                                 
            taps_x_fir_reg_accu(93)      <= taps_x_fir_reg(93) + taps_x_fir_reg_accu(92);                                    
            taps_x_fir_reg_accu_en(93)   <= taps_x_fir_reg_accu_en(92);                                  
                                                                                                         
            fir_reg_d95 <= fir_reg_d94;                                                                 
            taps_x_fir_reg(94)           <= fir_reg_d94(94) *  taps(94);                                                 
            taps_x_fir_reg_accu(94)      <= taps_x_fir_reg(94) + taps_x_fir_reg_accu(93);                                    
            taps_x_fir_reg_accu_en(94)   <= taps_x_fir_reg_accu_en(93);                                  
                                                                                                         
            fir_reg_d96 <= fir_reg_d95;                                                                 
            taps_x_fir_reg(95)           <= fir_reg_d95(95) *  taps(95);                                                 
            taps_x_fir_reg_accu(95)      <= taps_x_fir_reg(95) + taps_x_fir_reg_accu(94);                                    
            taps_x_fir_reg_accu_en(95)   <= taps_x_fir_reg_accu_en(94);                                  
                                                                                                         
            fir_reg_d97 <= fir_reg_d96;                                                                 
            taps_x_fir_reg(96)           <= fir_reg_d96(96) *  taps(96);                                                 
            taps_x_fir_reg_accu(96)      <= taps_x_fir_reg(96) + taps_x_fir_reg_accu(95);                                    
            taps_x_fir_reg_accu_en(96)   <= taps_x_fir_reg_accu_en(95);                                  
                                                                                                         
            fir_reg_d98 <= fir_reg_d97;                                                                 
            taps_x_fir_reg(97)           <= fir_reg_d97(97) *  taps(97);                                                 
            taps_x_fir_reg_accu(97)      <= taps_x_fir_reg(97) + taps_x_fir_reg_accu(96);                                    
            taps_x_fir_reg_accu_en(97)   <= taps_x_fir_reg_accu_en(96);                                  
                                                                                                         
            fir_reg_d99 <= fir_reg_d98;                                                                 
            taps_x_fir_reg(98)           <= fir_reg_d98(98) *  taps(98);                                                 
            taps_x_fir_reg_accu(98)      <= taps_x_fir_reg(98) + taps_x_fir_reg_accu(97);                                    
            taps_x_fir_reg_accu_en(98)   <= taps_x_fir_reg_accu_en(97);                                  
                                                                                                         
            fir_reg_d100 <= fir_reg_d99;                                                                 
            taps_x_fir_reg(99)           <= fir_reg_d99(99) *  taps(99);                                                 
            taps_x_fir_reg_accu(99)      <= taps_x_fir_reg(99) + taps_x_fir_reg_accu(98);                                    
            taps_x_fir_reg_accu_en(99)   <= taps_x_fir_reg_accu_en(98);                                  
                                                                                                         
                                                                                                         
            v_round := '0' & taps_x_fir_reg_accu(99)(15);                                                     
            data_out_prepare <= std_logic_vector(taps_x_fir_reg_accu(99)(27 downto 16) + v_round);                                                                         
            data_out_prepare_en <= taps_x_fir_reg_accu_en(99);--;                                                    

                                                                                                         
       end if;                                                                                           
                                                                                                         
    end process;                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
 data_out     <= data_out_prepare;                                                                       
 data_out_en  <= data_out_prepare_en;                                                                    
                                                                                                         
                                                                                                         
                                                                                                         
 taps(0) <= to_signed(-18,14);
 taps(1) <= to_signed(-23,14);
 taps(2) <= to_signed(-25,14);
 taps(3) <= to_signed(-25,14);
 taps(4) <= to_signed(-21,14);
 taps(5) <= to_signed(-14,14);
 taps(6) <= to_signed(-2,14);
 taps(7) <= to_signed(14,14);
 taps(8) <= to_signed(33,14);
 taps(9) <= to_signed(52,14);
 taps(10) <= to_signed(68,14);
 taps(11) <= to_signed(78,14);
 taps(12) <= to_signed(78,14);
 taps(13) <= to_signed(63,14);
 taps(14) <= to_signed(34,14);
 taps(15) <= to_signed(-10,14);
 taps(16) <= to_signed(-66,14);
 taps(17) <= to_signed(-125,14);
 taps(18) <= to_signed(-181,14);
 taps(19) <= to_signed(-221,14);
 taps(20) <= to_signed(-236,14);
 taps(21) <= to_signed(-216,14);
 taps(22) <= to_signed(-157,14);
 taps(23) <= to_signed(-58,14);
 taps(24) <= to_signed(73,14);
 taps(25) <= to_signed(223,14);
 taps(26) <= to_signed(372,14);
 taps(27) <= to_signed(496,14);
 taps(28) <= to_signed(570,14);
 taps(29) <= to_signed(572,14);
 taps(30) <= to_signed(487,14);
 taps(31) <= to_signed(308,14);
 taps(32) <= to_signed(44,14);
 taps(33) <= to_signed(-284,14);
 taps(34) <= to_signed(-640,14);
 taps(35) <= to_signed(-978,14);
 taps(36) <= to_signed(-1242,14);
 taps(37) <= to_signed(-1378,14);
 taps(38) <= to_signed(-1336,14);
 taps(39) <= to_signed(-1077,14);
 taps(40) <= to_signed(-582,14);
 taps(41) <= to_signed(146,14);
 taps(42) <= to_signed(1080,14);
 taps(43) <= to_signed(2170,14);
 taps(44) <= to_signed(3345,14);
 taps(45) <= to_signed(4519,14);
 taps(46) <= to_signed(5602,14);
 taps(47) <= to_signed(6506,14);
 taps(48) <= to_signed(7156,14);
 taps(49) <= to_signed(7495,14);
 taps(50) <= to_signed(7495,14);
 taps(51) <= to_signed(7156,14);
 taps(52) <= to_signed(6506,14);
 taps(53) <= to_signed(5602,14);
 taps(54) <= to_signed(4519,14);
 taps(55) <= to_signed(3345,14);
 taps(56) <= to_signed(2170,14);
 taps(57) <= to_signed(1080,14);
 taps(58) <= to_signed(146,14);
 taps(59) <= to_signed(-582,14);
 taps(60) <= to_signed(-1077,14);
 taps(61) <= to_signed(-1336,14);
 taps(62) <= to_signed(-1378,14);
 taps(63) <= to_signed(-1242,14);
 taps(64) <= to_signed(-978,14);
 taps(65) <= to_signed(-640,14);
 taps(66) <= to_signed(-284,14);
 taps(67) <= to_signed(44,14);
 taps(68) <= to_signed(308,14);
 taps(69) <= to_signed(487,14);
 taps(70) <= to_signed(572,14);
 taps(71) <= to_signed(570,14);
 taps(72) <= to_signed(496,14);
 taps(73) <= to_signed(372,14);
 taps(74) <= to_signed(223,14);
 taps(75) <= to_signed(73,14);
 taps(76) <= to_signed(-58,14);
 taps(77) <= to_signed(-157,14);
 taps(78) <= to_signed(-216,14);
 taps(79) <= to_signed(-236,14);
 taps(80) <= to_signed(-221,14);
 taps(81) <= to_signed(-181,14);
 taps(82) <= to_signed(-125,14);
 taps(83) <= to_signed(-66,14);
 taps(84) <= to_signed(-10,14);
 taps(85) <= to_signed(34,14);
 taps(86) <= to_signed(63,14);
 taps(87) <= to_signed(78,14);
 taps(88) <= to_signed(78,14);
 taps(89) <= to_signed(68,14);
 taps(90) <= to_signed(52,14);
 taps(91) <= to_signed(33,14);
 taps(92) <= to_signed(14,14);
 taps(93) <= to_signed(-2,14);
 taps(94) <= to_signed(-14,14);
 taps(95) <= to_signed(-21,14);
 taps(96) <= to_signed(-25,14);
 taps(97) <= to_signed(-25,14);
 taps(98) <= to_signed(-23,14);
 taps(99) <= to_signed(-18,14);
                                                                                                         
                                                                                                         
                                                                                                         
 end rtl;                                                                                                
