library IEEE;                                                                                            
use IEEE.std_logic_1164.all;                                                                             
use IEEE.numeric_std.all;                                                                                
use     ieee.math_real.all;                                                                              
                                                                                                         
entity fir_with_tree is                                                                                            
 port (                                                                                                  
            clk             : in std_logic;                                                              
                                                                                                         
            data_in         : in std_logic_vector(11 downto 0);                                          
            data_in_en      : in std_logic;                                                              
                                                                                                         
			data_out		: out std_logic_vector(11 downto 0);                                          
			data_out_en		: out std_logic                                                               
                                                                                                         
 );                                                                                                      
end entity fir_with_tree;                                                                                          
                                                                                                         
architecture rtl of fir_with_tree is                                                                               
                                                                                                         
                                                                                                         
                                                                                                         
constant nb_taps                        : integer:=8;                                                   
type taps_type                          is array (0 to nb_taps-1) of signed(13 downto 0);                
signal taps                             : taps_type;                                                     
type fir_reg_type                       is array (0 to nb_taps-1) of signed(11 downto 0);                
signal fir_reg                          : fir_reg_type:=(others=>(others=>'0'));                        
type taps_x_fir_reg_type                is array (0 to nb_taps-1) of signed(25 downto 0);                
signal taps_x_fir_reg                   : taps_x_fir_reg_type;                                           
                                                                                                         
type adder_tree_subtype                 is array (0 to nb_taps) of signed(63 downto 0);                  
type adder_tree_type                    is array (0 to nb_taps-1) of adder_tree_subtype;                 
signal adder_tree                       : adder_tree_type:=(others=>(others=>(others=>'0')));          
signal adder_tree_en                    : std_logic_vector(nb_taps-1 downto 0);                          
                                                                                                         
                                                                                                         
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
                                                                                                         
            --multiply                                                                                   
            for I in 0 to nb_taps-1 loop                                                                 
                taps_x_fir_reg(I) <= fir_reg(I) * taps(I); -- 12 + 14 = 26 bits                          
            end loop;                                                                                    
            data_in_en_r2 <= data_in_en_r1;                                                              
                                                                                                         
            --Pipe                                                                                       
            for I in 0 to nb_taps-1 loop                                                                 
                adder_tree(0)(I)         <= resize(taps_x_fir_reg(I),64);                                
            end loop;                                                                                    
            data_in_en_r3 <= data_in_en_r2;                                                              
                                                                                                         
            adder_tree(1)(0) <= adder_tree(0)(0) + adder_tree(0)(1); --27 bits 
            adder_tree(1)(1) <= adder_tree(0)(2) + adder_tree(0)(3); --27 bits 
            adder_tree(1)(2) <= adder_tree(0)(4) + adder_tree(0)(5); --27 bits 
            adder_tree(1)(3) <= adder_tree(0)(6) + adder_tree(0)(7); --27 bits 
            adder_tree(2)(0) <= adder_tree(1)(0) + adder_tree(1)(1); --28 bits 
            adder_tree(2)(1) <= adder_tree(1)(2) + adder_tree(1)(3); --28 bits 
            adder_tree(2)(2) <= adder_tree(1)(4) + adder_tree(1)(5); --28 bits 
            adder_tree(3)(0) <= adder_tree(2)(0) + adder_tree(2)(1);
                                                                                                         
            v_round := '0' & adder_tree(3)(0)(13);                                                     
            data_out_prepare <= std_logic_vector(adder_tree(3)(0)(25 downto 14) + v_round);                                                                         
            data_out_prepare_en <= adder_tree_en(3);                                                    
                                                                                                         
                                                                                                         
                                                                                                         
            adder_tree_en(0) <= data_in_en_r2;                                                           
            adder_tree_en(nb_taps-1 downto 1) <= adder_tree_en(nb_taps-2 downto 0);                      
                                                                                                         
       end if;                                                                                           
    end process;                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
 data_out     <= data_out_prepare;                                                                       
 data_out_en  <= data_out_prepare_en;                                                                    
                                                                                                         
                                                                                                         
                                                                                                         
 taps(0) <= to_signed(268,14);
 taps(1) <= to_signed(978,14);
 taps(2) <= to_signed(2720,14);
 taps(3) <= to_signed(4225,14);
 taps(4) <= to_signed(4225,14);
 taps(5) <= to_signed(2720,14);
 taps(6) <= to_signed(978,14);
 taps(7) <= to_signed(268,14);
                                                                                                         
                                                                                                         
                                                                                                         
 end rtl;                                                                                                
