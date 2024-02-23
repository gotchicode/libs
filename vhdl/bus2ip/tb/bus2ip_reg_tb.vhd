
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity bus2ip_reg_tb is
    generic (runner_cfg : string := runner_cfg_default);
end bus2ip_reg_tb;

architecture rtl of bus2ip_reg_tb is

constant clock_const : time := 5 ns;
constant async_reset_const : time := 123 ns;

signal clock : std_logic;
signal async_reset : std_logic;
signal sync_reset : std_logic;
signal bus2ip_cs_slave : std_logic;
signal bus2ip_addr_slave : std_logic_vector(31 downto 0);
signal bus2ip_wrce_slave : std_logic;
signal bus2ip_rdce_slave : std_logic;
signal bus2ip_data_slave : std_logic_vector(31 downto 0);
signal ip2bus_wrack_slave : std_logic;
signal ip2bus_rdack_slave : std_logic;
signal ip2bus_data_slave : std_logic_vector(31 downto 0);
signal ip2bus_error_slave : std_logic;
signal ip2bus_cs_master : std_logic;
signal ip2bus_addr_master : std_logic_vector(31 downto 0);
signal ip2bus_wrce_master : std_logic;
signal ip2bus_rdce_master : std_logic;
signal ip2bus_data_master : std_logic_vector(31 downto 0);
signal bus2ip_wrack_master : std_logic;
signal bus2ip_rdack_master : std_logic;
signal bus2ip_data_master : std_logic_vector(31 downto 0);
signal bus2ip_error_master : std_logic;



begin

    -----------------------------------------
    -- clock generation
    -----------------------------------------
    clock_gen_pr: process
    begin
        clock <= '1';
        wait for clock_const;

        clock <= '0';
        wait for clock_const;
    end process;


    -----------------------------------------
    -- async_reset generation
    -----------------------------------------
    async_reset_gen_pr:process
    begin

        async_reset <= '0';
        wait for 1 us;

        async_reset <= '1';
        wait for async_reset_const;

        async_reset <= '0';
        wait;

    end process;


    bus2ip_reg_inst : entity work.bus2ip_reg
    generic map(
    USE_ASYNC_RESET    => TRUE,
    USE_SYNC_RESET     => TRUE,
    ASYNC_RESET_ACTIVE => '1',
    SYNC_RESET_ACTIVE  => '1'
    )
    port map
        (
        clock => clock,
        async_reset => async_reset,
        sync_reset => sync_reset,
        bus2ip_cs_slave => bus2ip_cs_slave,
        bus2ip_addr_slave => bus2ip_addr_slave,
        bus2ip_wrce_slave => bus2ip_wrce_slave,
        bus2ip_rdce_slave => bus2ip_rdce_slave,
        bus2ip_data_slave => bus2ip_data_slave,
        ip2bus_wrack_slave => ip2bus_wrack_slave,
        ip2bus_rdack_slave => ip2bus_rdack_slave,
        ip2bus_data_slave => ip2bus_data_slave,
        ip2bus_error_slave => ip2bus_error_slave,
        ip2bus_cs_master => ip2bus_cs_master,
        ip2bus_addr_master => ip2bus_addr_master,
        ip2bus_wrce_master => ip2bus_wrce_master,
        ip2bus_rdce_master => ip2bus_rdce_master,
        ip2bus_data_master => ip2bus_data_master,
        bus2ip_wrack_master => bus2ip_wrack_master,
        bus2ip_rdack_master => bus2ip_rdack_master,
        bus2ip_data_master => bus2ip_data_master,
        bus2ip_error_master => bus2ip_error_master
);

 

------------------------------------------------------
-- test runner process
------------------------------------------------------
test_runner : process


begin
  test_runner_setup(runner, runner_cfg);
  
    if run("test_reset_only") then
        sync_reset <= '0';
        wait until falling_edge(async_reset);
        wait for 1 us;
        wait until rising_edge(clock);
        sync_reset <= '1';
        wait until rising_edge(clock);
        sync_reset <= '0';
        wait until rising_edge(clock);
        wait for 1 us;
        check_equal(18, 18);
    end if;
    
    if run("test_write") then
    
        sync_reset <= '0';
        bus2ip_error_master <= '0';
        wait until falling_edge(async_reset);
        wait for 1 us;
        wait until rising_edge(clock);
        
        --------------------------------------
        -- Write
        --------------------------------------
        bus2ip_addr_slave   <= x"00000001";
        bus2ip_data_slave   <= x"12345678";
        bus2ip_wrce_slave   <= '1';
        bus2ip_cs_slave     <= '1';
        wait until rising_edge(clock);
        
        wait until rising_edge(ip2bus_wrce_master);
        wait until rising_edge(clock);
        bus2ip_wrack_master <='1';
        wait until rising_edge(clock);
        bus2ip_wrack_master <='0';
        
        wait until rising_edge(ip2bus_wrack_slave);
        wait until rising_edge(clock);
        bus2ip_wrce_slave   <= '0';
        bus2ip_cs_slave     <= '0';

        wait for 1 us;
        
        check_equal(ip2bus_addr_master, std_logic_vector'(x"00000001"), "check ip2bus_addr_master failed");
        check_equal(ip2bus_data_master, std_logic_vector'(x"12345678"), "check ip2bus_data_master failed");
        
    end if;
    
    if run("test_read") then
    
        sync_reset <= '0';
        bus2ip_error_master <= '0';
        wait until falling_edge(async_reset);
        wait for 1 us;
        wait until rising_edge(clock);
        
        
        --------------------------------------
        -- Read
        --------------------------------------
        bus2ip_addr_slave   <= x"00000001";
        bus2ip_data_master  <= x"87654321";
        bus2ip_rdce_slave   <= '1';
        bus2ip_cs_slave     <= '1';
        wait until rising_edge(clock);
        
        wait until rising_edge(ip2bus_rdce_master);
        wait until rising_edge(clock);
        bus2ip_rdack_master <='1';
        wait until rising_edge(clock);
        bus2ip_rdack_master <='0';
        
        wait until rising_edge(ip2bus_rdack_slave);
        wait until rising_edge(clock);
        bus2ip_rdce_slave   <= '0';
        bus2ip_cs_slave     <= '0';
        
        wait for 1 us;
        check_equal(ip2bus_addr_master, std_logic_vector'(x"00000001"), "check ip2bus_addr_master failed");
        check_equal(ip2bus_data_slave, std_logic_vector'(x"87654321"), "check ip2bus_data_master failed");
        
    end if;
    
    
    if run("test_both") then
    
        sync_reset <= '0';
        bus2ip_error_master <= '0';
        wait until falling_edge(async_reset);
        wait for 1 us;
        wait until rising_edge(clock);
        
        --------------------------------------
        -- Write
        --------------------------------------
        bus2ip_addr_slave   <= x"00000001";
        bus2ip_data_slave   <= x"12345678";
        bus2ip_wrce_slave   <= '1';
        bus2ip_cs_slave     <= '1';
        wait until rising_edge(clock);
        
        wait until rising_edge(ip2bus_wrce_master);
        wait until rising_edge(clock);
        bus2ip_wrack_master <='1';
        wait until rising_edge(clock);
        bus2ip_wrack_master <='0';
        
        wait until rising_edge(ip2bus_wrack_slave);
        wait until rising_edge(clock);
        bus2ip_wrce_slave   <= '0';
        bus2ip_cs_slave     <= '0';

        wait for 1 us;
        
        check_equal(ip2bus_addr_master, std_logic_vector'(x"00000001"), "check ip2bus_addr_master failed");
        check_equal(ip2bus_data_master, std_logic_vector'(x"12345678"), "check ip2bus_data_master failed");
        
        --------------------------------------
        -- Read
        --------------------------------------
        bus2ip_addr_slave   <= x"00000001";
        bus2ip_data_master  <= x"87654321";
        bus2ip_rdce_slave   <= '1';
        bus2ip_cs_slave     <= '1';
        wait until rising_edge(clock);
        
        wait until rising_edge(ip2bus_rdce_master);
        wait until rising_edge(clock);
        bus2ip_rdack_master <='1';
        wait until rising_edge(clock);
        bus2ip_rdack_master <='0';
        
        wait until rising_edge(ip2bus_rdack_slave);
        wait until rising_edge(clock);
        bus2ip_rdce_slave   <= '0';
        bus2ip_cs_slave     <= '0';
        
        wait for 1 us;
        check_equal(ip2bus_addr_master, std_logic_vector'(x"00000001"), "check ip2bus_addr_master failed");
        check_equal(ip2bus_data_slave, std_logic_vector'(x"87654321"), "check ip2bus_data_master failed");
        
        
    
    end if;
    
    if run("test_cancel") then
    
        sync_reset <= '0';
        bus2ip_error_master <= '0';
        wait until falling_edge(async_reset);
        wait for 1 us;
        wait until rising_edge(clock);
        
        --------------------------------------
        -- CANCEL Write
        --------------------------------------
        bus2ip_addr_slave   <= x"00000001";
        bus2ip_data_slave   <= x"12345678";
        bus2ip_wrce_slave   <= '1';
        bus2ip_cs_slave     <= '1';
        wait until rising_edge(clock);
        
        bus2ip_wrce_slave   <= '0';
        wait until rising_edge(clock);
        
        wait for 1 us;
        check_equal(ip2bus_addr_master, std_logic_vector'(x"00000000"), "check ip2bus_addr_master failed");
        check_equal(ip2bus_wrce_master, std_logic'('0'), "check ip2bus_wrce_master failed");
        
        wait for 1us;
        wait until rising_edge(clock);
        
        --------------------------------------
        -- CANCEL Read
        --------------------------------------
        bus2ip_addr_slave   <= x"00000002";
        bus2ip_rdce_slave   <= '1';
        bus2ip_cs_slave     <= '1';
        wait until rising_edge(clock);
        
        bus2ip_rdce_slave   <= '0';
        wait until rising_edge(clock);
        
        wait for 1 us;
        check_equal(ip2bus_addr_master, std_logic_vector'(x"00000000"), "check ip2bus_addr_master failed");
        check_equal(ip2bus_rdce_master, std_logic'('0'), "check ip2bus_rdce_master failed");
        
        
    end if;
    
    test_runner_cleanup(runner);
    
end process;


end rtl;
