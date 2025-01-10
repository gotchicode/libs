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
                end loop;
                data_bus_buffer(0) <= data_bus_in;
                data_en_buffer(0) <= data_en_in;
            end if;

            if enable_in='1' and enable_in_d1='1' then
                counter <= counter+1;
                for I in 0 to G_NB_ELEMENTS-1 loop
                    data_bus_buffer(I)(to_integer(counter)) <= data_bus_in(I);
                    data_en_buffer(I)(to_integer(counter)) <= data_en_in(I);
                end loop;
            end if;
            
            if enable_in='0' and enable_in_d1='1' then
                data_bus_buffer(to_integer(counter)) <= data_bus_in;
                data_en_buffer(to_integer(counter)) <= data_en_in;

                -- open the file
                file_open(fd, G_FILENAME, write_mode);

                -- write in the file
                write(v_line,string'("{signal: ["));
                writeline(fd, v_line);

                -- Fill the clock
                write(v_line,string'("  {name: ""clk"", wave:   ""p"));
                for K in 0 to to_integer(counter-1) loop
                    write(v_line,string'("."));
                end loop;
                write(v_line,string'("""},"));
                writeline(fd, v_line);
                
                -- Fill all others signals
                -- Check if it is used
                for K in 0 to G_NB_ELEMENTS-1 loop
                    -- start to write the line
                    if data_en_in_used(K)='1' and data_type_in(K)='1' then -- When it is an std_logic
                        write(v_line,string'("{ name: """));
                        write(v_line,names_in(K));
                        write(v_line,string'(""", wave: """));
                        for L in 0 to array_depth-1 loop

                            if L=0 then --first
                                if data_en_buffer(K)(L)='1' then
                                    write(v_line,string'("1"));
                                else
                                    write(v_line,string'("0"));
                                end if;
                            else --check with previous ones
                                if data_en_buffer(K)(L)='1' and data_en_buffer(K)(L-1)='0' then
                                    write(v_line,string'("1"));
                                elsif data_en_buffer(K)(L)='0' and data_en_buffer(K)(L-1)='1' then
                                    write(v_line,string'("0"));
                                else
                                    write(v_line,string'("."));
                                end if;
                            end if;

                        end loop;
                        write(v_line,string'(""" },"));
                        writeline(fd, v_line);
                    end if;
                    if data_en_in_used(K)='1' and data_type_in(K)='0' then -- When it is an std_logic_vector
                        write(v_line,string'("{ name: """));
                        write(v_line,names_in(K));
                        write(v_line,string'(""", wave: """));

                        for L in 0 to array_depth-1 loop
                            if L=0 then --first
                                write(v_line,string'("="));
                            elsif data_bus_buffer(K)(L)/=data_bus_buffer(K)(L-1) then
                                write(v_line,string'("="));
                            else
                                write(v_line,string'("."));
                            end if;
                        end loop;
                        write(v_line,string'(""" , data: """));

                        for L in 0 to array_depth-1 loop
                            if L=0 then --first
                                write(v_line,integer'(to_integer(unsigned(data_bus_buffer(K)(L)))));
                                write(v_line,string'(" ")); 
                            elsif data_bus_buffer(K)(L)/=data_bus_buffer(K)(L-1) then
                                write(v_line,integer'(to_integer(unsigned(data_bus_buffer(K)(L)))));
                                write(v_line,string'(" ")); 
                            else
                                -- dont write
                            end if;
                        end loop;
                        write(v_line,string'("""},"));    


                        writeline(fd, v_line);
                    end if;
                end loop;
                write(v_line,string'("]}"));
                writeline(fd, v_line);
                -- Finish the file



                -- close the file
                file_close(fd);

            end if;

        end if;
    end process;

end rtl;
