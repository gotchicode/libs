library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_master_tx is
    generic (
        clk_MCLK_factor         : integer:=5;              -- 10 MHz
        clk_LRCLK_factor        : integer:=10*(32+32);      -- 20.83 KHz 
        clk_SCLK_factor         : integer:=10;              -- 10 MHz
        nb_bits                 : integer:=32              --
        -- clk_MCLK_factor      : frequency = clk/clk_MCLK_factor/2
        -- clk_LRCLK_factor     : frequency = clk/clk_LRCLK_factor/2
        -- clk_SCLK_factor      : frequency = clk/clk_SCLK_factor/2
        
        
    );
	port
	(
		clk		    : in std_logic;
		rst		    : in std_logic;
        
        data_in_left        : in std_logic_vector(nb_bits-1 downto 0);
        data_in_right       : in std_logic_vector(nb_bits-1 downto 0);
        data_in_en          : in std_logic;
        
        MCLK_out            : out std_logic;
        LRCLK_out           : out std_logic;
        SCLK_out            : out std_logic;
        SD_out              : out std_logic;
        
        req_data            : out std_logic

	);
end i2s_master_tx;

architecture rtl of i2s_master_tx is

signal data_in_left_saved       : std_logic_vector(nb_bits-1 downto 0);
signal data_in_right_saved      : std_logic_vector(nb_bits-1 downto 0);

signal data_in_left_buffered    : std_logic_vector(nb_bits-1 downto 0);
signal data_in_right_buffered   : std_logic_vector(nb_bits-1 downto 0);

signal MCLK_counter             : unsigned(15 downto 0);
signal LRCLK_counter            : unsigned(15 downto 0);
signal SCLK_counter             : unsigned(15 downto 0);

signal MCLK_inside              : std_logic;
signal LRCLK_inside             : std_logic;
signal SCLK_inside              : std_logic;
signal SD_inside                : std_logic;

signal MCLK_inside_d1           : std_logic;
signal LRCLK_inside_d1          : std_logic;
signal SCLK_inside_d1           : std_logic;
signal sample_counter           : unsigned(15 downto 0);

signal MCLK_inside_d2           : std_logic;
signal LRCLK_inside_d2          : std_logic;
signal SCLK_inside_d2           : std_logic;

begin

--template_pr: process(clk, rst_n)
--begin
--    if rst_n='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

save_data_pr: process(clk, rst)
begin
    if rst='1' then
    
        data_in_left_saved    <= (others=>'0');
        data_in_right_saved   <= (others=>'0');       
        
    elsif rising_edge(clk) then
    
        if data_in_en='1' then
            data_in_left_saved    <= data_in_left;
            data_in_right_saved   <= data_in_right;
        end if;
        
    end if;
end process;


gen_clk_pr: process(clk, rst)
begin
    if rst='1' then
    
        MCLK_counter            <= (others=>'0');
        LRCLK_counter           <= (others=>'0');  
        SCLK_counter            <= (others=>'0'); 
        
        MCLK_inside             <= '0';
        LRCLK_inside            <= '0';
        SCLK_inside             <= '0';
                
        MCLK_inside_d1          <= '0';
        LRCLK_inside_d1         <= '0'; 
        SCLK_inside_d1          <= '0';
        sample_counter          <= (others=>'0'); 
        
        MCLK_inside_d2          <= '0';
        LRCLK_inside_d2         <= '0';        
        SCLK_inside_d2          <= '0';

        data_in_left_buffered   <= (others=>'0');
        data_in_right_buffered  <= (others=>'0'); 
        
        SD_inside               <= '0';
        
        MCLK_out                <= '0';
        LRCLK_out               <= '0';        
        SCLK_out                <= '0';       
        SD_out                  <= '0';       
      
        req_data                <= '0';
    
    elsif rising_edge(clk) then
    
        ----------------------
        -- Stage 1
        ----------------------
    
        -- Generate MCLK 
        if MCLK_counter=to_unsigned(clk_MCLK_factor-1,16) then
            MCLK_counter   <= (others=>'0');
            MCLK_inside    <= not(MCLK_inside);
        else
            MCLK_counter <= MCLK_counter+1;
        end if;
        
        -- Generate LRCLK 
        if LRCLK_counter=to_unsigned(clk_LRCLK_factor-1,16) then
            LRCLK_counter   <= (others=>'0');
            LRCLK_inside    <= not(LRCLK_inside);
        else
            LRCLK_counter <= LRCLK_counter+1;
        end if;
        
        -- Generate SCLK 
        if SCLK_counter=to_unsigned(clk_SCLK_factor-1,16) then
            SCLK_counter   <= (others=>'0');
            SCLK_inside    <= not(SCLK_inside);
        else
            SCLK_counter <= SCLK_counter+1;
        end if;
        
        ----------------------
        -- Stage 2
        ----------------------
        
        -- Generate a data request on LRCLK falling edge
        if (LRCLK_inside='0' and LRCLK_inside_d1='1') then
            req_data <= '1';
        else
            req_data <= '0';
        end if;
        
        -- Buffer saved data on LRCLK rising edge
        if ( LRCLK_inside='1' and LRCLK_inside_d1='0') then
            data_in_left_buffered   <= data_in_left_saved;
            data_in_right_buffered  <= data_in_right_saved;     
        end if;

        -- Generate a counter going from 0 to nb_bit inside a LRCK half period
        if ( LRCLK_inside='1' and LRCLK_inside_d1='0') or (LRCLK_inside='0' and LRCLK_inside_d1='1') then
            sample_counter <= (others=>'0');
        elsif SCLK_inside='0' and SCLK_inside_d1='1' then
            sample_counter <= sample_counter+1;
        end if;

        --Delays
        MCLK_inside_d1  <= MCLK_inside;
        LRCLK_inside_d1 <= LRCLK_inside;
        SCLK_inside_d1  <= SCLK_inside;
        
        ----------------------
        -- Stage 2
        ----------------------

        --Unserialize data
        --Left 
        if LRCLK_inside_d1='1' then
            --Falling edge detection
            if SCLK_inside_d1='0' and SCLK_inside_d2='1' then
                for I in 0 to nb_bits-1 loop 
                  if sample_counter=to_unsigned(I,16) then
                    SD_inside <= data_in_left_buffered(nb_bits-1-I);
                  end if;
                end loop;
            end if;
        end if;
        --Right
        if LRCLK_inside_d1='0' then
            --Falling edge detection
            if SCLK_inside_d1='0' and SCLK_inside_d2='1' then
                for I in 0 to nb_bits-1 loop 
                  if sample_counter=to_unsigned(I,16) then
                    SD_inside <= data_in_right_buffered(nb_bits-1-I);
                  end if;
                end loop;
            end if;
        end if;
        
        --Delays
        MCLK_inside_d2  <= MCLK_inside_d1;
        LRCLK_inside_d2 <= LRCLK_inside_d1;
        SCLK_inside_d2  <= SCLK_inside_d1;
        
        ----------------------
        -- Stage 3
        ----------------------
        
        --To outputs
        MCLK_out  <= MCLK_inside_d2;
        LRCLK_out <= LRCLK_inside_d2;
        SCLK_out  <= SCLK_inside_d2;
        SD_out    <= SD_inside;

    end if;
end process;


end rtl;