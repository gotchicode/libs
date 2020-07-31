
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

--clock data generation signals
signal clock_data_block_conf_freq_in         : std_logic_vector(31 downto 0);
signal clock_data_block_clock_out            : std_logic;
signal clock_data_block_clock_phase_out      : std_logic_vector(31 downto 0);
signal clock_data_block_pulse_out            : std_logic;
signal clock_data_block_pulse_phase_out      : std_logic_vector(31 downto 0);

--data generation signals
signal data_block_enc_data_in      : std_logic_vector(0 downto 0);
signal data_block_enc_data_in_en   : std_logic;
signal data_block_enc_data_out     : std_logic_vector(0 downto 0);
signal data_block_enc_data_out_en  : std_logic;

--clock polyphase generation signals
signal clock_polyphase_in_block_conf_freq_in         : std_logic_vector(31 downto 0);
signal clock_polyphase_in_block_clock_out            : std_logic;
signal clock_polyphase_in_block_clock_phase_out      : std_logic_vector(31 downto 0);
signal clock_polyphase_in_block_pulse_out            : std_logic;
signal clock_polyphase_in_block_pulse_phase_out      : std_logic_vector(31 downto 0);

--clock polyphase generation signals
signal clock_polyphase_out_block_conf_freq_in         : std_logic_vector(31 downto 0);
signal clock_polyphase_out_block_clock_out            : std_logic;
signal clock_polyphase_out_block_clock_phase_out      : std_logic_vector(31 downto 0);
signal clock_polyphase_out_block_pulse_out            : std_logic;
signal clock_polyphase_out_block_pulse_phase_out      : std_logic_vector(31 downto 0);

--polyphase signals
signal polyphase_block_data_in          : std_logic_vector(15 downto 0);
signal polyphase_block_data_in_en       : std_logic;
signal polyphase_block_data_in_phase    : std_logic_vector(31 downto 0);
signal polyphase_block_data_out         : std_logic_vector(15 downto 0);
signal polyphase_block_data_out_en      : std_logic;
signal polyphase_block_resampling_clock : std_logic;


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

    -----------------------------------------
    -- Data clock generation
    -----------------------------------------
    clock_data_block_inst : entity work.clock_generator
    port map
        (
        clk             => clk,
        rst             => rst,
        conf_freq_in    => clock_data_block_conf_freq_in,
        clock_out       => clock_data_block_clock_out,
        clock_phase_out => clock_data_block_clock_phase_out,
        pulse_out       => clock_data_block_pulse_out,
        pulse_phase_out => clock_data_block_pulse_phase_out
    );
    
    --Control data generation symbol frequency
    clock_data_block_conf_freq_in <= std_logic_vector(to_unsigned(integer(real(real(390625)*real(4294967296.0)/real(100000000))),32));
    
    -----------------------------------------
    -- Data generation
    -----------------------------------------
    data_block_inst : entity work.pn_enc_dec
    generic map(
        bit_size =>1
        )
    port map
        (
        clk             => clk,
        rst_n           => rst_n,
        enc_data_in     => data_block_enc_data_in,
        enc_data_in_en  => data_block_enc_data_in_en,
        enc_data_out    => data_block_enc_data_out,
        enc_data_out_en => data_block_enc_data_out_en,
        dec_data_in     => data_block_enc_data_out,
        dec_data_in_en  => data_block_enc_data_out_en,
        dec_data_out    => open,
        dec_data_out_en => open
);

    --Inputs
    data_block_enc_data_in      <= "1";
    data_block_enc_data_in_en   <= clock_data_block_pulse_out;

    -----------------------------------------
    -- Polyphase interpolation block
    -----------------------------------------
    poly_phase_block_inst : entity work.polyphase_interp
    generic map
    (
        phase_mode => 0
    )
    port map
        (
        clk                 => clk,
        rst                 => rst,
        data_in             => polyphase_block_data_in,
        data_in_en          => polyphase_block_data_in_en,
        data_in_phase       => polyphase_block_data_in_phase,
        data_out            => polyphase_block_data_out,
        data_out_en         => polyphase_block_data_out_en,
        resampling_clock    => polyphase_block_resampling_clock
    );

    --Inputs
    polyphase_block_data_in             <= std_logic_vector(to_signed(1024,16)) when data_block_enc_data_out="1" else std_logic_vector(to_signed(-1024,16));
    polyphase_block_data_in_en          <= clock_polyphase_in_block_pulse_out; --from clock generator below
    polyphase_block_data_in_phase       <= clock_polyphase_in_block_clock_phase_out; --from clock generator below
    polyphase_block_resampling_clock    <= clock_polyphase_out_block_pulse_out;
    -----------------------------------------
    -- Polyphase input clock generator
    -----------------------------------------
    clock_polyphase_in_block_inst : entity work.clock_generator
    port map
        (
        clk             => clk,
        rst             => rst,
        conf_freq_in    => clock_polyphase_in_block_conf_freq_in,
        clock_out       => clock_polyphase_in_block_clock_out,
        clock_phase_out => clock_polyphase_in_block_clock_phase_out,
        pulse_out       => clock_polyphase_in_block_pulse_out,
        pulse_phase_out => clock_polyphase_in_block_pulse_phase_out
    );
    
    --Control input generation symbol frequency (Symbol rate x4)
    clock_polyphase_in_block_conf_freq_in <= clock_data_block_conf_freq_in(29 downto 0) & "00";
    
    -----------------------------------------
    -- Polyphase output clock generator
    -----------------------------------------
    clock_polyphase_out_block_inst : entity work.clock_generator
    port map
        (
        clk             => clk,
        rst             => rst,
        conf_freq_in    => clock_polyphase_out_block_conf_freq_in,
        clock_out       => clock_polyphase_out_block_clock_out,
        clock_phase_out => clock_polyphase_out_block_clock_phase_out,
        pulse_out       => clock_polyphase_out_block_pulse_out,
        pulse_phase_out => clock_polyphase_out_block_pulse_phase_out
    );
    
    --Control output generation fixed at 25Msps
    clock_polyphase_out_block_conf_freq_in <= std_logic_vector(to_unsigned(integer(real(real(25000000)*real(4294967296.0)/real(100000000))),32));
    
end rtl;
