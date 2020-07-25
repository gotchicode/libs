
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity polyphase_interp_tb is
end polyphase_interp_tb;

architecture rtl of polyphase_interp_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk      : std_logic;
signal rst      : std_logic;
signal rst_n    : std_logic;

--data generation signals
signal enc_data_in : std_logic_vector(0 downto 0);
signal enc_data_in_en : std_logic;
signal enc_data_out : std_logic_vector(0 downto 0);
signal enc_data_out_en : std_logic;

--polyphase signals
signal data_in : std_logic_vector(15 downto 0);
signal data_in_en : std_logic;
signal data_in_phase : std_logic_vector(31 downto 0);
signal data_out : std_logic_vector(15 downto 0);
signal data_out_en : std_logic;
signal frequency_prog : std_logic_vector(15 downto 0);

-- input signal



begin

    -----------------------------------------
    -- clk generation
    -----------------------------------------
    clk_gen_pr: process
    begin
        clk <= '1';
        wait for clk_const;

        clk <= '0';
        wait for clk_const;
    end process;


    -----------------------------------------
    -- rst generation
    -----------------------------------------
    rst_gen_pr:process
    begin

        rst <= '0';
        wait for 1 us;

        rst <= '1';
        wait for rst_const;

        rst <= '0';
        wait;

    end process;
    
    rst_n <= not(rst);
    
    -- Encode and decode inside the same module
    pn_enc_dec_inst : entity work.pn_enc_dec
    generic map(
        bit_size =>1
        )
    port map
        (
        clk => clk,
        rst_n => rst_n,
        enc_data_in => enc_data_in,
        enc_data_in_en => enc_data_in_en,
        enc_data_out => enc_data_out,
        enc_data_out_en => enc_data_out_en,
        dec_data_in => enc_data_out,
        dec_data_in_en => enc_data_out_en,
        dec_data_out => open,
        dec_data_out_en => open
);

    enc_data_in <= "1";


    polyphase_interp_inst : entity work.polyphase_interp
    port map
        (
        clk => clk,
        rst => rst,
        data_in => data_in,
        data_in_en => data_in_en,
        data_in_phase => data_in_phase,
        data_out => data_out,
        data_out_en => data_out_en,
        frequency_prog => frequency_prog
);

process(clk, rst)    
variable v_clockrate_reg      : unsigned(31 downto 0):=(others=>'0');
variable v_clockrate_reg_d1   : unsigned(31 downto 0):=(others=>'0');
variable v_clockrate_reg_conf : unsigned(31 downto 0):=(others=>'0');                                                              
begin                                                                         
    if rst='1' then
    
        v_clockrate_reg       := (others=>'0');
        v_clockrate_reg_d1    := (others=>'0');  
        v_clockrate_reg_conf  := (others=>'0');  
        
        data_in_en            <= '0';
        data_in               <= (others=>'0');
    
    elsif rising_edge(clk) then  
        
        if enc_data_out="1" then
            data_in <= std_logic_vector(to_signed(1024,16));
        elsif enc_data_out="0" then
            data_in <= std_logic_vector(to_signed(-1024,16));
        end if;
        data_in_en      <= enc_data_out_en;

        --affecting input enable
        enc_data_in_en <= v_clockrate_reg(31) and not(v_clockrate_reg_d1(31));
        
        --generate input enable
        v_clockrate_reg_d1 := v_clockrate_reg;
        v_clockrate_reg_conf        := to_unsigned(integer(real(real(10000000)*real(4294967296.0)/real(150000000))),32);
        v_clockrate_reg := v_clockrate_reg + v_clockrate_reg_conf;

    end if;                                                                   
end process; 

end rtl;
