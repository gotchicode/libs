library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.multiple_access_ram_pkg.all;

entity multiple_access_ram is
generic(
    USE_ASYNC_RESET    :  boolean:=FALSE;
    USE_SYNC_RESET     :  boolean:=TRUE;
    ASYNC_RESET_ACTIVE :  std_logic:='1';
    SYNC_RESET_ACTIVE  :  std_logic:='1'
);
port(
    clock       : in std_logic;
    async_reset : in std_logic;
    sync_reset  : in std_logic;
    addr_wr     : in addr_type;
    wr_en       : in std_logic_vector(15 downto 0);
    wr_ack      : out std_logic_vector(15 downto 0);
    data_wr     : in data_type;
    addr_rd     : in addr_type;
    rd_en       : in std_logic_vector(15 downto 0);
    rd_ack      : out std_logic_vector(15 downto 0);
    data_rd     : out data_type;
    wr_id       : in std_logic_vector(3 downto 0);
    rd_id       : out std_logic_vector(3 downto 0)
);
end entity;

architecture rtl of multiple_access_ram is

constant nb_cells   : integer:=1024;
constant addr_width : integer:=10;
constant data_width : integer:=32;


signal single_ram_add_write                       : std_logic_vector(addr_width-1 downto 0); 
signal single_ram_data_write                      : std_logic_vector(data_width-1 downto 0);
signal single_ram_wr_en                           : std_logic;  
signal single_ram_add_read                        : std_logic_vector(addr_width-1 downto 0); 
signal single_ram_rd_en                           : std_logic; 
signal single_ram_data_read                       : std_logic_vector(data_width-1 downto 0);
signal rd_ack_p1                                  : std_logic_vector(15 downto 0);

begin


write_to_ram_mux_pr: process(clock, async_reset)
variable v_check_wr_en : std_logic_vector(15 downto 0);
variable v_check_rd_en : std_logic_vector(15 downto 0);
begin                               
    if (async_reset=ASYNC_RESET_ACTIVE) and (USE_ASYNC_RESET=true) then

        single_ram_add_write  <= (others=>'0');
        single_ram_data_write <= (others=>'0');
        single_ram_wr_en      <= '0';
        single_ram_add_read   <= (others=>'0');
        single_ram_rd_en      <= '0';

        wr_ack      <= (others=>'0');
        rd_ack      <= (others=>'0');
        data_rd     <= (others=>(others=>'0'));
        rd_id       <= (others=>'0');

        rd_ack_p1   <= (others=>'0');

    elsif rising_edge(clock) then  
        if (sync_reset=SYNC_RESET_ACTIVE) and (USE_SYNC_RESET=true) then

        else

            -- No pipe / write
            for I in 1 to 16 loop
                v_check_wr_en := (others=>'0');
                v_check_wr_en(I-1) :='1';
                if wr_en=v_check_wr_en then
                    single_ram_wr_en <='1';
                    single_ram_add_write <= addr_wr(I-1);
                    wr_ack <= v_check_wr_en;
                elsif wr_en=std_logic_vector(to_unsigned(0,16)) then
                    single_ram_wr_en <='0';
                    wr_ack <= (others=>'0');
                end if;
            end loop;

            -- No pipe / read 
            for I in 1 to 16 loop
                v_check_rd_en := (others=>'0');
                v_check_rd_en(I-1) :='1';
                if rd_en=v_check_rd_en then
                    single_ram_rd_en <='1';
                    single_ram_add_read <= addr_rd(I-1);
                    rd_ack_p1 <= v_check_rd_en;
                elsif wr_en=std_logic_vector(to_unsigned(0,16)) then
                    single_ram_rd_en <='0';
                    rd_ack_p1 <= (others=>'0');
                end if;
            end loop;
            rd_ack <= rd_ack_p1;

        end if;
    end if;                         
end process;    

single_ram_inst: entity work.single_ram 
    generic map (
        number_of_cells             => nb_cells, --: integer:=4096;
        addr_width                  => addr_width, --: integer:=12;
        data_width                  => data_width --: integer:=16
    )
port map(

    clk                            => clock,                  --: in std_logic;
    add_write                      => single_ram_add_write   , --: in std_logic_vector(addr_width-1 downto 0); 
    data_write                     => single_ram_data_write  , --: in std_logic_vector(data_width-1 downto 0);
    wr_en                          => single_ram_wr_en       , --: in std_logic;  
    add_read                       => single_ram_add_read    , --: in std_logic_vector(addr_width-1 downto 0); 
    rd_en                          => single_ram_rd_en       , --: in std_logic; 
    data_read                      => single_ram_data_read     --: out std_logic_vector(data_width-1 downto 0)
 );

end rtl;
