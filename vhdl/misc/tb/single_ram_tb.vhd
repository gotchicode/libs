
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_ram_tb is
end single_ram_tb;

architecture rtl of single_ram_tb is

constant clk_const : time := 5 ns;

constant number_of_cells             : integer:=1024;
constant addr_width                  : integer:=10;
constant data_width                  : integer:=16;

signal clk : std_logic;
signal add_write : std_logic_vector(addr_width-1 downto 0);
signal data_write : std_logic_vector(data_width-1 downto 0);
signal wr_en : std_logic;
signal add_read : std_logic_vector(addr_width-1 downto 0);
signal rd_en : std_logic;
signal data_read : std_logic_vector(data_width-1 downto 0);



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
    -- Write and read to the ram
    -----------------------------------------
    write_read_pr: process
    begin
    
        add_write   <= (others=>'0');
        data_write  <= (others=>'0');
        wr_en       <= '0';
        
        add_read    <= (others=>'0');
        rd_en       <= '0';

        wait for 1 us;
        
        for I in 0 to number_of_cells-1 loop
            
            --Write
            wait until rising_edge(clk);
            add_write   <= std_logic_vector(to_unsigned(I,addr_width));
            data_write  <= std_logic_vector(to_unsigned(I,data_width));
            wr_en       <= '1';
            wait until rising_edge(clk);
            wr_en       <= '0';
            
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            
            --Read
            add_read   <= std_logic_vector(to_unsigned(I,addr_width));
            rd_en       <= '1';
            wait until rising_edge(clk);
            rd_en       <= '0';
            
        end loop;
        
        wait;
    
    end process;




    single_ram_inst : entity work.single_ram
    generic map(
        number_of_cells   => number_of_cells,
        addr_width        => addr_width,
        data_width        => data_width
    )
    port map
        (
        clk => clk,
        add_write => add_write,
        data_write => data_write,
        wr_en => wr_en,
        add_read => add_read,
        rd_en => rd_en,
        data_read => data_read
);

end rtl;
