
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de0_top_tb is
end de0_top_tb;

architecture rtl of de0_top_tb is

constant clock_50_const : time := 10 ns;

-- board
signal clock_50 : std_logic;
signal clock_50_2 : std_logic;
signal button : std_logic_vector(2 downto 0);
signal sw : std_logic_vector(9 downto 0);
signal ledg : std_logic_vector(9 downto 0);

--mic emulate
signal mic_emulate_rst              : std_logic;
signal mic_emulate_data_in_left     : std_logic_vector(16-1 downto 0):=(others=>'0');
signal mic_emulate_data_in_right    : std_logic_vector(16-1 downto 0):=(others=>'0');
signal mic_emulate_data_in_en       : std_logic:='0';
signal mic_emulate_mclk_out         : std_logic;
signal mic_emulate_lrclk_out        : std_logic;
signal mic_emulate_sclk_out         : std_logic;
signal mic_emulate_sd_out           : std_logic;
signal mic_emulate_req_data         : std_logic;



begin

    -----------------------------------------
    -- clock_50 generation
    -----------------------------------------
    clock_50_gen_pr: process
    begin
        clock_50 <= '1';
        wait for clock_50_const;

        clock_50 <= '0';
        wait for clock_50_const;
    end process;
    
    button  <= (others=>'0');
    sw      <= (others=>'0');

    de0_top_inst : entity work.de0_top
    generic map(
        simu => 1
    )
    port map
        (
        clock_50 => clock_50,
        clock_50_2 => clock_50_2,
        button => button,
        sw => sw,
        GPIO0_D_14 => mic_emulate_sd_out,
        ledg => ledg
);

    -----------------------------------------
    -- emulate i2s transfer to the board
    -----------------------------------------
    i2s_emulate_tx_inst : entity work.i2s_master_tx
    generic map(
        clk_MCLK_factor         => 15,          --:      5;          mclk: 300 ns          3.333 MHz
        clk_LRCLK_factor        => 30*(24+24),  --:      30*(24+24); lrclk: 28800 ns        34.72 KHz
        clk_SCLK_factor         => 30,          --:      30;         sclk: 600 ns           6.333 MHz
        nb_bits                 => 16           --:      24         
    )
    port map
        (
        clk             => clock_50,
        rst             => mic_emulate_rst,
        data_in_left    => mic_emulate_data_in_left,
        data_in_right   => mic_emulate_data_in_right,
        data_in_en      => mic_emulate_data_in_en,
        mclk_out        => mic_emulate_mclk_out,
        lrclk_out       => mic_emulate_lrclk_out,
        sclk_out        => mic_emulate_sclk_out,
        sd_out          => mic_emulate_sd_out,
        req_data        => mic_emulate_req_data
    );
    

    mic_emulate_rst_gen: process
    begin
        mic_emulate_rst <= '0';
        wait for 123 ns;

        mic_emulate_rst <= '1';
        wait for 123 ns;
        
        mic_emulate_rst <= '0';
        wait for 123 ns;
        
        wait;

    end process;
    
    mic_emulate_data_gen: process
    begin

        wait until rising_edge(mic_emulate_req_data);
        wait until rising_edge(clock_50);
        mic_emulate_data_in_left        <= std_logic_vector(unsigned(mic_emulate_data_in_left)+1);
        mic_emulate_data_in_right       <= std_logic_vector(unsigned(mic_emulate_data_in_right)+1);
        mic_emulate_data_in_en          <= '1';
        wait until rising_edge(clock_50);
        mic_emulate_data_in_en          <= '0';
  

    end process;
    
    

end rtl;
