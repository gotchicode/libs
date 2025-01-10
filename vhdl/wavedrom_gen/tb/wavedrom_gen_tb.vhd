library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library vunit_lib;
--context vunit_lib.vunit_context;

library work;
use work.wavedrom_gen_pkg.all;

entity wavedrom_gen_tb is
    --generic (runner_cfg : string := runner_cfg_default);
end wavedrom_gen_tb;

architecture rtl of wavedrom_gen_tb is

constant clk_const  : time := 5 ns;
signal clk          : std_logic;

signal data_bus_in                  : data_bus;
signal data_en_in                   : data_enable;
signal data_type_in                 : data_enable;
signal data_en_in_used              : data_enable;
signal names_in                     : data_names;
signal enable_in                    : std_logic:='0';

signal background_cnt               : unsigned(31 downto 0):=(others=>'0');
signal test_counter                 : unsigned(15 downto 0);
signal test_counter_enable          : std_logic;
signal test_enable_start            : std_logic;


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
-- Test cases
-----------------------------------------
test_runner : process
begin

    --test_runner_setup(runner, runner_cfg);
    --    if run("Main_test") then

            test_counter_enable <= '0';

            wait for 100 ns;

            wait until rising_edge(clk);

            for I in 0 to 1050 loop

                wait until rising_edge(clk);

                if background_cnt(5)='1' then
                    test_counter_enable <= not(test_counter_enable);
                    test_counter <= test_counter+1;
                else
                    test_counter_enable <= '0';
                end if;
                

                if background_cnt(5 downto 0)="100000" then
                    test_counter <= (others=>'0');
                    test_enable_start <= '1';
                else
                    test_enable_start <= '0';
                end if;

            end loop;

    --        check_equal(background_cnt, 1060);

    --    end if;

    --test_runner_cleanup(runner);
end process;

-----------------------------------------
-- wavedrom_gen_inst
-----------------------------------------
wavedrom_gen_inst: entity work.wavedrom_gen 
    generic map(
        G_NB_ELEMENTS => 16,
        G_FILENAME => "wavedrom_out.txt"
    )
    port map(
        clock           => clk,
        data_bus_in     => data_bus_in,
        data_en_in      => data_en_in,
        data_type_in    => data_type_in,
        data_en_in_used => data_en_in_used,
        names_in        => names_in,
        enable_in       => enable_in
    );

data_bus_in(0)             <= std_logic_vector(resize(test_counter,32));
data_en_in(0)              <= '0';                  -- xxxxx ;
data_type_in(0)            <= '0';                  -- xxxxx ;
data_en_in_used(0)         <= '1';                  -- xxxxx ;
names_in(0)                <= "test_counter                    ";

data_bus_in(1)             <= (others=>'0');        -- xxxxx ;
data_en_in(1)              <= test_counter_enable;
data_type_in(1)            <= '1';                  -- xxxxx ;
data_en_in_used(1)         <= '1';                  -- xxxxx ;
names_in(1)                <= (others=>'0');

data_bus_in(2)             <= (others=>'0');        -- xxxxx ;
data_en_in(2)              <= test_enable_start;
data_type_in(2)            <= '1';                  -- xxxxx ;
data_en_in_used(2)         <= '1';                  -- xxxxx ;
names_in(2)                <= (others=>'0');        -- xxxxx ;

data_bus_in(3)             <= (others=>'0');        -- xxxxx ;
data_en_in(3)              <= '0';                  -- xxxxx ;
data_type_in(3)            <= '0';                  -- xxxxx ;
data_en_in_used(3)         <= '0';                  -- xxxxx ;
names_in(3)                <= (others=>'0');        -- xxxxx ;

data_bus_in(4)             <= (others=>'0');        -- xxxxx ;
data_en_in(4)              <= '0';                  -- xxxxx ;
data_type_in(4)            <= '0';                  -- xxxxx ;
data_en_in_used(4)         <= '0';                  -- xxxxx ;
names_in(4)                <= (others=>'0');        -- xxxxx ;

data_bus_in(5)             <= (others=>'0');        -- xxxxx ;
data_en_in(5)              <= '0';                  -- xxxxx ;
data_type_in(5)            <= '0';                  -- xxxxx ;
data_en_in_used(5)         <= '0';                  -- xxxxx ;
names_in(5)                <= (others=>'0');        -- xxxxx ;

data_bus_in(6)             <= (others=>'0');        -- xxxxx ;
data_en_in(6)              <= '0';                  -- xxxxx ;
data_type_in(6)            <= '0';                  -- xxxxx ;
data_en_in_used(6)         <= '0';                  -- xxxxx ;
names_in(6)                <= (others=>'0');        -- xxxxx ;

data_bus_in(7)             <= (others=>'0');        -- xxxxx ;
data_en_in(7)              <= '0';                  -- xxxxx ;
data_type_in(7)            <= '0';                  -- xxxxx ;
data_en_in_used(7)         <= '0';                  -- xxxxx ;
names_in(7)                <= (others=>'0');        -- xxxxx ;

data_bus_in(8)             <= (others=>'0');        -- xxxxx ;
data_en_in(8)              <= '0';                  -- xxxxx ;
data_type_in(8)            <= '0';                  -- xxxxx ;
data_en_in_used(8)         <= '0';                  -- xxxxx ;
names_in(8)                <= (others=>'0');        -- xxxxx ;

data_bus_in(9)             <= (others=>'0');        -- xxxxx ;
data_en_in(9)              <= '0';                  -- xxxxx ;
data_type_in(9)            <= '0';                  -- xxxxx ;
data_en_in_used(9)         <= '0';                  -- xxxxx ;
names_in(9)                <= (others=>'0');        -- xxxxx ;

data_bus_in(10)             <= (others=>'0');        -- xxxxx ;
data_en_in(10)              <= '0';                  -- xxxxx ;
data_type_in(10)            <= '0';                  -- xxxxx ;
data_en_in_used(10)         <= '0';                  -- xxxxx ;
names_in(10)                <= (others=>'0');        -- xxxxx ;

data_bus_in(11)             <= (others=>'0');        -- xxxxx ;
data_en_in(11)              <= '0';                  -- xxxxx ;
data_type_in(11)            <= '0';                  -- xxxxx ;
data_en_in_used(11)         <= '0';                  -- xxxxx ;
names_in(11)                <= (others=>'0');        -- xxxxx ;

data_bus_in(12)             <= (others=>'0');        -- xxxxx ;
data_en_in(12)              <= '0';                  -- xxxxx ;
data_type_in(12)            <= '0';                  -- xxxxx ;
data_en_in_used(12)         <= '0';                  -- xxxxx ;
names_in(12)                <= (others=>'0');        -- xxxxx ;

data_bus_in(13)             <= (others=>'0');        -- xxxxx ;
data_en_in(13)              <= '0';                  -- xxxxx ;
data_type_in(13)            <= '0';                  -- xxxxx ;
data_en_in_used(13)         <= '0';                  -- xxxxx ;
names_in(13)                <= (others=>'0');        -- xxxxx ;

data_bus_in(14)             <= (others=>'0');        -- xxxxx ;
data_en_in(14)              <= '0';                  -- xxxxx ;
data_type_in(14)            <= '0';                  -- xxxxx ;
data_en_in_used(14)         <= '0';                  -- xxxxx ;
names_in(14)                <= (others=>'0');        -- xxxxx ;

data_bus_in(15)             <= (others=>'0');        -- xxxxx ;
data_en_in(15)              <= '0';                  -- xxxxx ;
data_type_in(15)            <= '0';                  -- xxxxx ;
data_en_in_used(15)         <= '0';                  -- xxxxx ;
names_in(15)                <= (others=>'0');        -- xxxxx ;

process(clk)
begin
    if rising_edge(clk) then
        background_cnt <= background_cnt+1;
        if background_cnt=to_unsigned(281,16) then
            enable_in <= '1';
        end if;
        if background_cnt=to_unsigned(328,16) then
            enable_in <= '0';
        end if;
    end if;
end process;

end rtl;

