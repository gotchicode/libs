
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_slave is
    generic (   msb_lsb_first : integer:=1; -- 0: lsb / 1: msb
                bit_size      : integer:=8;
                timeout       : integer:=9999 --Should be period value x4
    );
 port (
            clk             : in std_logic;
            rst             : in std_logic;
     
            data_in         : in std_logic_vector(7 downto 0);
            data_in_en      : in std_logic;
            data_out        : out std_logic_vector(7 downto 0);
            data_out_en     : out std_logic;
    
            sclk            : in std_logic;
            ce              : in std_logic;
            mosi            : in std_logic;
            miso            : out std_logic;
        
            busy            : out std_logic

 );
end entity spi_slave;

architecture rtl of spi_slave is

signal timeout_cnt              : unsigned(15 downto 0);
signal sclk_d1                  : std_logic;
signal ce_d1                    : std_logic;
signal re_rcv_cnt               : unsigned(15 downto 0);
signal data_out_reg             : std_logic_vector(bit_size-1 downto 0);
signal data_in_reg              : std_logic_vector(bit_size-1 downto 0);

begin

--template_pr: process(clk, rst)
--begin
--    if rst='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

--Delay
delay_pr: process(clk, rst)
begin
    if rst='1' then
        sclk_d1     <= '0';
        ce_d1       <= '0';
    elsif rising_edge(clk) then
 
        sclk_d1     <= sclk;
        ce_d1       <= ce;

    end if;
end process;

----------------------------
-- Recover data
----------------------------
process(clk, rst)
begin
    if rst='1' then
	
        timeout_cnt     <= (others=>'0');
        re_rcv_cnt      <= (others=>'0');
		data_out_reg    <= (others=>'0'); 
        data_out        <= (others=>'0'); 
        data_out_en     <= '0';	

    elsif rising_edge(clk) then
 
        --reset the counter
        if ce='1' then
            re_rcv_cnt <= (others=>'0');
            timeout_cnt <= (others=>'0');
        elsif timeout_cnt=to_unsigned(timeout,16) then
            re_rcv_cnt <= (others=>'0');
            timeout_cnt <= (others=>'0');
        elsif sclk='1' and sclk_d1='0' then
            re_rcv_cnt <= re_rcv_cnt+1;
            timeout_cnt <= (others=>'0');
        else
            timeout_cnt <= timeout_cnt+1;
        end if;
     
        --sample data
        if sclk='1' and sclk_d1='0' then
            for I in 0 to bit_size-1 loop
                if re_rcv_cnt=to_unsigned(I,16) then
                    --MSB first
                    if msb_lsb_first=1 then
                        data_out_reg(7-I) <= mosi;
                    end if;
                    --LSB first
                    if msb_lsb_first=0 then
                        data_out_reg(I) <= mosi;
                    end if;
                end if;
            end loop;
        end if;
     
        if ce='1' and ce_d1='0' then
            data_out    <= data_out_reg;
            data_out_en <= '1';
        else
            data_out_en <= '0';
        end if;

    end if;
end process;

----------------------------
-- Send data
----------------------------
process(clk, rst)
begin
    if rst='1' then
        data_in_reg     <= (others=>'0');
        miso            <= '0';
    elsif rising_edge(clk) then
 
        --Latch data_in
        if data_in_en='1' then
            data_in_reg <= data_in;
        end if;

        --sample data
        if sclk='0' and sclk_d1='1' then
            for I in 0 to bit_size-1 loop
                if re_rcv_cnt=to_unsigned(I,16) then
                    --MSB first
                    if msb_lsb_first=1 then
                        miso <= data_in_reg(7-I);
                    end if;
                    --LSB first
                    if msb_lsb_first=0 then
                        miso <= data_in_reg(I);
                    end if;
                end if;
            end loop;
        end if;

    end if;
end process;


end rtl;