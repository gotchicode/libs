
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity multiple_access_ram_memory_map_top_tb is
    generic (runner_cfg : string := runner_cfg_default);
end multiple_access_ram_memory_map_top_tb;

architecture rtl of multiple_access_ram_memory_map_top_tb is

constant clk_const : time := 5 ns;
     

constant number_of_cells    : integer:=7;
constant addr_width         : integer:=7;
constant data_width         : integer:=32;

signal clk                  : std_logic;
signal addr                 : std_logic_vector(addr_width-1 downto 0);
signal wr_en                : std_logic;
signal rd_en                : std_logic;
signal data_write           : std_logic_vector(data_width-1 downto 0);
signal data_read            : std_logic_vector(data_width-1 downto 0);


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




    multiple_access_ram_memory_map_top_inst : entity work.multiple_access_ram_memory_map_top
    generic map(
        number_of_cells => number_of_cells,
        addr_width      => addr_width,
        data_width      => data_width
    )
    port map
        (
        clk => clk,
        addr => addr,
        wr_en => wr_en,
        rd_en => rd_en,
        data_write => data_write,
        data_read => data_read
);


test_runner : process
begin
  test_runner_setup(runner, runner_cfg);
   if run("Module_Reset_001") then

        wait for 1 us;
        wait until rising_edge(clk);

        addr        <= std_logic_vector(to_unsigned(0,addr_width));
        data_write  <= x"01";
        wr_en       <= '1';
        wait until rising_edge(clk);
        wr_en       <= '0';


        addr        <= std_logic_vector(to_unsigned(0,addr_width));
        data_write  <= x"00";
        wr_en       <= '1';
        wait until rising_edge(clk);
        wr_en       <= '0';

        wait for 1 us;


        check_equal(to_string(17), "17");
        
    end if;

  test_runner_cleanup(runner);
end process;


end rtl;
