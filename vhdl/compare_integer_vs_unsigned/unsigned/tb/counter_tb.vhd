
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity counter_tb is
    generic (runner_cfg : string := runner_cfg_default);
end counter_tb;

architecture rtl of counter_tb is

constant clk_const : time := 5 ns;

signal clk : std_logic;
signal enable : std_logic;
signal reset : std_logic;
signal flag : std_logic;



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




    counter_inst : entity work.counter
    port map
        (
        clk => clk,
        enable => enable,
        reset => reset,
        flag => flag
);


test_runner : process
begin
    test_runner_setup(runner, runner_cfg);
        if run("Main_test") then
        
            reset <= '0';
            enable <= '0';
        
            wait for 100 ns;
        
            for I in 0 to 2000000 loop
            
                wait until rising_edge(clk);
                wait until rising_edge(clk);
                wait until rising_edge(clk);
                wait until rising_edge(clk);
                wait until rising_edge(clk);
                enable <= '1';
                wait until rising_edge(clk);
                enable <= '0';
                
            end loop;
        
        end if;
   
        check_equal(flag, '1');
   --check_equal(17, 19);
   --end if;
  --check_equal(to_string(17), "17");
    test_runner_cleanup(runner);
end process;


end rtl;

-- Simulation time
--Questa Intel Starter FPGA Edition-64
--Version 2021.2 win64 Apr 14 2021
-- Windows 10
-- 11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz   2.80 GHz
-- 141.5 seconds