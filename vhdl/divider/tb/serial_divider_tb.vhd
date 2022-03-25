
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library vunit_lib;
--context vunit_lib.vunit_context;

entity serial_divider_tb is
    --generic (runner_cfg : string := runner_cfg_default);
end serial_divider_tb;

architecture rtl of serial_divider_tb is

constant clk_const      : time := 5 ns;
constant rst_const      : time := 123 ns;
constant IN_WIDTH       : integer:=256;
constant IN_WIDTH_LOG   : integer:=8;

signal clk : std_logic;
signal rst : std_logic;
signal numerator : std_logic_vector(IN_WIDTH-1 downto 0);
signal denominator : std_logic_vector(IN_WIDTH-1 downto 0);
signal enable_in : std_logic;
signal quotient : std_logic_vector(IN_WIDTH-1 downto 0);
signal reminder : std_logic_vector(IN_WIDTH-1 downto 0);
signal enable_out : std_logic;
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
        wait for 15 ns;

        rst <= '1';
        wait for rst_const;

        rst <= '0';
        wait;

    end process;


    serial_divider_inst : entity work.serial_divider
    generic map(
        IN_WIDTH        => IN_WIDTH,
        IN_WIDTH_LOG    => IN_WIDTH_LOG
    )
    port map
        (
        clk => clk,
        rst => rst,
        numerator => numerator,
        denominator => denominator,
        enable_in => enable_in,
        quotient => quotient,
        reminder => reminder,
        enable_out => enable_out,
        busy       => busy
);

main_pr: process
begin

    numerator       <= (others=>'0');
    denominator     <= (others=>'0');
    enable_in       <= '0';

    wait until falling_edge(rst);
    wait until rising_edge(clk);

    wait until rising_edge(clk);
    numerator       <= std_logic_vector(to_unsigned(300000,numerator'length));
    denominator     <= std_logic_vector(to_unsigned(9999,denominator'length));
    enable_in       <= '1';

    wait until rising_edge(clk);
    enable_in       <= '0';


    wait;

end process;


--test_runner : process
--begin
--  test_runner_setup(runner, runner_cfg);
--   --if run("Main_test") then
--   --check_equal(17, 18);
--   --check_equal(17, 19);
--   --end if;
--  --check_equal(to_string(17), "17");
--  test_runner_cleanup(runner);
--end process;


end rtl;
