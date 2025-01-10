library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;

library work;
use work.wavedrom_gen_pkg.all;

entity wavedrom_gen is
generic(
    G_NB_ELEMENTS :  integer:= 16;
    G_FILENAME    :  string(1 to 16):="wavedrom_out.txt"
);
port(
    clock           : in std_logic;
    data_bus_in     : in data_bus;
    data_en_in      : in data_enable;
    data_type_in    : in data_enable;
    data_en_in_used : in data_enable;
    names_in        : in data_names;
    enable_in       : in std_logic
);
end entity;

architecture rtl of wavedrom_gen is

file fd : text;

signal data_bus_buffer              : array_data_bus;
signal data_en_buffer               : array_data_enable;
signal data_type_in                 : std_logic_vector(G_NB_ELEMENTS-1 downto 0);
signal data_en_used                 : std_logic_vector(G_NB_ELEMENTS-1 downto 0);

signal enable_in_d1                 : std_logic:='0';
signal counter                      : unsigned(15 downto 0);

begin

    -- Check for enable
    -- Detect the start
    -- Clear the buffer and start to fill it
    -- When stop start to save in the file
    -- Close the file

    process(clock)
    variable v_line : line;
    begin
        if rising_edge(clock) then

            enable_in_d1 <= enable_in;

            if enable_in='1' and enable_in_d1='0' then
                counter <= (others=>'0');
                -- clear buffer
                for I in 0 to G_NB_ELEMENTS-1 loop
                    data_bus_buffer(I) <= (others=>(others=>'0'));
                    data_en_buffer(I) <= (others=>'0');
                    data_type_in_buffer(I) <= (others=>'0');
                    data_en_used_buffer(I) <= (others=>'0');
                end loop;
                data_bus_buffer(0) <= data_bus_in;
                data_en_buffer(0) <= data_en_in;
                data_type_in_buffer(0) <= data_type_in;
                data_en_used_buffer(0) <= data_en_in_used;
            end if;

            if enable_in='1' and enable_in_d1='1' then
                counter <= counter+1;
                data_bus_buffer(to_integer(counter)) <= data_bus_in;
                data_en_buffer(to_integer(counter)) <= data_en_in;
                data_type_in_buffer(to_integer(counter)) <= data_type_in;
                data_en_used_buffer(to_integer(counter)) <= data_en_in_used;
            end if;
            
            if enable_in='0' and enable_in_d1='1' then
                data_bus_buffer(to_integer(counter)) <= data_bus_in;
                data_en_buffer(to_integer(counter)) <= data_en_in;
                data_type_in_buffer(to_integer(counter)) <= data_type_in;
                data_en_used_buffer(to_integer(counter)) <= data_en_in_used;

                -- open the file
                file_open(fd, G_FILENAME, write_mode);

                -- write in the file
                write(v_line,string'("{signal: ["));
                writeline(fd, v_line);

                -- Fill the clock
                write(v_line,string'("  {name: 'clk', wave:   'p"));
                for K in 0 to to_integer(counter-1) loop
                    write(v_line,string'("."));
                end loop;
                write(v_line,string'("'},"));
                writeline(fd, v_line);
                
                -- Fill all others signals
                -- Check if it is used
                for K in 0 to G_NB_ELEMENTS-1 loop
                    -- start to write the line
                    if data_en_used_buffer(K)(0)='1' and data_type_in_buffer(K)(0)='1' then
                        write(v_line,string'("{ name: "));
                        write(v_line,names_in(K));
                        writeline(fd, v_line);
                    end if;
                    for L in 0 to array_depth-1 loop
                        if data_en_used_buffer(K)(L)='1' then -- check only the first item
                            -- Check the type
                            --  1) Is it a bus
                            if data_type_in_buffer(K)(L)='1' then
                            end if;
                        --  2) Is it a wire
                        end if;
                    end loop;
                end loop;
                -- Finish the file



                -- close the file
                file_close(fd);

            end if;

        end if;
    end process;

end rtl;
