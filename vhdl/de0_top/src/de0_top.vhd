library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity de0_top is
    generic (
              simu      : integer:=0
    );
 port (
            CLOCK_50                : in std_logic;
            CLOCK_50_2              : in std_logic;
     
            BUTTON                  : in std_logic_vector(2 downto 0);
            SW                      : in std_logic_vector(9 downto 0); 
            
            LEDG                    : out std_logic_vector(9 downto 0);
            
            
            GPIO0_D_31              : out std_logic;
            GPIO0_D_30              : out std_logic;
            GPIO0_D_29              : out std_logic;
            GPIO0_D_28              : out std_logic;
            GPIO0_D_27              : out std_logic;
            GPIO0_D_26              : out std_logic;
            GPIO0_D_25              : out std_logic;
            GPIO0_D_24              : out std_logic;
            GPIO0_D_23              : out std_logic;
            GPIO0_D_22              : out std_logic;
            GPIO0_D_21              : out std_logic;
            GPIO0_D_20              : out std_logic;
            GPIO0_D_19              : out std_logic;
            GPIO0_D_18              : out std_logic;
            GPIO0_D_17              : out std_logic;
            GPIO0_D_16              : out std_logic;
            GPIO0_D_15              : out std_logic;
            GPIO0_D_14              : out std_logic;
            GPIO0_D_13              : out std_logic;
            GPIO0_D_12              : out std_logic;
            GPIO0_D_11              : out std_logic;
            GPIO0_D_10              : out std_logic;
            GPIO0_D_9               : out std_logic;
            GPIO0_D_8               : out std_logic;
            GPIO0_D_7               : out std_logic;
            GPIO0_D_6               : out std_logic;
            GPIO0_D_5               : out std_logic;
            GPIO0_D_4               : out std_logic;
            GPIO0_D_3               : out std_logic;
            GPIO0_D_2               : out std_logic;
            GPIO0_D_1               : out std_logic;
            GPIO0_D_0               : out std_logic
     
 );
end entity de0_top;

architecture rtl of de0_top is

--------------------------------------------------------
--Constants
--------------------------------------------------------

constant const_all_ones : std_logic_vector(63 downto 0):=x"FFFFFFFFFFFFFFFF";
constant const_all_zeros : std_logic_vector(63 downto 0):=x"0000000000000000";
constant bit_size       : integer:=24;

--------------------------------------------------------
--Global
--------------------------------------------------------
signal rst                                          : std_logic;
signal clk_main                                     : std_logic; 
signal rst_main                                     : std_logic; 
signal rst_n_main                                   : std_logic; 

--------------------------------------------------------
--Encoder signals
--------------------------------------------------------
signal enc_data_in      : std_logic_vector(bit_size-1 downto 0);
signal enc_data_in_en   : std_logic;
signal enc_data_out     : std_logic_vector(bit_size-1 downto 0);
signal enc_data_out_en  : std_logic;
signal dec_data_in      : std_logic_vector(bit_size-1 downto 0);
signal dec_data_in_en   : std_logic;
signal dec_data_out     : std_logic_vector(bit_size-1 downto 0);
signal dec_data_out_en  : std_logic;

--------------------------------------------------------
--i2s master signals
--------------------------------------------------------
signal data_in_left     : std_logic_vector(24-1 downto 0);
signal data_in_right    : std_logic_vector(24-1 downto 0);
signal data_in_en       : std_logic:='0';
signal mclk_out         : std_logic;
signal lrclk_out        : std_logic;
signal sclk_out         : std_logic;
signal sd_out           : std_logic;
signal req_data         : std_logic;

--------------------------------------------------------
--NCO generation signals
--------------------------------------------------------
signal nco_accu										: unsigned(31 downto 0):=(others=>'0');
signal nco_accu_incr_const							: unsigned(31 downto 0):=to_unsigned(43,32);
signal nco_accu_incr							    : unsigned(31 downto 0):=nco_accu_incr_const;
signal nco_clock                                    : std_logic;
signal nco_clock_d1									: std_logic;
signal nco_clock_top                                : std_logic;

--------------------------------------------------------
--Sinus generation signals
--------------------------------------------------------    
signal phase_accu_reg            : unsigned(31 downto 0);
signal phase_accu_incr           : unsigned(31 downto 0);                           
signal sinus_rom_addr_in         : std_logic_vector(11 downto 0);               
signal sinus_rom_rd_en           : std_logic;                                   
signal sinus_rom_data_out        : std_logic_vector(15 downto 0);              
signal sinus_rom_data_out_en     : std_logic;

--------------------------------------------------------
--Mux signals
--------------------------------------------------------   

signal mux_in      : std_logic_vector(31 downto 0);   
signal mux_in_en   : std_logic;
signal mux_sel     : std_logic_vector(3 downto 0);   
signal mux_out     : std_logic_vector(31 downto 0);   
signal mux_out_en  : std_logic;

--------------------------------------------------------
--Gain mult signals
--------------------------------------------------------  

signal multiplier_data_in             : std_logic_vector(31 downto 0);
signal multiplier_data_in_en          : std_logic;
signal multiplier_gain_exponent_begin : std_logic_vector(3 downto 0);
signal multiplier_gain_exponent_end   : std_logic_vector(3 downto 0);
signal multiplier_gain_mult           : std_logic_vector(17 downto 0);
signal multiplier_data_out            : std_logic_vector(56 downto 0);
signal multiplier_data_out_en         : std_logic;

--------------------------------------------------------
--Debug probes signals
-------------------------------------------------------- 
component probe32 IS
	PORT
	(
		probe		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		source		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

type probe_in_out_type is array (0 to 7) of std_logic_vector(31 downto 0);            
signal probe    : probe_in_out_type;   
signal source   : probe_in_out_type;  

signal reg_phase_accu_incr                 : std_logic_vector(31 downto 0);    
signal reg_mux_sel                         : std_logic_vector(3 downto 0);
signal reg_multiplier_gain_exponent_begin  : std_logic_vector(3 downto 0);
signal reg_multiplier_gain_exponent_end    : std_logic_vector(3 downto 0);
signal reg_multiplier_gain_mult            : std_logic_vector(17 downto 0);
 

begin


rst         <= SW(0);

--template_pr: process(clk, rst_n)
--begin
--    if rst_n='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

--------------------------------------------------------
-- Clock and reset generation
--------------------------------------------------------
clk_rst_gen_inst:  entity work.clk_rst_gen
    generic map (  simu => simu
    )
    port map(
            clk             => CLOCK_50,
            rst             => rst,
            clk0            => clk_main,
            rst0            => rst_main,
            rstn0           => rst_n_main
 );
 
--------------------------------------------------------
--NCO
--------------------------------------------------------
nco_pro: process(clk_main, rst_main)
begin
	if rst_main='1' then
        nco_accu        <= (others=>'0');	     
        nco_clock	    <= '0';    
        nco_clock_d1    <= '0';      
        nco_clock_top   <= '0';   
        nco_accu_incr   <= nco_accu_incr_const;
    elsif rising_edge(clk_main) then
		nco_accu 	        <= nco_accu + nco_accu_incr;
		nco_clock	        <=nco_accu(31);
		nco_clock_d1        <=nco_clock;
		if nco_clock='1' and nco_clock_d1='0' then
            nco_clock_top   <= not(nco_clock_top);
        end if;
	end if;
end process;

--------------------------------------------------------
--PN encoder (Noise generator)
--------------------------------------------------------
pn_enc_dec_inst : entity work.pn_enc_dec
generic map(
    bit_size =>bit_size
    )
port map
    (
    clk => clk_main,
    rst_n => rst_n_main,
    enc_data_in => enc_data_in,
    enc_data_in_en => enc_data_in_en,
    enc_data_out => enc_data_out,
    enc_data_out_en => enc_data_out_en,
    dec_data_in => dec_data_in,
    dec_data_in_en => dec_data_in_en,
    dec_data_out => open,
    dec_data_out_en => open
);

enc_data_in    <= const_all_ones(bit_size-1 downto 0);
enc_data_in_en <= req_data;

--------------------------------------------------------
-- Sinus generator
--------------------------------------------------------
sinus_rom_pr: process(clk_main, rst_main)
variable sinus_rom_rd_en_d1 : std_logic;
begin
	if rst_main='1' then
    
        phase_accu_reg          <= (others=>'0'); 
        phase_accu_incr         <= to_unsigned(24740595,32); -- 200 Hz @ 34.72 KHz
        sinus_rom_addr_in       <= (others=>'0');     
        sinus_rom_rd_en         <= '0';
        sinus_rom_data_out_en   <= '0';
        sinus_rom_rd_en_d1      := '0';
    elsif rising_edge(clk_main) then
    
        --Update phase_accu_incr from a probe
        if source(0)=x"00000001" then
            phase_accu_incr <= unsigned(reg_phase_accu_incr);
        end if;


        if req_data='1' then
            phase_accu_reg <= phase_accu_reg + phase_accu_incr;
        end if;
        
        sinus_rom_addr_in       <= std_logic_vector(phase_accu_reg(31 downto 20));   
        sinus_rom_rd_en         <= req_data;
        sinus_rom_data_out_en   <= sinus_rom_rd_en_d1;
        
        sinus_rom_rd_en_d1 := sinus_rom_rd_en;

	end if;
end process;

sinus_rom_inst: entity work.sinus_rom                                                                 
 port map(                                                                       
            clk             => clk_main,           
            addr_in         => sinus_rom_addr_in,           
            data_out        => sinus_rom_data_out
 );
 
--------------------------------------------------------
-- Mux
--------------------------------------------------------
mux_pr: process(clk_main, rst_main)
begin
	if rst_main='1' then

        mux_in      <= (others=>'0');
        mux_in_en   <= '0';
        mux_sel     <= x"2";
        
        mux_out     <= (others=>'0');
        mux_out_en  <= '0';
        
    elsif rising_edge(clk_main) then
    
        --Update mux_sel from a probe
        if source(0)=x"00000001" then  
            mux_sel <= reg_mux_sel;
        end if;

        case mux_sel is
            when x"0" => 
                mux_out     <= (others=>'0');
                mux_out_en  <= '0';
            when x"1" => 
                mux_out     <= x"0000" & enc_data_out(15 downto 0);
                mux_out_en  <= enc_data_out_en; 
            when x"2" => 
                mux_out     <= std_logic_vector(resize(signed(sinus_rom_data_out),32));
                mux_out_en  <= sinus_rom_data_out_en;
            when others => 
        end case;
        
	end if;
end process;

--------------------------------------------------------
-- Gain
--------------------------------------------------------
gain_pr: process(clk_main, rst_main)
begin
	if rst_main='1' then
    
        multiplier_data_in              <= (others=>'0');
        multiplier_data_in_en           <= '0';
        multiplier_gain_exponent_begin  <= (others=>'0'); 
        multiplier_gain_exponent_end    <= (others=>'0');           
        multiplier_gain_mult            <= std_logic_vector(to_unsigned(1,18));                  
        
    elsif rising_edge(clk_main) then
    
        --Update multiplier_gain_exponent_begin from a probe
        --Update multiplier_gain_exponent_end from a probe
        --Update multiplier_gain_mult from a probe
        if source(0)=x"00000001" then                                        
            multiplier_gain_exponent_begin  <= reg_multiplier_gain_exponent_begin;
            multiplier_gain_exponent_end    <= reg_multiplier_gain_exponent_end;           
            multiplier_gain_mult            <= reg_multiplier_gain_mult;
        end if;

        multiplier_data_in              <= mux_out;
        multiplier_data_in_en           <= mux_out_en;

	end if;
end process;

gain_mult_inst: entity work.gain_mult 
	port map
	(
		clk		            => clk_main,
		rst		            => rst_main,
        data_in             => multiplier_data_in,
        data_in_en          => multiplier_data_in_en,
        gain_exponent_begin => multiplier_gain_exponent_begin,
        gain_exponent_end   => multiplier_gain_exponent_end,
        gain_mult           => multiplier_gain_mult,
        data_out            => multiplier_data_out,
        data_out_en         => multiplier_data_out_en
	);

--------------------------------------------------------
--i2s master
--------------------------------------------------------
    
i2s_master_tx_inst : entity work.i2s_master_tx
generic map(
    clk_MCLK_factor         => 15,           --:      5;          mclk: 300 ns          3.333 MHz
    clk_LRCLK_factor        => 30*(24+24),  --:      30*(24+24); lrclk: 28800 ns        34.72 KHz
    clk_SCLK_factor         => 30,          --:      30;         sclk: 600 ns           6.333 MHz
    nb_bits                 => 24           --:      24         
)
port map
    (
    clk             => clk_main,
    rst             => rst_main,
    data_in_left    => data_in_left,
    data_in_right   => data_in_right,
    data_in_en      => data_in_en,
    mclk_out        => mclk_out,
    lrclk_out       => lrclk_out,
    sclk_out        => sclk_out,
    sd_out          => sd_out,
    req_data        => req_data
);

--data_in_left(23 downto 0)       <= x"00" & enc_data_out(15 downto 0);
--data_in_right(23 downto 0)      <= x"00" & enc_data_out(15 downto 0);
--data_in_en <= enc_data_out_en;


data_in_left(23 downto 0)       <= multiplier_data_out(23 downto 0);
data_in_right(23 downto 0)      <= multiplier_data_out(23 downto 0);
data_in_en                      <= multiplier_data_out_en;

--------------------------------------------------------
--Outputs
--------------------------------------------------------   

LEDG <= nco_clock & nco_clock & nco_clock & nco_clock & nco_clock & nco_clock_top & nco_clock_top & nco_clock_top & nco_clock_top & nco_clock_top;

GPIO0_D_31 <= nco_clock;
GPIO0_D_30 <= nco_clock;
GPIO0_D_29 <= nco_clock;
GPIO0_D_28 <= nco_clock;
GPIO0_D_27 <= nco_clock;
GPIO0_D_26 <= nco_clock;
GPIO0_D_25 <= nco_clock;
GPIO0_D_24 <= nco_clock;
GPIO0_D_23 <= nco_clock;
GPIO0_D_22 <= nco_clock;
GPIO0_D_21 <= nco_clock;
GPIO0_D_20 <= nco_clock;
GPIO0_D_19 <= nco_clock;
GPIO0_D_18 <= nco_clock;
GPIO0_D_17 <= nco_clock;
GPIO0_D_16 <= nco_clock;
GPIO0_D_15 <= nco_clock;
GPIO0_D_14 <= nco_clock;
GPIO0_D_13 <= nco_clock;
GPIO0_D_12 <= nco_clock;
GPIO0_D_11 <= nco_clock;
GPIO0_D_10 <= nco_clock;
GPIO0_D_9  <= nco_clock;
GPIO0_D_8  <= nco_clock;
GPIO0_D_7  <= nco_clock;
GPIO0_D_6  <= nco_clock;

GPIO0_D_5  <= sd_out;
GPIO0_D_4  <= '0';
GPIO0_D_3  <= sclk_out;
GPIO0_D_2  <= '0';
GPIO0_D_1  <= lrclk_out;
GPIO0_D_0  <= mclk_out;

--------------------------------------------------------
--Debug
-------------------------------------------------------- 
gen_probe32: 
for I in 0 to 7 generate
    probe32_X_inst:  probe32
        port map
        (
            probe		=> probe(I),
            source		=> source(I)
        );

end generate gen_probe32;

probe_pr : process(clk_main, rst_main)
begin
    if rising_edge(clk_main) then

            --Update phase_accu_incr from a probe
            --Update mux_sel from a probe
            --Update multiplier_gain_exponent_begin from a probe
            --Update multiplier_gain_exponent_end from a probe
            --Update multiplier_gain_mult from a probe

            reg_phase_accu_incr                 <= std_logic_vector(source(1));    
            reg_mux_sel                         <= source(2)(3 downto 0);    
            reg_multiplier_gain_exponent_begin  <= source(3)(3 downto 0);    
            reg_multiplier_gain_exponent_end    <= source(4)(3 downto 0);    
            reg_multiplier_gain_mult            <= source(5)(17 downto 0);    


        
            probe(0) <= x"00000000"; 
            probe(1) <= x"00000001"; 
            probe(2) <= x"00000002"; 
            probe(3) <= x"00000003"; 
            probe(4) <= x"00000004"; 
            probe(5) <= x"00000005"; 
            probe(6) <= x"00000006"; 
            probe(7) <= x"00000007"; 

    end if;
end process;


end rtl;