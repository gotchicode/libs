library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity serial_divider_top is
    generic (
        number_of_cells             : integer:=128;
        addr_width                  : integer:=7;
        data_width                  : integer:=32
        
    );
port(

    clk                             : in std_logic;
    rst                             : in std_logic;
    
    addr                            : in std_logic_vector(addr_width-1 downto 0); 
    wr_en                           : in std_logic;  
    rd_en                           : in std_logic;
    data_write                      : in std_logic_vector(data_width-1 downto 0);
    data_read                       : out std_logic_vector(data_width-1 downto 0)
 );
end entity serial_divider_top;


architecture rtl of serial_divider_top is

constant IN_WIDTH       : integer:=64;
constant IN_WIDTH_LOG   : integer:=6;

signal numerator : std_logic_vector(IN_WIDTH-1 downto 0);
signal denominator : std_logic_vector(IN_WIDTH-1 downto 0);
signal enable_in : std_logic;
signal quotient : std_logic_vector(IN_WIDTH-1 downto 0);
signal reminder : std_logic_vector(IN_WIDTH-1 downto 0);
signal enable_out : std_logic;
signal busy : std_logic;

type bank_registers_type                                    is array (0 to number_of_cells-1) of std_logic_vector(data_width-1 downto 0);                
signal bank_registers_write                                 : bank_registers_type;
signal bank_registers_read                                  : bank_registers_type;

signal data_to_encode_in                                    : std_logic_vector(9 downto 0);
signal data_to_encode_out                                   : std_logic_vector(9 downto 0);
signal data_to_decode_in                                    : std_logic_vector(9 downto 0);
signal data_to_decode_out                                   : std_logic_vector(9 downto 0);

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

process(clk)
begin

    if rising_edge(clk) then

        -- inputs
        numerator(31 downto 0)                       <= bank_registers_write(0);
        numerator(63 downto 32)                       <= bank_registers_write(1);
        denominator(31 downto 0)                       <= bank_registers_write(2);
        denominator(63 downto 32)                       <= bank_registers_write(3);
        enable_in                                           <= bank_registers_write(4)(0);

        -- outputs
        bank_registers_read(0)                 <= quotient(31 downto 0);
        bank_registers_read(1)                 <= quotient(63 downto 32);
        bank_registers_read(2)                 <= reminder(31 downto 0);
        bank_registers_read(3)                 <= reminder(63 downto 32);
        bank_registers_read(4)(1 downto 0)     <= enable_out & busy;

    end if;
    
end process;


end rtl;