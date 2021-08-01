
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;

entity gmsk_filter_tb is
end gmsk_filter_tb;

architecture rtl of gmsk_filter_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

-- gmsk filter signals
signal clk : std_logic;
signal rst : std_logic;
signal symbol_in : std_logic_vector(11 downto 0);
signal symbol_in_en : std_logic;
signal sample_in_en : std_logic;
signal sample_instant_in : std_logic_vector(31 downto 0);
signal rf_on_off_in : std_logic;
signal modu_on_off_in : std_logic;
signal power_level_in : std_logic_vector(15 downto 0);
signal phase_in : std_logic_vector(31 downto 0);
signal interp_factor : std_logic_vector(15 downto 0);
signal taps_max_index : std_logic_vector(15 downto 0);
signal cnt1_init : std_logic_vector(11 downto 0);
signal cnt2_init : std_logic_vector(11 downto 0);
signal cnt3_init : std_logic_vector(11 downto 0);
signal cnt4_init : std_logic_vector(11 downto 0);
signal cnt5_init : std_logic_vector(11 downto 0);
signal taps_ram_add_write : std_logic_vector(12-1 downto 0);
signal taps_ram_data_write : std_logic_vector(16-1 downto 0);
signal taps_ram_wr_en : std_logic;
signal taps_ram_add_read : std_logic_vector(12-1 downto 0);
signal taps_ram_rd_en : std_logic;
signal taps_ram_data_read : std_logic_vector(16-1 downto 0);
signal symbol_out_en : std_logic;
signal sample_out : std_logic_vector(11 downto 0);
signal sample_out_en : std_logic;
signal sample_instant_out : std_logic_vector(31 downto 0);
signal rf_on_off_out : std_logic;
signal modu_on_off_out : std_logic;
signal power_level_out : std_logic_vector(15 downto 0);
signal phase_out : std_logic_vector(31 downto 0);

-- gmsk taps build
signal rst_done                         : std_logic;
type taps_buffer_type                   is array (0 to 4096-1) of std_logic_vector(16-1 downto 0);                
signal taps_buffer                      : taps_buffer_type;  
signal gain_from_file                   : std_logic_vector(15 downto 0);
signal nb_taps_from_file                : std_logic_vector(15 downto 0);
signal interp_factor_from_file          : std_logic_vector(15 downto 0);


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
    
        rst_done <= '0';

        rst <= '0';
        wait for 1 us;

        rst <= '1';
        wait for rst_const;

        rst <= '0'; 
        rst_done <= '1';
        wait;
        


    end process;
    
    -----------------------------------------
    -- Configuration parameters
    -----------------------------------------
    
    --interpolation factor
    interp_factor <= std_logic_vector(to_unsigned(8,16));
    
    --max number of samples
    taps_max_index <= std_logic_vector(to_unsigned(8*4,16));
    
    cnt1_init <= std_logic_vector(to_unsigned(8*0,12));
    cnt2_init <= std_logic_vector(to_unsigned(8*1,12));    
    cnt3_init <= std_logic_vector(to_unsigned(8*2,12));    
    cnt4_init <= std_logic_vector(to_unsigned(8*3,12));    
    cnt5_init <= std_logic_vector(to_unsigned(8*4,12));    

    
    -----------------------------------------
    -- Flow generation
    -----------------------------------------
    flow_generation_pr: process(clk, rst)
    variable v_incr         : unsigned(31 downto 0);
    variable v_nco_reg      : unsigned(31 downto 0);
    variable v_nco_reg_d1   : unsigned(31 downto 0);
    variable v_sample_counter : unsigned(15 downto 0);
    begin
        if rst='1' then
        
            v_incr              := to_unsigned(integer(real(real(1_000_000)*real(4294967296.0)/real(100000000))),32);
            v_nco_reg           := (others=>'0');
            v_nco_reg_d1        := (others=>'0');
            v_sample_counter    := (others=>'0');
            
        elsif rising_edge(clk) then
        
            --Symbol in
            if (not(v_nco_reg(31)) and v_nco_reg_d1(31))='1' then
                if v_sample_counter=unsigned(interp_factor)-1 then
                    v_sample_counter := (others=>'0');
                    symbol_in_en <= '1';
                else
                    v_sample_counter := v_sample_counter+1;
                    symbol_in_en <= '0';
                end if;
            else
                symbol_in_en <= '0';
            end if;
        
            -- Sample in generation
            sample_in_en        <= not(v_nco_reg(31)) and v_nco_reg_d1(31);
            sample_instant_in   <= std_logic_vector(v_nco_reg);

            -- NCO for sample rate generation
            v_nco_reg_d1        := v_nco_reg;
            v_nco_reg           := v_nco_reg + v_incr;
            
        end if;
    end process;
    
    -----------------------------------------
    -- Load taps from a text file
    -----------------------------------------
    program_gmsk_taps_pr : process(clk, rst)
    file read_vector     : text open read_mode is "taps.txt";
    variable v_row       : line;
    variable v_read      : integer;
    variable v_read_cnt  : integer;

    begin
        if rst='1' then
        
            v_read_cnt :=0;
            
            gain_from_file          <= (others=>'0');
            nb_taps_from_file       <= (others=>'0');
            interp_factor_from_file <= (others=>'0');
            
            taps_ram_add_write      <= (others=>'0');
            taps_ram_data_write     <= (others=>'0');  
            taps_ram_wr_en          <= '0'; 

        elsif rising_edge(clk) then
        
            -- Only read the file after reset
            if rst_done='1' then
            
                
                if(not endfile(read_vector)) then
                
                    -- Read a line
                    readline(read_vector,v_row);
                    read(v_row,v_read);
                    v_read_cnt := v_read_cnt+1;
                    
                    -- Fill first params
                    case v_read_cnt is
                        when 1 => -- First line is the gain
                            gain_from_file <= std_logic_vector(to_unsigned(v_read,16));
                        when 2 => -- Second line is the number of taps
                            nb_taps_from_file <= std_logic_vector(to_unsigned(v_read,16));
                        when 3 => -- Third line is the interpolation ratio
                            interp_factor_from_file <= std_logic_vector(to_unsigned(v_read,16));
                        when others => --Here are the taps
                    end case;
                    
                    --Fill taps
                    if v_read_cnt>3 then
                        taps_ram_add_write      <= std_logic_vector(to_unsigned(v_read_cnt-4,12));
                        taps_ram_data_write     <= std_logic_vector(to_unsigned(v_read,16));
                        taps_ram_wr_en          <= '1';
                    else
                        taps_ram_wr_en          <= '0';
                    end if;
                else
                    taps_ram_wr_en          <= '0';
                end if;

            end if;

        end if;

    end process;
    


    gmsk_filter_inst : entity work.gmsk_filter
    port map
        (
        clk => clk,
        rst => rst,
        symbol_in => symbol_in,
        symbol_in_en => symbol_in_en,
        sample_in_en => sample_in_en,
        sample_instant_in => sample_instant_in,
        rf_on_off_in => rf_on_off_in,
        modu_on_off_in => modu_on_off_in,
        power_level_in => power_level_in,
        phase_in => phase_in,
        interp_factor => interp_factor,
        taps_max_index => taps_max_index,
        cnt1_init => cnt1_init,
        cnt2_init => cnt2_init,        
        cnt3_init => cnt3_init,        
        cnt4_init => cnt4_init,        
        cnt5_init => cnt5_init,        
        taps_ram_add_write => taps_ram_add_write,
        taps_ram_data_write => taps_ram_data_write,
        taps_ram_wr_en => taps_ram_wr_en,
        taps_ram_add_read => taps_ram_add_read,
        taps_ram_rd_en => taps_ram_rd_en,
        taps_ram_data_read => taps_ram_data_read,
        symbol_out_en => symbol_out_en,
        sample_out => sample_out,
        sample_out_en => sample_out_en,
        sample_instant_out => sample_instant_out,
        rf_on_off_out => rf_on_off_out,
        modu_on_off_out => modu_on_off_out,
        power_level_out => power_level_out,
        phase_out => phase_out
);

end rtl;
