library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;    
     
entity fir_filter_numeric is
    Port
        (
        MainClk:                                    in  STD_LOGIC;  
        Rst:                      in  std_logic;
        sample_input:             in std_logic_vector ( (12 - 1) downto 0);
        sample_output:            out signed(12+12-1 downto 0);
        FIRin:                    in std_logic;
        sample_out:               out std_logic
        );
  end fir_filter_numeric;


--! @copydoc    productDescription
  architecture Behavioral of fir_filter_numeric is
  
    constant bits_data:           natural := 12;                         
    constant taps:                natural := 69; 

    type h_type is array (integer range 0 to (taps - 1))  of signed ( ( bits_data-1 ) downto 0);
    type data_array is array (integer range 0 to (taps - 1))  of signed ( ( bits_data-1 ) downto 0);
    type mult_array is array (integer range 0 to (taps - 1))  of signed ( ( 2*bits_data-1 ) downto 0);     
    signal h                    : h_type     := (others => (others => '0')); 
    signal shift_data           : data_array     := (others => (others => '0')); 
    signal mult_data            : mult_array     := (others => (others => '0')); 
    
  
  begin  
        
    

     main_process : process(MainClk)
     variable add_data: signed (24 downto 0);
        begin       
        -- synchronous_reset
        if rising_edge(MainClk)  then
          if Rst = '1' then                   -- do reset
          sample_out <=                                     '0';      
      else
               shift_data    <=  signed(sample_input)    & shift_data( 0 to ( taps - 2));
              if FirIn = '1' then
                  -- count = 0, data_in 
                  shift_data(0)    <=  signed(sample_input);
              else 
                  -- (M-1)-zeros, count = 1:3
                  shift_data(0)    <=  (others => '0');
              end if; 

               add_data := (others => '0'); 
               for i in 0 to taps-1 loop
                    add_data  := add_data    + mult_data(i); 
               end loop;            
               sample_output   <= add_data (bits_data+bits_data-1 downto 0);
                end if; 
                
                for j in 0 to taps-1 loop
                    h(j) <= to_signed(j,bits_data);
                end loop;      
                
            end if; --

          end process main_process;
   

product_calc : 
 for i in 0 to taps-1 generate
    mult_data(i)   <= (shift_data(i) * h(i)); 
  end generate;  
  
    end Behavioral; 