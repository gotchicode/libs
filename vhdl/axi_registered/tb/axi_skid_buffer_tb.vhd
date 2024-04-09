
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context work.vunit_context;
context work.com_context;
context work.data_types_context;
use work.axi_stream_pkg.all;
use work.stream_master_pkg.all;
use work.stream_slave_pkg.all;
use work.sync_pkg.all;

entity axi_skid_buffer_tb is
    generic (
        runner_cfg    : string;
        g_id_length   : natural := 8;
        g_dest_length : natural := 8;
        g_user_length : natural := 8;
        g_stall_percentage_master : natural range 0 to 100 := 0;
        g_stall_percentage_slave  : natural range 0 to 100 := 0
        );
end axi_skid_buffer_tb;

architecture rtl of axi_skid_buffer_tb is

constant min_stall_cycles : natural := 5;
constant max_stall_cycles : natural := 15;
constant master_stall_config : stall_config_t := new_stall_config(stall_probability => real(g_stall_percentage_master)/100.0, min_stall_cycles => min_stall_cycles, max_stall_cycles => max_stall_cycles);
constant slave_stall_config  : stall_config_t := new_stall_config(stall_probability => real(g_stall_percentage_slave)/100.0 , min_stall_cycles => min_stall_cycles, max_stall_cycles => max_stall_cycles);

constant master_axi_stream : axi_stream_master_t := new_axi_stream_master(
    data_length => 8, id_length => g_id_length, dest_length => g_dest_length, user_length => g_user_length,
    stall_config => master_stall_config, logger => get_logger("master"), actor => new_actor("master"),
    monitor => default_axi_stream_monitor, protocol_checker => default_axi_stream_protocol_checker
);
constant master_stream : stream_master_t := as_stream(master_axi_stream);
constant master_sync   : sync_handle_t   := as_sync(master_axi_stream);

constant slave_axi_stream : axi_stream_slave_t := new_axi_stream_slave(
    data_length => 8, id_length => g_id_length, dest_length => g_dest_length, user_length => g_user_length,
    stall_config => slave_stall_config, logger => get_logger("slave"), actor => new_actor("slave"),
    monitor => default_axi_stream_monitor, protocol_checker => default_axi_stream_protocol_checker
);
constant slave_stream : stream_slave_t := as_stream(slave_axi_stream);
constant slave_sync   : sync_handle_t  := as_sync(slave_axi_stream);

constant clk_const : time := 5 ns;

signal aclk                 : std_logic := '0';
signal areset_n             : std_logic := '0';

signal s_tdata              : std_logic_vector(7 downto 0);
signal s_tvalid             : std_logic;
signal s_tready             : std_logic;
signal m_tdata              : std_logic_vector(7 downto 0);
signal m_tvalid             : std_logic;
signal m_tready             : std_logic;

signal master_axis_tvalid   : std_logic;
signal master_axis_tready   : std_logic;
signal master_axis_tdata    : std_logic_vector(data_length(slave_axi_stream)-1 downto 0);
signal master_axis_tlast    : std_logic;
signal master_axis_tkeep    : std_logic_vector(data_length(slave_axi_stream)/8-1 downto 0);
signal master_axis_tstrb    : std_logic_vector(data_length(slave_axi_stream)/8-1 downto 0);
signal master_axis_tid      : std_logic_vector(id_length(slave_axi_stream)-1 downto 0);
signal master_axis_tdest    : std_logic_vector(dest_length(slave_axi_stream)-1 downto 0);
signal master_axis_tuser    : std_logic_vector(user_length(slave_axi_stream)-1 downto 0);

signal slave_axis_tvalid   : std_logic;
signal slave_axis_tready   : std_logic;
signal slave_axis_tdata    : std_logic_vector(data_length(slave_axi_stream)-1 downto 0);
signal slave_axis_tlast    : std_logic;
signal slave_axis_tkeep    : std_logic_vector(data_length(slave_axi_stream)/8-1 downto 0);
signal slave_axis_tstrb    : std_logic_vector(data_length(slave_axi_stream)/8-1 downto 0);
signal slave_axis_tid      : std_logic_vector(id_length(slave_axi_stream)-1 downto 0);
signal slave_axis_tdest    : std_logic_vector(dest_length(slave_axi_stream)-1 downto 0);
signal slave_axis_tuser    : std_logic_vector(user_length(slave_axi_stream)-1 downto 0);

signal rx_data             : std_logic_vector(7 downto 0);
signal rx_last_bool        : boolean;
begin

    -----------------------------------------
    -- clk generation
    -----------------------------------------
    clk_gen_pr: process
    begin

        aclk <= '1';
        wait for clk_const;

        aclk <= '0';
        wait for clk_const;

    end process;

    -----------------------------------------
    -- rst generation
    -----------------------------------------
    rst_gen_pr: process
    begin
        areset_n <= '0';
        wait for 1 us;
        areset_n <= '1';
        wait;
    end process;



    axi_skid_buffer_inst : entity work.axi_skid_buffer
    generic map(
      MODE => 1,
      DATA_WIDTH => 8
      )
    port map
        (
        clk => aclk,
        rst_n => areset_n,
        s_tvalid => s_tvalid,
        s_tdata => s_tdata,
        s_tready => s_tready,
        m_tvalid => m_tvalid,
        m_tdata => m_tdata,
        m_tready => m_tready
);

-- AXI master push signals
s_tvalid <= master_axis_tvalid;
master_axis_tready <= s_tready;
s_tdata <= master_axis_tdata;
-- unused xxxx <= master_axis_tlast;
-- unused xxxx <= master_axis_tkeep;
-- unused xxxx <= master_axis_tstrb;
-- unused xxxx <= master_axis_tid;
-- unused xxxx <= <= master_axis_tuser;
-- unused xxxx <= <= master_axis_tdest;

-- AXI slave pop signals
slave_axis_tvalid <= m_tvalid;
m_tready <= slave_axis_tready;
slave_axis_tdata <= m_tdata;
slave_axis_tlast <= '0';
slave_axis_tkeep <= "1";
slave_axis_tstrb <= "0";
slave_axis_tid <= x"00";
slave_axis_tuser <= x"FF";
slave_axis_tdest <= x"FF";


-----------------------------------------
-- Main process
-----------------------------------------

test_runner : process
variable data      : std_logic_vector(slave_axis_tdata'range);
variable last_bool : boolean;
begin
    test_runner_setup(runner, runner_cfg);
    if run("Main_test") then

        wait until rising_edge(areset_n);

        -- Push x1 Pop x1
        push_stream(net, master_stream, x"01", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        check_equal(data, std_logic_vector'(x"01"));
        wait for 50 ns;

        -- Push x3 Pop x1
        push_stream(net, master_stream, x"01", true);
        push_stream(net, master_stream, x"02", true);
        push_stream(net, master_stream, x"03", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        wait for 50 ns;

        -- Pop x2 the remaining
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        wait for 50 ns;

        -- Push x8 Pop x8
        push_stream(net, master_stream, x"01", true);
        push_stream(net, master_stream, x"02", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        push_stream(net, master_stream, x"03", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        push_stream(net, master_stream, x"04", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        push_stream(net, master_stream, x"05", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        push_stream(net, master_stream, x"06", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        push_stream(net, master_stream, x"07", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        push_stream(net, master_stream, x"08", true);
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;
        pop_stream(net, slave_stream, data, last_bool); rx_data <= data; rx_last_bool <= last_bool;

        wait for 1 us;

        --push_stream(net, slave_stream, data, '0','1','1',"00","00","00");

        wait for 1 us;

-- procedure push_axi_stream(
--     signal net : inout network_t;
--     axi_stream : axi_stream_master_t;
--     tdata      : std_logic_vector;
--     tlast      : std_logic        := '1';
--     tkeep      : std_logic_vector := "";
--     tstrb      : std_logic_vector := "";
--     tid        : std_logic_vector := "";
--     tdest      : std_logic_vector := "";
--     tuser      : std_logic_vector := ""
--   );



    end if;
    --check_equal(to_string(17), "17");
    test_runner_cleanup(runner);
end process;

-----------------------------------------
-- Master
-----------------------------------------
axi_stream_master_inst : entity work.axi_stream_master
generic map(
  master => master_axi_stream)
port map(
  aclk     => aclk,
  areset_n => areset_n,
  tvalid   => master_axis_tvalid,
  tready   => master_axis_tready,
  tdata    => master_axis_tdata,
  tlast    => master_axis_tlast,
  tkeep    => master_axis_tkeep,
  tstrb    => master_axis_tstrb,
  tid      => master_axis_tid,
  tuser    => master_axis_tuser,
  tdest    => master_axis_tdest
  );

-----------------------------------------
-- Slave
-----------------------------------------
axi_stream_slave_inst : entity work.axi_stream_slave
generic map(
  slave => slave_axi_stream)
port map(
  aclk     => aclk,
  areset_n => areset_n,
  tvalid   => slave_axis_tvalid,
  tready   => slave_axis_tready,
  tdata    => slave_axis_tdata,
  tlast    => slave_axis_tlast,
  tkeep    => slave_axis_tkeep,
  tstrb    => slave_axis_tstrb,
  tid      => slave_axis_tid,
  tuser    => slave_axis_tuser,
  tdest    => slave_axis_tdest);


end rtl;
