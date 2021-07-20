library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity cubic_interpolator is
    generic (
        sample_size               : integer:=12;
        sample_instant_size       : integer:=32
    );
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    sample_in                       : in std_logic_vector(sample_size-1 downto 0);    
    sample_in_en                    : in std_logic;    
    sample_instant_in               : in std_logic_vector(sample_instant_size-1 downto 0);
    rf_on_off_in                    : in std_logic;
    modu_on_off_in                  : in std_logic;
    power_level_in                  : in std_logic_vector(15 downto 0);
    phase_in                        : in std_logic_vector(31 downto 0);

    sample_out                      : out std_logic_vector(sample_size-1 downto 0);   
    sample_out_en                   : out std_logic;      
    rf_on_off_out                   : out std_logic;
    modu_on_off_out                 : out std_logic;
    power_level_out                 : out std_logic_vector(15 downto 0);
    phase_out                       : out std_logic_vector(31 downto 0)
 );
end entity cubic_interpolator;

architecture rtl of cubic_interpolator is

constant zero_line  : signed(127 downto 0):=(others=>'0');

signal y0           : signed(sample_size-1 downto 0);
signal y1           : signed(sample_size-1 downto 0);
signal y2           : signed(sample_size-1 downto 0);
signal y3           : signed(sample_size-1 downto 0);
signal y_en         : std_logic;
signal mu_tmp       : signed(sample_instant_size-1 downto 0);

signal a0           : signed(sample_size-1+3 downto 0);
signal a1           : signed(sample_size-1+3+3 downto 0);
signal a2           : signed(sample_size-1+1 downto 0);
signal a3           : signed(sample_size-1 downto 0);
signal mu_bis_tmp   : signed(sample_instant_size-1+sample_instant_size-1+1 downto 0);
signal mu_tmp_d1    : signed(sample_instant_size-1 downto 0);
signal a_en         : std_logic;

signal a0_d1        : signed(sample_size-1+3 downto 0);
signal a1_d1        : signed(sample_size-1+3+3 downto 0);
signal a2_d1        : signed(sample_size-1+1 downto 0);
signal a3_d1        : signed(sample_size-1 downto 0);

signal mu_cube      : signed(sample_instant_size-1+sample_instant_size-1+sample_instant_size-1+2 downto 0);
signal mu_tmp_d2    : signed(sample_instant_size-1 downto 0);
signal mu_bis_tmp_d1: signed(sample_instant_size-1+sample_instant_size-1+1 downto 0);
signal mu_cube_en   : std_logic; 

signal a0_mult_term_pre : signed(sample_size-1+4+sample_instant_size-1+sample_instant_size-1+sample_instant_size-1+2 downto 0);
signal a1_mult_term_pre : signed(sample_size-1+3+3+sample_instant_size-1+sample_instant_size-1+1+1 downto 0);
signal a2_mult_term_pre : signed(sample_size-1+1+sample_instant_size-1+1 downto 0);
signal a3_mult_term_pre : signed(sample_size-1 downto 0);
signal a_mult_pre_en    : std_logic; 

signal a0_mult_term : signed(sample_size-1+4+sample_instant_size-1+sample_instant_size-1+sample_instant_size-1+2 downto 0);
signal a1_mult_term : signed(sample_instant_size + sample_size-1+3+3+sample_instant_size-1+sample_instant_size-1+1+1 downto 0);
signal a2_mult_term : signed(sample_instant_size+sample_instant_size + sample_size-1+1+sample_instant_size-1+1 downto 0);
signal a3_mult_term : signed(sample_instant_size+sample_instant_size+sample_instant_size + sample_size-1 downto 0);
signal a_mult_en    : std_logic;   

signal a0_mult_term_PLUS_a1_mult_term : signed(sample_instant_size + sample_size-1+3+3+sample_instant_size-1+sample_instant_size-1+1+1 downto 0);
signal a2_mult_term_PLUS_a3_mult_term : signed(sample_instant_size+sample_instant_size + sample_size-1+1+sample_instant_size-1+1 downto 0);
signal a_mult_sum : std_logic;  


signal result_pre       : signed(sample_instant_size + sample_size-1+3+3+sample_instant_size-1+sample_instant_size-1+1+1 downto 0);
signal result_pre_en    : std_logic;


begin

------------------------------------------                                                           
-- Processing                                                                    
------------------------------------------ 
processing_pr: process(clk, rst)
begin
    if rst='1' then
    
        y0                  <= (others=>'0');
        y1                  <= (others=>'0');   
        y2                  <= (others=>'0');   
        y3                  <= (others=>'0');
        y_en                <= '0';
        
        mu_tmp              <= (others=>'0');
        
        a0                  <= (others=>'0');
        a1                  <= (others=>'0');
        a2                  <= (others=>'0');
        a3                  <= (others=>'0');
        mu_bis_tmp          <= (others=>'0');
        mu_tmp_d1           <= (others=>'0');
        a_en                <= '0';
        
        a0_d1               <= (others=>'0');
        a1_d1               <= (others=>'0');
        a2_d1               <= (others=>'0');
        a3_d1               <= (others=>'0');
        
        mu_cube             <= (others=>'0');
        mu_tmp_d2           <= (others=>'0');
        mu_bis_tmp_d1       <= (others=>'0');
        mu_cube_en          <= '0';
        
        a0_mult_term_pre    <= (others=>'0');
        a1_mult_term_pre    <= (others=>'0');
        a2_mult_term_pre    <= (others=>'0');
        a3_mult_term_pre    <= (others=>'0');
        a_mult_pre_en       <= '0';
        
        a0_mult_term        <= (others=>'0');
        a1_mult_term        <= (others=>'0');
        a2_mult_term        <= (others=>'0');
        a3_mult_term        <= (others=>'0');
        a_mult_en           <= '0';
        
        a0_mult_term_PLUS_a1_mult_term  <= (others=>'0');
        a2_mult_term_PLUS_a3_mult_term  <= (others=>'0');
        a_mult_sum                      <= '0';
        
        
        result_pre       <= (others=>'0');
        result_pre_en    <= '0';
        

    elsif rising_edge(clk) then
    
        -- Shift register of the incoming samples
        -- Delay 1
        if sample_in_en='1' then
            y0      <= y1;
            y1      <= y2;    
            y2      <= y3;   
            y3      <= signed(sample_in);     
        end if;
        y_en        <= sample_in_en;
        mu_tmp      <= signed(sample_instant_in);
        
        --Compute taps
        a0          <= resize(y3,sample_size+3)-resize(y2,sample_size+3)-resize(y0,sample_size+3)+resize(y1,sample_size+3); -- +3 on bus size
        a1          <= resize(y0,sample_size+3+3)-resize(y1,sample_size+3+3)-resize(a0,sample_size+3+3); -- +3 on bus size
        a2          <= resize(y2,sample_size+1)-resize(y0,sample_size+1); -- +1 on bus side
        a3          <= resize(y1,sample_size); -- +0
        mu_bis_tmp  <= mu_tmp * mu_tmp;
        mu_tmp_d1   <= mu_tmp;
        a_en        <= y_en;
        
        -- interpolated value calculus part 1
        a0_d1           <= a0; 
        a1_d1           <= a1;         
        a2_d1           <= a2;         
        a3_d1           <= a3;         
        mu_cube         <= mu_tmp_d1 * mu_bis_tmp;
        mu_tmp_d2       <= mu_tmp_d1;
        mu_bis_tmp_d1   <= mu_bis_tmp;
        mu_cube_en      <= a_en;
        
        -- interpolated value calculus part 2
        a0_mult_term_pre    <= a0_d1 * mu_cube;
        a1_mult_term_pre    <= a1_d1 * mu_bis_tmp_d1;
        a2_mult_term_pre    <= a2_d1 * mu_tmp_d2;
        a3_mult_term_pre    <= a3_d1;
        a_mult_pre_en       <= mu_cube_en;
        
        a0_mult_term        <= a0_mult_term_pre;
        a1_mult_term        <= a1_mult_term_pre & zero_line(sample_instant_size-1 downto 0);   
        a2_mult_term        <= a2_mult_term_pre & zero_line(sample_instant_size+sample_instant_size-1 downto 0);
        a3_mult_term        <= a3_mult_term_pre & zero_line(sample_instant_size+sample_instant_size+sample_instant_size-1 downto 0);
        a_mult_en           <= a_mult_pre_en;
        
        -- interpolated value calculus part 4
        a0_mult_term_PLUS_a1_mult_term <= a0_mult_term+a1_mult_term;
        a2_mult_term_PLUS_a3_mult_term <= a2_mult_term+a3_mult_term;
        a_mult_sum                     <= a_mult_en;

        -- result
        result_pre                     <= a0_mult_term_PLUS_a1_mult_term + a2_mult_term_PLUS_a3_mult_term;
        result_pre_en                  <= a_mult_sum;
        
    
    end if;
end process;

------------------------------------------                                                           
-- Calculate mu                                                                         
------------------------------------------ 
mu_calc_pr: process(clk, rst)
begin
    if rst='1' then
    
    elsif rising_edge(clk) then

    
    end if;
end process;

end rtl;