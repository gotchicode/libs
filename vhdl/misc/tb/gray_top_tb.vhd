
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_top_tb is
end gray_top_tb;

architecture rtl of gray_top_tb is

constant clk_const : time := 5 ns;
constant addr_width : integer := 7;
constant data_width : integer := 32;
constant number_of_cells : integer := 128;

signal clk : std_logic;
signal addr : std_logic_vector(addr_width-1 downto 0);
signal wr_en : std_logic;
signal rd_en : std_logic;
signal data_write : std_logic_vector(data_width-1 downto 0);
signal data_read : std_logic_vector(data_width-1 downto 0);

type bank_registers_type                          is array (0 to number_of_cells-1) of std_logic_vector(data_width-1 downto 0);                
signal bank_registers_write                       : bank_registers_type;
signal bank_registers_read                        : bank_registers_type;


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




    gray_inst : entity work.gray_top
    port map
        (
        clk => clk,
        addr => addr,
        wr_en => wr_en,
        rd_en => rd_en,
        data_write => data_write,
        data_read => data_read
);

    -------------addr_width----------------------------
    -- main tb
    -----------------------------------------
    main_pr: process 
    
    --procedure initilialize testvector
    procedure init_test_vectors is
    begin
   
        --bank_registers_write(0)<= x"00000009";
        --bank_registers_write(1)<= x"0000000D";

        bank_registers_write(0)<= x"FFFFFFFF";
        bank_registers_write(1)<= x"00000200";

    end init_test_vectors;

    --procedure write vector
    procedure write_vector is
    begin

        for I in 0 to number_of_cells-1 loop
                wait until rising_edge(clk);
                wr_en       <='1';
                addr        <= std_logic_vector(to_unsigned(I,addr_width));
                data_write  <= bank_registers_write(I);
                wait until rising_edge(clk);
                wr_en       <='0';
        end loop;

    end write_vector;

    --procedure read vector
    procedure read_vector is
        begin
    
            for I in 0 to number_of_cells-1 loop
                    wait until rising_edge(clk);
                    rd_en       <='1';
                    addr        <= std_logic_vector(to_unsigned(I,addr_width));
                    wait until rising_edge(clk);
                    rd_en       <='0';
                    wait until rising_edge(clk);
                    bank_registers_read(I) <= data_read;
                    wait until rising_edge(clk);    
            end loop;
    
        end read_vector;
    
    
    begin

        -- wait for 100 ns aand a clock
        wait for 100 ns;
        wait until rising_edge(clk);

        -- initilialize testvector
        init_test_vectors;


        -- wait for 100 ns aand a clock
        wait for 100 ns;
        wait until rising_edge(clk);

        -- write vector
        write_vector;

        -- wait for 100 ns aand a clock
        wait for 100 ns;
        wait until rising_edge(clk);

        -- read vector
        read_vector;


    
    wait;
    end process;


end rtl;
