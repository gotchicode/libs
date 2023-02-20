library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.multiple_access_ram_pkg.all;

entity multiple_access_ram_memory_map_top is
    generic (
        number_of_cells             : integer:=128;
        addr_width                  : integer:=7;
        data_width                  : integer:=32
        
    );
port(

    clk                             : in std_logic;
    
    addr                            : in std_logic_vector(addr_width-1 downto 0); 
    wr_en                           : in std_logic;  
    rd_en                           : in std_logic;
    data_write                      : in std_logic_vector(data_width-1 downto 0);
    data_read                       : out std_logic_vector(data_width-1 downto 0)
 );
end entity multiple_access_ram_memory_map_top;


architecture rtl of multiple_access_ram_memory_map_top is

constant all_at_zero                              : std_logic_vector(15 downto 0):=(others=>'0');

type bank_registers_type                          is array (0 to number_of_cells-1) of std_logic_vector(data_width-1 downto 0);                
signal bank_registers_write                       : bank_registers_type;
signal bank_registers_read                        : bank_registers_type;

signal sub_addr_wr                                : addr_type;
signal sub_addr_rd                                : addr_type;
signal sub_data_wr                                : data_type;
signal sub_data_en                                : data_type;

signal multiple_access_ram_addr_wr                : addr_type;
signal multiple_access_ram_wr_en                  : std_logic_vector(15 downto 0);
signal multiple_access_ram_wr_ack                 : std_logic_vector(15 downto 0);
signal multiple_access_ram_data_wr                : data_type;
signal multiple_access_ram_addr_rd                : addr_type;
signal multiple_access_ram_rd_en                  : std_logic_vector(15 downto 0);
signal multiple_access_ram_rd_ack                 : std_logic_vector(15 downto 0);
signal multiple_access_ram_data_rd                : data_type;
signal multiple_access_ram_wr_id                  : std_logic_vector(3 downto 0);
signal multiple_access_ram_rd_id                  : std_logic_vector(3 downto 0);


begin

------------------------------------------                                                           
-- write                                                               
------------------------------------------
write_pr: process(clk)
begin
    if rising_edge(clk) then

        if wr_en='1' then
            for I in 0 to number_of_cells-1 loop                                                             
                if addr=std_logic_vector(to_unsigned(I,addr_width)) then
                    bank_registers_write(I) <= data_write;
                end if;
            end loop;  
        end if;
    end if;
end process;

------------------------------------------                                                           
-- RAM read                                                               
------------------------------------------
read_pr: process(clk)
begin
    if rising_edge(clk) then

        if rd_en='1' then
            for I in 0 to number_of_cells-1 loop                                                             
                if addr=std_logic_vector(to_unsigned(I,addr_width)) then
                    data_read <= bank_registers_read(I);
                end if;
            end loop;  
        end if;
    end if;
end process;

------------------------------------------                                                           
-- Here a module to be instantiated                                                           
------------------------------------------
multiple_access_ram_inst: entity work.multiple_access_ram 
    generic map(
        USE_ASYNC_RESET    => FALSE, 
        USE_SYNC_RESET     => TRUE,
        ASYNC_RESET_ACTIVE => '1',
        SYNC_RESET_ACTIVE  => '1'
    )
    port map(
        clock       => clk, --: in std_logic;
        async_reset => all_at_zero(0), --: in std_logic;
        sync_reset  => bank_registers_write(0)(0), --: in std_logic;
        addr_wr     => multiple_access_ram_addr_wr, --: in addr_type;
        wr_en       => multiple_access_ram_wr_en, --: in std_logic;
        wr_ack      => multiple_access_ram_wr_ack, --: out std_logic;
        data_wr     => multiple_access_ram_data_wr, --: in data_type;
        addr_rd     => multiple_access_ram_addr_rd, --: in addr_type;
        rd_en       => multiple_access_ram_rd_en, --: in std_logic;
        rd_ack      => multiple_access_ram_rd_ack, --: out std_logic;
        data_rd     => multiple_access_ram_data_rd , --: out data_type;
        wr_id       => multiple_access_ram_wr_id, --: in std_logic_vector(3 downto 0);
        rd_id       => multiple_access_ram_rd_id    --: out std_logic_vector(3 downto 0)
    );

    process(clk)
    begin
        if rising_edge(clk) then

            -- Bank register 0 assigned to reset
            -- Directly connected
            bank_registers_read(0) <= bank_registers_write(0);

            -- Bank register 1 to 16 assigned to addr_wr
            for I in 1 to 16 loop
                multiple_access_ram_addr_wr(I-1) <= bank_registers_write(I)(9 downto 0);
                bank_registers_read(I) <= bank_registers_write(I);
            end loop;

            -- Bank register 17 to 32 assigned to addr_rd
            for I in 17 to 32 loop
                multiple_access_ram_addr_rd(I-17) <= bank_registers_write(I)(9 downto 0);
                bank_registers_read(I) <= bank_registers_write(I);
            end loop;

            -- Bank register 33 to 48 assigned to data_wr
            for I in 1 to 16 loop
                multiple_access_ram_addr_wr(I-1) <= bank_registers_write(I);
                bank_registers_read(I) <= bank_registers_write(I);
            end loop;
            
            -- Bank register 49 to 64 assigned to data_rd
            for I in 49 to 64 loop
                bank_registers_read(I) <=  multiple_access_ram_addr_rd(I-1);
            end loop;
            -- Bank register 65 assigned to wr_en
            multiple_access_ram_wr_en(15 downto 0) <= bank_registers_write(65)(15 downto 0);
            bank_registers_read(65) <= bank_registers_write(65);

            -- Bank register 66 assigned to rd_en
            bank_registers_read(66)(15 downto 0) <=  multiple_access_ram_rd_en(15 downto 0);
            bank_registers_read(66) <= bank_registers_write(66);

            -- Bank register 67 assigned to wr_ack
            bank_registers_read(67)(15 downto 0) <=  multiple_access_ram_wr_ack(15 downto 0);
            bank_registers_read(67) <= bank_registers_write(67);

            -- Bank register 68 assigned to rd_ack
            bank_registers_read(68)(15 downto 0) <=  multiple_access_ram_rd_ack(15 downto 0);
            bank_registers_read(68) <= bank_registers_write(68);

        end if;
    end process;


end rtl;