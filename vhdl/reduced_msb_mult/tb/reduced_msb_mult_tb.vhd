
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library work;
use work.reduced_msb_mult_pkg.all;

entity reduced_msb_mult_tb is
    generic (runner_cfg : string := runner_cfg_default);
end reduced_msb_mult_tb;

architecture rtl of reduced_msb_mult_tb is

constant C_USE_ASYNC_RESET    :  boolean:=TRUE;
constant C_USE_SYNC_RESET     :  boolean:=TRUE;
constant C_ASYNC_RESET_ACTIVE :  std_logic:='1';
constant C_SYNC_RESET_ACTIVE  :  std_logic:='1';
constant C_KERNEL_SIZE        :  integer:=12;
constant C_DATA_WIDTH         :  integer:=16;
constant C_USER_WIDTH         :  integer:=32;

constant clock_const : time := 5 ns;
constant async_reset_const : time := 123 ns;

signal reset_done             : std_logic:='0';

signal clock : std_logic;
signal async_reset : std_logic;
signal sync_reset : std_logic;
signal data_in : data_array;
signal signs_in : std_logic_vector(C_KERNEL_SIZE-1 downto 0);
signal valid_in : std_logic;
signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal valid_out : std_logic;
signal user_in : std_logic_vector(C_USER_WIDTH-1 downto 0);
signal user_out : std_logic_vector(C_USER_WIDTH-1 downto 0);



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
        
        reset_done <= '1';
        wait;

    end process;


    reduced_msb_mult_inst : entity work.reduced_msb_mult
    generic map(
        G_USE_ASYNC_RESET           => C_USE_ASYNC_RESET, 
        G_USE_SYNC_RESET            => C_USE_SYNC_RESET,
        G_ASYNC_RESET_ACTIVE        => C_ASYNC_RESET_ACTIVE,
        G_SYNC_RESET_ACTIVE         => C_SYNC_RESET_ACTIVE,
        G_KERNEL_SIZE               => C_KERNEL_SIZE,
        G_DATA_WIDTH                => C_DATA_WIDTH,
        G_USER_WIDTH                => C_USER_WIDTH
    )
    port map
        (
        clock => clock,
        async_reset => async_reset,
        sync_reset => sync_reset,
        data_in => data_in,
        signs_in => signs_in,
        valid_in => valid_in,
        data_out => data_out,
        valid_out => valid_out,
        user_in => user_in,
        user_out => user_out
);


test_runner : process
begin
    test_runner_setup(runner, runner_cfg);
    
    -----------------------------------------------------------------------------------------------
    if run("test_single_values_001") then
    -----------------------------------------------------------------------------------------------
        
        wait until reset_done='1';

        wait for 1 us;
        
        --------------------------------------------------------
        -- Test result 78 (data positive & sign positive)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_unsigned(I+1,C_MAX_BIT_WIDTH));
            signs_in(I)    <= '0';
        end loop;
        valid_in <='1';
        wait until rising_edge(clock);
        
        valid_in <='0';
        
        wait for 1 us;
        check_equal(data_out, 78);
        
        --------------------------------------------------------
        -- Test result -78 (data neg & sign pos)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_signed(-I-1,C_MAX_BIT_WIDTH)); --minus values
            signs_in(I)    <= '0';
        end loop;
        valid_in <='1';
        wait until rising_edge(clock);
        
        valid_in <='0';
        
        wait for 1 us;
        check_equal(data_out, std_logic_vector(to_signed(0-78,C_DATA_WIDTH)));
        
        --------------------------------------------------------
        -- Test result 78 (data neg & sign neg)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_signed(-I-1,C_MAX_BIT_WIDTH)); --minus values
            signs_in(I)    <= '1'; --minus values
        end loop;
        valid_in <='1';
        wait until rising_edge(clock);
        
        valid_in <='0';
        
        wait for 1 us;
        check_equal(data_out, std_logic_vector(to_signed(78,C_DATA_WIDTH)));
        
        --------------------------------------------------------
        -- Test result -78 (data pos & sign neg)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_signed(I+1,C_MAX_BIT_WIDTH)); --minus values
            signs_in(I)    <= '1';
        end loop;
        valid_in <='1';
        wait until rising_edge(clock);
        
        valid_in <='0';
        
        wait for 1 us;
        check_equal(data_out, std_logic_vector(to_signed(-78,C_DATA_WIDTH)));
        
        --------------------------------------------------------
        -- Test result -131 (random values)
        --------------------------------------------------------
        wait until rising_edge(clock);
        
        data_in(0) <= std_logic_vector(to_signed(-37     , C_MAX_BIT_WIDTH));
        data_in(1) <= std_logic_vector(to_signed(50      , C_MAX_BIT_WIDTH));
        data_in(2) <= std_logic_vector(to_signed(-124    , C_MAX_BIT_WIDTH));
        data_in(3) <= std_logic_vector(to_signed(-42     , C_MAX_BIT_WIDTH));
        data_in(4) <= std_logic_vector(to_signed(96      , C_MAX_BIT_WIDTH));
        data_in(5) <= std_logic_vector(to_signed(4       , C_MAX_BIT_WIDTH));
        data_in(6) <= std_logic_vector(to_signed(-23     , C_MAX_BIT_WIDTH));
        data_in(7) <= std_logic_vector(to_signed(-93     , C_MAX_BIT_WIDTH));
        data_in(8) <= std_logic_vector(to_signed(-16     , C_MAX_BIT_WIDTH));
        data_in(9) <= std_logic_vector(to_signed(29      , C_MAX_BIT_WIDTH));
        data_in(10) <= std_logic_vector(to_signed(-102    , C_MAX_BIT_WIDTH));
        data_in(11) <= std_logic_vector(to_signed(127     , C_MAX_BIT_WIDTH));   
        for I in 0 to C_KERNEL_SIZE-1 loop
            signs_in(I)    <= '0';
        end loop;
        valid_in <='1';
        wait until rising_edge(clock);
        
        valid_in <='0';
        
        wait for 1 us;
        check_equal(data_out, std_logic_vector(to_signed(-131,C_DATA_WIDTH)));
        
    end if;
    
    -----------------------------------------------------------------------------------------------
    if run("test_raw_values_002") then
    -----------------------------------------------------------------------------------------------
        
        wait until reset_done='1';

        wait for 1 us;
        
        --------------------------------------------------------
        -- Test result 78 (data positive & sign positive)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_unsigned(I+1,C_MAX_BIT_WIDTH));
            signs_in(I)    <= '0';
        end loop;
        valid_in <='1';
        
        --------------------------------------------------------
        -- Test result -78 (data neg & sign pos)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_signed(-I-1,C_MAX_BIT_WIDTH)); --minus values
            signs_in(I)    <= '0';
        end loop;
        valid_in <='1';
        
        --------------------------------------------------------
        -- Test result 78 (data neg & sign neg)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_signed(-I-1,C_MAX_BIT_WIDTH)); --minus values
            signs_in(I)    <= '1'; --minus values
        end loop;
        valid_in <='1';
        
        --------------------------------------------------------
        -- Test result -78 (data pos & sign neg)
        --------------------------------------------------------
        
        wait until rising_edge(clock);
        
        for I in 0 to C_KERNEL_SIZE-1 loop
            data_in(I)     <= std_logic_vector(to_signed(I+1,C_MAX_BIT_WIDTH)); --minus values
            signs_in(I)    <= '1';
        end loop;
        valid_in <='1';
        
        --------------------------------------------------------
        -- Test result -131 (random values)
        --------------------------------------------------------
        wait until rising_edge(clock);
        
        data_in(0) <= std_logic_vector(to_signed(-37     , C_MAX_BIT_WIDTH));
        data_in(1) <= std_logic_vector(to_signed(50      , C_MAX_BIT_WIDTH));
        data_in(2) <= std_logic_vector(to_signed(-124    , C_MAX_BIT_WIDTH));
        data_in(3) <= std_logic_vector(to_signed(-42     , C_MAX_BIT_WIDTH));
        data_in(4) <= std_logic_vector(to_signed(96      , C_MAX_BIT_WIDTH));
        data_in(5) <= std_logic_vector(to_signed(4       , C_MAX_BIT_WIDTH));
        data_in(6) <= std_logic_vector(to_signed(-23     , C_MAX_BIT_WIDTH));
        data_in(7) <= std_logic_vector(to_signed(-93     , C_MAX_BIT_WIDTH));
        data_in(8) <= std_logic_vector(to_signed(-16     , C_MAX_BIT_WIDTH));
        data_in(9) <= std_logic_vector(to_signed(29      , C_MAX_BIT_WIDTH));
        data_in(10) <= std_logic_vector(to_signed(-102    , C_MAX_BIT_WIDTH));
        data_in(11) <= std_logic_vector(to_signed(127     , C_MAX_BIT_WIDTH));   
        for I in 0 to C_KERNEL_SIZE-1 loop
            signs_in(I)    <= '0';
        end loop;
        valid_in <='1';
        wait until rising_edge(clock);
        
        valid_in <='0';
        
        --------------------------------------------------------
        -- Check results
        --------------------------------------------------------
        
        wait until valid_out='1';
        wait until rising_edge(clock);
        check_equal(data_out, std_logic_vector(to_signed(78,C_DATA_WIDTH)));
        wait until rising_edge(clock);
        check_equal(data_out, std_logic_vector(to_signed(-78,C_DATA_WIDTH)));
        wait until rising_edge(clock);
        check_equal(data_out, std_logic_vector(to_signed(78,C_DATA_WIDTH)));
        wait until rising_edge(clock);
        check_equal(data_out, std_logic_vector(to_signed(-78,C_DATA_WIDTH)));
        wait until rising_edge(clock);
        check_equal(data_out, std_logic_vector(to_signed(-131,C_DATA_WIDTH)));
        
        wait for 1 us;
        
    end if;

    
    test_runner_cleanup(runner);
end process;

process(clock,async_reset)
begin
    if async_reset=C_ASYNC_RESET_ACTIVE then
        user_in <= (others=>'0');
    elsif rising_edge(clock) then
        user_in <= std_logic_vector(unsigned(user_in)+1);
    end if;
end process;


end rtl;
