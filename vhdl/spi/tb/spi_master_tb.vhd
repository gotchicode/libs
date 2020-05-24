library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master_tb is
end spi_master_tb;

architecture rtl of spi_master_tb is

constant clk_const : time := 5 ns;
constant rst_const : time := 123 ns;

signal clk : std_logic;
signal rst : std_logic;
signal data_in : std_logic_vector(7 downto 0);
signal data_in_en : std_logic;
signal data_out : std_logic_vector(7 downto 0);
signal data_out_en : std_logic;
signal sclk : std_logic;
signal ce : std_logic;
signal mosi : std_logic;
signal miso : std_logic;
signal busy : std_logic;



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
 
    -----------------------------------------
    -- stim generation
    -----------------------------------------
    stim_gen_pr:process
    begin

        data_in    <= (others=>'0');
        data_in_en <= '0';
        wait for 500 us;
        wait until rising_edge(clk);

        for I in 0 to 512 loop
            wait until rising_edge(clk);
            data_in    <= std_logic_vector(unsigned(data_in)+1);
            data_in_en <= '1';
            wait until rising_edge(clk);
         
            data_in_en <= '0';
         
            wait for 500 us;
         
        end loop;

        wait;

    end process;
    
    -----------------------------------------
    -- Check data
    -----------------------------------------
    check_pr:process(clk, rst)
    begin
        if rst='1' then
        
        elsif rising_edge(clk) then

        end if;
    end process;


    spi_master_inst : entity work.spi_master
    port map
        (
        clk => clk,
        rst => rst,
        data_in => data_in,
        data_in_en => data_in_en,
        data_out => open,
        data_out_en => open,
        sclk => sclk,
        ce => ce,
        mosi => mosi,
        miso => miso,
        busy => busy
);

    spi_slave_inst : entity work.spi_slave
    port map
        (
        clk => clk,
        rst => rst,
        data_in => data_out,
        data_in_en => data_out_en,
        data_out => data_out,
        data_out_en => data_out_en,
        sclk => sclk,
        ce => ce,
        mosi => mosi,
        miso => miso,
        busy => open
);

end rtl;