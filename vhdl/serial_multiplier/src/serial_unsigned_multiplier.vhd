library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_unsigned_multiplier is
generic (nb_bits       : integer:=4 -- Inputs size
);
	port
	(
		clk		            : in std_logic;
		rst		            : in std_logic;
        
        data_A_in           : in std_logic_vector(nb_bits-1 downto 0);
        data_B_in           : in std_logic_vector(nb_bits-1 downto 0);
        data_in_en          : in std_logic;
        
        data_out            : out std_logic_vector(nb_bits+nb_bits-1 downto 0);
        data_out_en         : out std_logic;
        
        busy                : out  std_logic

	);
end serial_unsigned_multiplier;

architecture rtl of serial_unsigned_multiplier is

signal s_data_A_in          : unsigned(nb_bits-1 downto 0);
signal s_data_B_in          : unsigned(nb_bits-1 downto 0); 
signal s_data_A_srl         : unsigned(nb_bits+nb_bits-1 downto 0);
signal s_data_in_en         : std_logic_vector(nb_bits-1 downto 0);

signal busy_cnt             : unsigned(nb_bits-1 downto 0);

signal adder_in_en          : std_logic;
signal adder_in_A           : unsigned(nb_bits+nb_bits+2 downto 0);
signal adder_in_B           : unsigned(nb_bits+nb_bits+2 downto 0);
signal adder_out            : unsigned(nb_bits+nb_bits+2 downto 0);
signal adder_out_en         : std_logic;


begin

--------------------------------------------------------------------
-- Busy cnt
--------------------------------------------------------------------
busy_pr: process(clk, rst)
begin
    if rst='1' then
        busy_cnt    <= (others=>'0');
        busy        <= '0';
    elsif rising_edge(clk) then
        if data_in_en='1' then
            busy_cnt <= to_unsigned(1,nb_bits);
        elsif busy_cnt<to_unsigned(nb_bits+4,nb_bits) then
            busy_cnt <= busy_cnt+1;
        end if;
        
        if data_in_en='1' then
            busy    <=  '1';
        elsif busy_cnt=to_unsigned(nb_bits+4,nb_bits) then
            busy    <=  '0';
        end if;

    end if;
end process;


--------------------------------------------------------------------
-- Adder
--------------------------------------------------------------------
adder_pr: process(clk, rst)
begin
    if rst='1' then

        adder_out       <= (others=>'0');     
        adder_out_en    <= '0';   
        
    elsif rising_edge(clk) then
        adder_out   <= adder_in_A + adder_in_B;
        adder_out_en<= adder_in_en;

    end if;
end process;

--------------------------------------------------------------------
-- Main
--------------------------------------------------------------------
main_pr: process(clk, rst)
variable v_set_2_zero   : unsigned(nb_bits+nb_bits-1 downto 0);
begin
    if rst='1' then
    
        s_data_A_in     <= (others=>'0');
        s_data_B_in     <= (others=>'0');
        s_data_in_en    <= (others=>'0');
        s_data_A_srl    <= (others=>'0'); 
        
        adder_in_en     <= '0';   
        adder_in_A      <= (others=>'0');   
        adder_in_B      <= (others=>'0');   
        
    elsif rising_edge(clk) then
    
        s_data_in_en(0) <= data_in_en;
        s_data_in_en(s_data_in_en'left downto 1) <= s_data_in_en(s_data_in_en'left-1 downto 0);

        -- STEP 0
        if data_in_en='1' then
            s_data_A_in  <= unsigned(data_A_in);
            s_data_B_in  <= unsigned(data_B_in);
            s_data_A_srl <= resize(unsigned(data_A_in),nb_bits+nb_bits);
        else
            s_data_A_srl(0) <= '0';
            s_data_A_srl(s_data_A_srl'left downto 1) <= s_data_A_srl(s_data_A_srl'left-1 downto 0);
        end if;
        


    end if;
end process;

--main_pr: process(clk, rst)
--variable v_set_2_zero : unsigned(nb_bits+nb_bits-1 downto 0);
--begin
--    if rst='1' then
--        data_out                <= (others=>'0');
--        s_data_A_in             <= (others=>'0');
--        s_data_B_in             <= (others=>'0');
--        prepare_adder_init      <= '0';  
--        prepare_adder_in_en     <= '0';  
--        prepare_adder_in        <= (others=>'0');
--    elsif rising_edge(clk) then
--    
--        v_set_2_zero := (others=>'0');
--        
--        s_data_in_en(0) <= data_in_en;
--        s_data_in_en(nb_bits-1+1+1+1 downto 1) <= s_data_in_en(nb_bits-1+1+1+1-1 downto 1-1);
--        
--        -- STEP 0
--        if data_in_en='1' then
--            s_data_A_in  <= unsigned(data_A_in);
--            s_data_B_in  <= unsigned(data_B_in);
--        end if;
--               
--        -- STEP 1
--        if s_data_in_en(0)='1' then
--            if s_data_B_in(0)='0' then
--                prepare_adder_in    <= (others=>'0');
--                prepare_adder_init  <= '1';
--                prepare_adder_in_en <= '1';
--            end if;
--            if s_data_B_in(0)='1' then
--                v_set_2_zero(nb_bits-1 downto 0) := s_data_A_in;
--                prepare_adder_in    <= v_set_2_zero;
--                prepare_adder_init  <= '1';
--                prepare_adder_in_en <= '1';
--            end if;
--        end if;
--        
--        --Step 2 to nb_bits
--        for I in 2 to nb_bits loop
--        
--            if s_data_in_en(I-1)='1' then
--                if s_data_B_in(I-1)='0' then        
--                    prepare_adder_in    <= (others=>'0');        
--                    prepare_adder_init  <= '0';        
--                    prepare_adder_in_en <= '1';        
--                end if;        
--                if s_data_B_in(I-1)='1' then        
--                    v_set_2_zero(nb_bits-1+I-1 downto 0+I-1) := s_data_A_in;        
--                    prepare_adder_in    <= v_set_2_zero;        
--                    prepare_adder_init  <= '0';        
--                    prepare_adder_in_en <= '1';        
--                end if;        
--            end if;    
--            
--        end loop;
--        
--        -- STEP nb_bits+1
--        if s_data_in_en(nb_bits)='1' then
--            prepare_adder_init  <= '0';
--            prepare_adder_in_en <= '0';
--        end if;
--        
--        -- STEP nb_bits+2
--        --Nothing happens here
--        
--        -- STEP nb_bits+3
--        if s_data_in_en(nb_bits+2)='1' then
--            data_out <= std_logic_vector(adder_accu);
--        end if;
--        data_out_en <= s_data_in_en(nb_bits+2);
--
--    
--    end if;
--end process;

end rtl;