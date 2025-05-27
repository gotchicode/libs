
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity fsm_forest_tb is
    generic (runner_cfg : string := runner_cfg_default);
end fsm_forest_tb;

architecture rtl of fsm_forest_tb is

constant USE_ASYNC_RESET    :  boolean:=TRUE;
constant USE_SYNC_RESET     :  boolean:=TRUE;
constant ASYNC_RESET_ACTIVE :  std_logic:='1';
constant SYNC_RESET_ACTIVE  :  std_logic:='1';
constant REG_WIDTH          :  integer:=16;
constant DEPTH              :  integer:=2; --min=REG_WIDTH
constant COUNTER_SIZE       :  integer:=16; --min=REG_WIDTH

constant clock_const        : time := 5 ns;
constant reset_const        : time := 123 ns;

signal clock                : std_logic;
signal async_reset          : std_logic;
signal sync_reset           : std_logic;
signal reg_in               : std_logic_vector(reg_width-1 downto 0);
signal reg_out              : std_logic_vector(reg_width-1 downto 0);

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
    -- clock generation
    -----------------------------------------
    reset_gen_pr:process
    begin

        async_reset <= '0';
        wait for 1 us;

        async_reset <= '1';
        wait for reset_const;

        async_reset <= '0';
        wait;

    end process;


    fsm_forest_inst : entity work.fsm_forest
    generic map(
        USE_ASYNC_RESET    => USE_ASYNC_RESET,
        USE_SYNC_RESET     => USE_SYNC_RESET,
        ASYNC_RESET_ACTIVE => ASYNC_RESET_ACTIVE,
        SYNC_RESET_ACTIVE  => SYNC_RESET_ACTIVE,
        REG_WIDTH          => REG_WIDTH,
        DEPTH              => DEPTH,
        COUNTER_SIZE       => COUNTER_SIZE      
    )
    port map
        (
        clock           => clock,
        async_reset     => async_reset,
        sync_reset      => sync_reset,
        reg_in          => reg_in,
        reg_out         => reg_out
);


test_runner : process
begin
    test_runner_setup(runner, runner_cfg);
        if run("test_001_full") then
        
            reg_in <= std_logic_vector(to_unsigned(10,REG_WIDTH));
            
            wait for 10 ms;

        end if;
    --check_equal(to_string(17), "17");
    test_runner_cleanup(runner);
end process;


end rtl;
