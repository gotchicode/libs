
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity speed_counter_tb is
    generic (runner_cfg : string := runner_cfg_default);
end speed_counter_tb;

architecture rtl of speed_counter_tb is

constant clock_from_const       : time := 2.22 ns;
constant arst_clock_from_const  : time := 123 ns;
constant clock_to_const         : time := 4 ns;
constant arst_clock_to_const    : time := 123 ns;

constant use_async_reset    :  boolean:=true;
constant use_sync_reset     :  boolean:=true;
constant async_reset_active :  std_logic:='0';
constant sync_reset_active  :  std_logic:='0';

signal clock_from           : std_logic;
signal arst_clock_from      : std_logic;
signal srst_clock_from      : std_logic;
signal clock_to             : std_logic;
signal arst_clock_to        : std_logic;
signal srst_clock_to        : std_logic;
signal counter_a            : std_logic_vector(15 downto 0);
signal counter_b            : std_logic_vector(15 downto 0);



begin

    -----------------------------------------
    -- clock_from generation
    -----------------------------------------
    clock_from_gen_pr: process
    begin
        clock_from <= '1';
        wait for clock_from_const;

        clock_from <= '0';
        wait for clock_from_const;
    end process;
    
    -----------------------------------------
    -- clock_to generation
    -----------------------------------------
    clock_to_gen_pr: process
    begin
        clock_to <= '1';
        wait for clock_to_const;

        clock_to <= '0';
        wait for clock_to_const;
    end process;


    -----------------------------------------
    -- arst_clock_from generation
    -----------------------------------------
    arst_clock_from_gen_pr:process
    begin

        arst_clock_from <= '1';
        wait for 1 us;

        arst_clock_from <= '0';
        wait for arst_clock_from_const;

        arst_clock_from <= '1';
        wait;

    end process;
    
    -----------------------------------------
    -- arst_clock_to generation
    -----------------------------------------
    arst_clock_to_gen_pr:process
    begin

        arst_clock_to <= '1';
        wait for 1 us;

        arst_clock_to <= '0';
        wait for arst_clock_to_const;

        arst_clock_to <= '1';
        wait;

    end process;
    
    -----------------------------------------
    -- Sync resets
    -----------------------------------------
    srst_clock_from     <= '1';
    srst_clock_to       <= '1';


    speed_counter_inst : entity work.speed_counter
    generic map(
        use_async_reset    => use_async_reset,
        use_sync_reset     => use_sync_reset,
        async_reset_active => async_reset_active,
        sync_reset_active  => sync_reset_active
    )
    port map
        (
        clock_from      => clock_from,
        arst_clock_from => arst_clock_from,
        srst_clock_from => srst_clock_from,
        clock_to        => clock_to,
        arst_clock_to   => arst_clock_to,
        srst_clock_to   => srst_clock_to,
        counter_a       => counter_a,
        counter_b       => counter_b
);


test_runner : process
begin
  test_runner_setup(runner, runner_cfg);
   if run("Main_test") then
    wait until rising_edge(arst_clock_to);
    wait for 1 ms;
    check_equal(counter_a, 36371);
    check_equal(counter_b, 3);
   end if;
  test_runner_cleanup(runner);
end process;


end rtl;
