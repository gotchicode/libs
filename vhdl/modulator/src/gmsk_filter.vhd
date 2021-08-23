library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gmsk_filter is
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    symbol_in                       : in std_logic_vector(11 downto 0); 
    symbol_in_en                    : in std_logic;    
    sample_in_en                    : in std_logic;    
    sample_instant_in               : in std_logic_vector(31 downto 0);
    rf_on_off_in                    : in std_logic;
    modu_on_off_in                  : in std_logic;
    power_level_in                  : in std_logic_vector(15 downto 0);
    phase_in                        : in std_logic_vector(31 downto 0);
    
    interp_factor                   : in std_logic_vector(15 downto 0);
    taps_max_index                  : in std_logic_vector(15 downto 0);
    cnt1_init                       : in std_logic_vector(11 downto 0);
    cnt2_init                       : in std_logic_vector(11 downto 0);
    cnt3_init                       : in std_logic_vector(11 downto 0);
    cnt4_init                       : in std_logic_vector(11 downto 0);
    cnt5_init                       : in std_logic_vector(11 downto 0);
    
    taps_ram_add_write              : in std_logic_vector(12-1 downto 0); 
    taps_ram_data_write             : in std_logic_vector(16-1 downto 0);
    taps_ram_wr_en                  : in std_logic;  
    taps_ram_add_read               : in std_logic_vector(12-1 downto 0); 
    taps_ram_rd_en                  : in std_logic; 
    taps_ram_data_read              : out std_logic_vector(16-1 downto 0);
    

    symbol_out_en                   : out std_logic;    
    sample_out                      : out std_logic_vector(11 downto 0);
    sample_out_en                   : out std_logic;    
    sample_instant_out              : out std_logic_vector(31 downto 0);    
    rf_on_off_out                   : out std_logic;
    modu_on_off_out                 : out std_logic;
    power_level_out                 : out std_logic_vector(15 downto 0);
    phase_out                       : out std_logic_vector(31 downto 0)
 );
end entity gmsk_filter;

architecture rtl of gmsk_filter is

--RAM constants
constant number_of_cells            : integer:=4096;
constant addr_width                 : integer:=12;
constant data_width                 : integer:=16;

-- Ram access signals
signal ram1_add_write               : std_logic_vector(addr_width-1 downto 0);
signal ram1_data_write              : std_logic_vector(data_width-1 downto 0);
signal ram1_wr_en                   : std_logic;
signal ram1_add_read                : std_logic_vector(addr_width-1 downto 0);
signal ram1_rd_en                   : std_logic;
signal ram1_data_read               : std_logic_vector(data_width-1 downto 0);

-- 5 counters to count samples positions relative to ram
signal ram_cnt_1                    : unsigned(11 downto 0); -- Max value is the number of possible taps (here is it 4096)
signal ram_cnt_2                    : unsigned(11 downto 0);
signal ram_cnt_3                    : unsigned(11 downto 0);
signal ram_cnt_4                    : unsigned(11 downto 0);
signal ram_cnt_5                    : unsigned(11 downto 0);
signal ram_cnt_en                   : std_logic;

-- 5 counters delays
signal ram_cnt_2_d1                 : unsigned(11 downto 0); 
signal ram_cnt_3_d1                 : unsigned(11 downto 0); 
signal ram_cnt_4_d1                 : unsigned(11 downto 0); 
signal ram_cnt_5_d1                 : unsigned(11 downto 0); 
signal ram_cnt_en_d1                : std_logic; 
signal ram_cnt_3_d2                 : unsigned(11 downto 0);
signal ram_cnt_4_d2                 : unsigned(11 downto 0);
signal ram_cnt_5_d2                 : unsigned(11 downto 0);
signal ram_cnt_en_d2                : std_logic;
signal ram_cnt_4_d3                 : unsigned(11 downto 0);
signal ram_cnt_5_d3                 : unsigned(11 downto 0);
signal ram_cnt_en_d3                : std_logic;
signal ram_cnt_5_d4                 : unsigned(11 downto 0);
signal ram_cnt_en_d4                : std_logic;
signal ram_cnt_en_d5                : std_logic;

-- Ram valid read signals
signal ram_counter_instant_read         : unsigned(2 downto 0); --3 bits, from 0 to 7
signal ram_counter_instant_read_valid   : std_logic;


signal interp_counter               : unsigned(15 downto 0);
signal interp_counter_en            : std_logic;

begin

------------------------------------------                                                           
-- Filter                                                                  
------------------------------------------
Filter_pr: process(clk, rst)
begin
    if rst='1' then
    
        -- interp_counter       <= (others=>'0');
        -- interp_counter_en    <= '0';
        
        ram_cnt_1                    <= (others=>'0'); 
        ram_cnt_2                    <= (others=>'0');      
        ram_cnt_3                    <= (others=>'0');         
        ram_cnt_4                    <= (others=>'0');         
        ram_cnt_5                    <= (others=>'0');   
        ram_cnt_en                   <= '0';
        ram_cnt_2_d1                 <= (others=>'0');
        ram_cnt_3_d1                 <= (others=>'0');       
        ram_cnt_4_d1                 <= (others=>'0');       
        ram_cnt_5_d1                 <= (others=>'0');       
        ram_cnt_en_d1                <= '0';
        ram_cnt_3_d2                 <= (others=>'0');         
        ram_cnt_4_d2                 <= (others=>'0');       
        ram_cnt_5_d2                 <= (others=>'0');      
        ram_cnt_en_d2                <= '0';
        ram_cnt_4_d3                 <= (others=>'0');     
        ram_cnt_5_d3                 <= (others=>'0');     
        ram_cnt_en_d3                <= '0';   
        ram_cnt_5_d4                 <= (others=>'0');        
        ram_cnt_en_d4                <= '0';
        ram_cnt_en_d5                <= '0';   
        
        ram_counter_instant_read            <= (others=>'0');     
        ram_counter_instant_read_valid      <= '0';         

    elsif rising_edge(clk) then
    
        -- Generate the counters to select the samples from ram
        if symbol_in_en='1' and sample_in_en='1' then
            ram_cnt_1 <= unsigned(cnt1_init);
            ram_cnt_2 <= unsigned(cnt2_init);
            ram_cnt_3 <= unsigned(cnt3_init);
            ram_cnt_4 <= unsigned(cnt4_init);
            ram_cnt_5 <= unsigned(cnt5_init);
        end if;
        
        if symbol_in_en='0' and sample_in_en='1' then
            ram_cnt_1 <= ram_cnt_1+1;
            ram_cnt_2 <= ram_cnt_2+1;
            ram_cnt_3 <= ram_cnt_3+1;
            ram_cnt_4 <= ram_cnt_4+1;
            ram_cnt_5 <= ram_cnt_5+1;
        end if;
        ram_cnt_en <= sample_in_en;
        
        -- Read a tap for ram_cnt_1
        if ram_cnt_en='1' then
            ram1_add_read       <= std_logic_vector(ram_cnt_1);
        end if;
        ram_cnt_2_d1        <= ram_cnt_2;
        ram_cnt_3_d1        <= ram_cnt_3;
        ram_cnt_4_d1        <= ram_cnt_4;
        ram_cnt_5_d1        <= ram_cnt_5;
        ram_cnt_en_d1       <= ram_cnt_en;
        
        -- Read a tap for ram_cnt_2
        if ram_cnt_en_d1='1' then
            ram1_add_read       <= std_logic_vector(ram_cnt_2_d1);
        end if;
        ram_cnt_3_d2        <= ram_cnt_3_d1;
        ram_cnt_4_d2        <= ram_cnt_4_d1;
        ram_cnt_5_d2        <= ram_cnt_5_d1;
        ram_cnt_en_d2       <= ram_cnt_en_d1;

        -- Read a tap for ram_cnt_3
        if ram_cnt_en_d2='1' then
            ram1_add_read       <= std_logic_vector(ram_cnt_3_d2);
        end if;
        ram_cnt_4_d3        <= ram_cnt_4_d2;
        ram_cnt_5_d3        <= ram_cnt_5_d2;
        ram_cnt_en_d3       <= ram_cnt_en_d2;
        
        -- Read a tap for ram_cnt_4
        if ram_cnt_en_d3='1' then
            ram1_add_read       <= std_logic_vector(ram_cnt_4_d3);
        end if;
        ram_cnt_5_d4        <= ram_cnt_5_d3;
        ram_cnt_en_d4       <= ram_cnt_en_d3;

        -- Read a tap for ram_cnt_5
        if ram_cnt_en_d4='1' then
            ram1_add_read       <= std_logic_vector(ram_cnt_5_d4);
        end if;
        ram_cnt_en_d5       <= ram_cnt_en_d4;
        
        --This is an or for 5 possible reads
        ram1_rd_en          <= ram_cnt_en or ram_cnt_en_d1 or ram_cnt_en_d2 or ram_cnt_en_d3 or ram_cnt_en_d4;
        
        --Generate a counter to catch ram output
        if ram_cnt_en_d1='1' then
            ram_counter_instant_read <= (others=>'0');
        else
            ram_counter_instant_read <= ram_counter_instant_read +1;
        end if;
        
        --Generate the pulse when to reqd
        ram_counter_instant_read_valid <= ram1_rd_en;
        
        --Store data to an adder tree of 5 cells
        case ram_counter_instant_read is
            when x"0" =>
            when x"1" =>
            when x"2" =>
            when x"3" =>
            when x"4" =>
            when others =>
        end case;

    
        -- 
        -- -- For example, interp_factor=4, taps_max_index=interp_factor*4+1=17 and taps_per_bank=4
        -- -- sample0: 0 4 8 12 16
        -- -- sample1: 1 5 9 13 17
        -- -- sample2: 2 6 10 14 

    end if;
end process;


------------------------------------------                                                           
-- Write taps to ram                                                     
------------------------------------------

ram1_wr_en      <= taps_ram_wr_en;
ram1_add_write  <= taps_ram_add_write;
ram1_data_write <= taps_ram_data_write; 

------------------------------------------                                                           
-- RAM1                                                                 
------------------------------------------

single_ram_1_inst : entity work.single_ram
generic map(
    number_of_cells   => number_of_cells,
    addr_width        => addr_width,
    data_width        => data_width
)
port map
    (
    clk             => clk,
    add_write       => ram1_add_write,
    data_write      => ram1_data_write,
    wr_en           => ram1_wr_en,
    add_read        => ram1_add_read,
    rd_en           => ram1_rd_en,
    data_read       => ram1_data_read
);

end rtl;