library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity counter_dut_tb is
    generic (runner_cfg : string := runner_cfg_default);
end counter_dut_tb;

architecture rtl of counter_dut_tb is

constant clk_const      : time := 5 ns;
constant rst_const      : time := 123 ns;
constant buffer_size    : integer :=16;

signal clk : std_logic;
signal rst : std_logic;
signal enable : std_logic; 
signal data_out : std_logic_vector(31 downto 0);
signal data_out_en : std_logic;

--reference buffer
type buffer_type is array (0 to buffer_size-1) of std_logic_vector(31 downto 0);
signal ref_buffer : buffer_type;

--dut output buffer
signal dataout_buffer       : buffer_type;
signal dataout_buffer_ready : std_logic:='0';

--Comparison result
signal comparison_result    : std_logic_vector(3 downto 0);

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


    counter_dut_inst : entity work.counter_dut
    port map
        (
        clk => clk,
        rst => rst,
        enable => enable,
        data_out => data_out,
        data_out_en => data_out_en
);


test_runner : process
begin
  test_runner_setup(runner, runner_cfg);
   --if run("Main_test") then
   --check_equal(17, 18);
   --check_equal(17, 19);
   --end if;
  --check_equal(to_string(17), "17");
  --

  -- Wait for reset
  comparison_result <= "0000";
  enable <= '0';
  wait until falling_edge(rst);
  comparison_result <= "0010";
  enable <= '1';


  --Wait for buffer out filed
  wait until rising_edge(dataout_buffer_ready);

  --Compare buffers
  for I in 0 to buffer_size-1 loop

    if ref_buffer(I)=dataout_buffer(I) then

    else
        comparison_result <= "0011";
    end if;

  end loop;


  wait until rising_edge(clk);
  check_equal(to_string(to_integer(unsigned(comparison_result))), "2");

  wait for 1 us;
  test_runner_cleanup(runner);

  wait;
end process;

--File reference read process
file_read_pr: process
variable line_v     : line;
file read_file      : text;      
variable tmp        : real;
variable index      : integer:=0;

begin

    file_open(read_file, "../../ref_file.txt", read_mode);

    while not endfile(read_file) loop

        -- read line
        readline(read_file, line_v);
        read(line_v, tmp);

        --Store it in the buffer
        ref_buffer(index) <= std_logic_vector(to_unsigned(integer(tmp),32));

        --Index incr
        index := index+1;

    end loop;

    file_close(read_file);

    wait;
end process;

--File reference read process
dataout_to_buffer_pr: process
variable index      : integer:=0;
begin

    --Wait until reset
    wait until falling_edge(rst);

    while index<buffer_size loop

        wait until rising_edge(clk);

        if data_out_en='1' then
            --Store it in the buffer
            dataout_buffer(index) <= data_out;
            if index=buffer_size-1 then
                dataout_buffer_ready <= '1';
            end if;
            index := index +1;
        end if;

    end loop;

    wait;
end process;




end rtl;
