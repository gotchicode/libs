library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gain_mult is
	port
	(
		clk		            : in std_logic;
		rst		            : in std_logic;
        
        data_in             : in std_logic_vector(31 downto 0);
        data_in_en          : in std_logic;
        
        gain_exponent_begin : in std_logic_vector(3 downto 0);
        gain_exponent_end   : in std_logic_vector(3 downto 0);
        gain_mult           : in std_logic_vector(17 downto 0);
        
        data_out            : out std_logic_vector(56 downto 0);
        data_out_en         : out std_logic

	);
end gain_mult;

architecture rtl of gain_mult is

signal stage_1_data         : std_logic_vector(38 downto 0);
signal stage_2_data         : std_logic_vector(38 downto 0);
signal stage_3_data         : std_logic_vector(56 downto 0);
signal stage_4_data         : std_logic_vector(56 downto 0);
signal stage_5_data         : std_logic_vector(56 downto 0);
signal stage_6_data         : std_logic_vector(56 downto 0);

signal stage_1_data_en      : std_logic;
signal stage_2_data_en      : std_logic;
signal stage_3_data_en      : std_logic;
signal stage_4_data_en      : std_logic;
signal stage_5_data_en      : std_logic;
signal stage_6_data_en      : std_logic;


begin

--template_pr: process(clk, rst_n)
--begin
--    if rst_n='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

main_pr: process(clk, rst)
begin
    if rst='1' then
    
        stage_1_data    <= (others=>'0');
        stage_2_data    <= (others=>'0');    
        stage_3_data    <= (others=>'0');    
        stage_4_data    <= (others=>'0');    
        stage_5_data    <= (others=>'0');    
        stage_6_data    <= (others=>'0');   

        stage_1_data_en <= '0';
        stage_2_data_en <= '0';
        stage_3_data_en <= '0';
        stage_4_data_en <= '0';
        stage_5_data_en <= '0';
        stage_6_data_en <= '0';

    elsif rising_edge(clk) then
    
        ------------------------------------------------
        -- Stage 1 - Apply gain exponent begin
        ------------------------------------------------
        case gain_exponent_begin is
            when x"8" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 7)),39)); 
            when x"9" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 6)),39)); 
            when x"A" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 5)),39)); 
            when x"B" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 4)),39)); 
            when x"C" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 3)),39)); 
            when x"E" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 2)),39)); 
            when x"F" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 1)),39)); 
            when x"0" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),39)); 
            when x"1" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),38)) & '0'; 
            when x"2" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),37)) & "00"; 
            when x"3" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),36)) & "000"; 
            when x"4" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),35)) & "0000"; 
            when x"5" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),34)) & "00000"; 
            when x"6" =>    Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),33)) & "000000"; 
            when x"7" =>    Stage_1_data <= data_in(31 downto 0) & "0000000"; 
            when others =>  Stage_1_data <= std_logic_vector(resize(signed(data_in(31 downto 0)),39));                     
        end case;
        stage_1_data_en <= data_in_en;
            
        ------------------------------------------------
        -- Stage 2 - Pause
        ------------------------------------------------
        Stage_2_data <= Stage_1_data;
        stage_2_data_en <= stage_1_data_en;
        ------------------------------------------------
        -- Stage 3 - Multiplier gain
        ------------------------------------------------
        Stage_3_data <= std_logic_vector(signed(Stage_2_data) * signed(gain_mult));
        stage_3_data_en <= stage_2_data_en;
        ------------------------------------------------
        -- Stage 4 - Pause
        ------------------------------------------------
        Stage_4_data <= Stage_3_data;
        stage_4_data_en <= stage_3_data_en;
        
        ------------------------------------------------
        -- Stage 5 - Apply gain exponent end
        ------------------------------------------------
        case gain_exponent_end is
            when x"8" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 7)),57)); 
            when x"9" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 6)),57)); 
            when x"A" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 5)),57)); 
            when x"B" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 4)),57)); 
            when x"C" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 3)),57)); 
            when x"E" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 2)),57)); 
            when x"F" =>    Stage_5_data <= std_logic_vector(resize(signed(Stage_4_data(56 downto 1)),57)); 
            when x"0" =>    Stage_5_data <= Stage_4_data(56 downto 0);
            when others =>  Stage_5_data <= Stage_4_data(56 downto 0);
        end case;
        stage_5_data_en <= stage_4_data_en;
        
        ------------------------------------------------
        -- Stage 6 - Pause
        ------------------------------------------------
        Stage_6_data <= Stage_5_data;
        stage_6_data_en <= stage_5_data_en;
        
    end if;
end process;

data_out    <= Stage_6_data;
data_out_en <= stage_6_data_en;


end rtl;