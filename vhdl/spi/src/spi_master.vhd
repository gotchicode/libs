library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_master is
    generic ( clk_div       : integer:=20; --sclk_freq= clk_freq/clk_div/2 (ie: 100MHz/10/2) = 5MHz (clk_div at leat at 2 to work)
              msb_lsb_first : integer:=1; -- 0: lsb / 1: msb
              bit_size      : integer:=8
    );
 port (
  clk             : in std_logic;
  rst             : in std_logic;
     
        data_in         : in std_logic_vector(7 downto 0);
        data_in_en      : in std_logic;
        data_out        : out std_logic_vector(7 downto 0);
        data_out_en      : out std_logic;

        sclk            : out std_logic;
        ce              : out std_logic;
        mosi            : out std_logic;
        miso            : in std_logic;
     
        busy            : out std_logic

 );
end entity spi_master;

architecture rtl of spi_master is

type state_type is (idle, wait_start, ce_down, run, ce_up);  -- Define the states
signal sm_stages                : state_type:=idle;
signal sm_stages_d1             : state_type:=idle;

signal data_in_reg              : std_logic_vector(bit_size-1 downto 0);
signal spi_master_sclk          : std_logic;
signal spi_master_sclk_cnt      : unsigned(15 downto 0);
signal spi_master_sclk_d1       : std_logic;
signal spi_master_sclk_d2       : std_logic;
signal spi_master_sclk_d3       : std_logic;
signal spi_ce                   : std_logic;
signal run_cnt                  : unsigned(15 downto 0);
signal mosi_sample              : std_logic;
signal mosi_sample_d1           : std_logic;
signal data_out_reg             : std_logic_vector(bit_size-1 downto 0);

begin

--template_pr: process(clk, rst)
--begin
--    if rst='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

----------------------------
-- Generate the clock
----------------------------
process(clk, rst)
begin
    if rst='1' then
 
        spi_master_sclk      <= '0';
        spi_master_sclk_cnt  <= (others=>'0');
        spi_master_sclk_d1   <= '0';
        spi_master_sclk_d2   <= '0';
        spi_master_sclk_d3   <= '0';

    elsif rising_edge(clk) then
 
        if sm_stages=idle then
     
            spi_master_sclk_cnt <= (others=>'0');
            spi_master_sclk     <= '0';
         
        else
         
            if spi_master_sclk_cnt=to_unsigned(clk_div-1,16) then
                spi_master_sclk_cnt <= (others=>'0');
            else
                spi_master_sclk_cnt <= spi_master_sclk_cnt+1;
            end if;
         
            if spi_master_sclk_cnt=to_unsigned(clk_div-1,16) then
                spi_master_sclk <= not(spi_master_sclk);
            end if;
         
        end if;
     
        spi_master_sclk_d1 <= spi_master_sclk;
        spi_master_sclk_d2 <= spi_master_sclk_d1;
        spi_master_sclk_d3 <= spi_master_sclk_d2;

    end if;
end process;

----------------------------
-- SPI sm process
----------------------------
process(clk, rst)
begin
    if rst='1' then
 
        data_in_reg     <= (others=>'0');
        sm_stages       <= IDLE;
        run_cnt         <= (others=>'0');
        spi_ce          <= '0';
        mosi_sample     <= '0';
        mosi_sample_d1  <= mosi_sample;

    elsif rising_edge(clk) then
 
        -- state machine
        case sm_stages is
            when idle =>
                if data_in_en='1' then
                    sm_stages   <= wait_start;
                end if;
            when wait_start =>
                if spi_master_sclk='0' and spi_master_sclk_d1='1' then
                    sm_stages   <= ce_down;
                end if;
            when ce_down =>
                if spi_master_sclk='1' and spi_master_sclk_d1='0' then
                    sm_stages   <= run;
                    run_cnt     <= (others=>'0');   
                end if;
            when run =>
                    if spi_master_sclk='1' and spi_master_sclk_d1='0' then
                        if run_cnt=to_unsigned(bit_size-1,16) then
                            sm_stages   <= ce_up;
                        else
                            run_cnt <= run_cnt+1;
                        end if;
                    end if;
            when ce_up =>
                if spi_master_sclk='1' and spi_master_sclk_d1='0' then
                    sm_stages <= idle;
                end if;
            when others =>
                sm_stages <= idle;
        end case;
        sm_stages_d1 <= sm_stages;
     
        --ce
        if sm_stages=ce_down then
            spi_ce <= '1';
        end if;
        if sm_stages=ce_up then
            spi_ce <= '0';
        end if;
     
        -- latch data
        if data_in_en='1' and sm_stages=idle then
            data_in_reg <= data_in;
        end if;
     
        -- sample data
        if sm_stages=run and spi_master_sclk_d1='1' and spi_master_sclk_d2='0' then
            for I in 0 to bit_size-1 loop
                if run_cnt=to_unsigned(I,16) then
                    --MSB first
                    if msb_lsb_first=1 then
                        mosi_sample <= data_in_reg(7-I);
                    end if;
                    --LSB first
                    if msb_lsb_first=0 then
                        mosi_sample <= data_in_reg(I);
                    end if;
                end if;
            end loop;
        end if;
     
        mosi_sample_d1 <= mosi_sample;
     
     

    end if;
end process;

----------------------------
-- sampling miso
----------------------------
process(clk, rst)
begin
    if rst='1' then
 
        data_out    <= (others=>'0');
        data_out_en <= '0';
     
    elsif rising_edge(clk) then
 
        if sm_stages=run and spi_master_sclk_d2='0' and spi_master_sclk_d3='1' then
            for I in 0 to bit_size-1 loop
                if run_cnt=to_unsigned(I,16) then
                    --MSB first
                    if msb_lsb_first=1 then
                        data_out_reg(7-I) <= miso;
                    end if;
                    --LSB first
                    if msb_lsb_first=0 then
                        data_out_reg(I) <= miso;
                    end if;
                end if;
            end loop;
        end if;
     
        if sm_stages=idle and sm_stages_d1=ce_up then
            data_out <= data_out_reg;
            data_out_en <= '1';
        else
            data_out_en <= '0';
        end if;
     
    end if;
end process;

----------------------------
-- output process
----------------------------
process(clk, rst)
begin
    if rst='1' then
 
        sclk <= '1';
        ce   <= '1';
        mosi <= '1';

    elsif rising_edge(clk) then
 
        sclk <= not(spi_master_sclk_d2 and spi_ce);
        ce   <= not(spi_ce);
        mosi <= mosi_sample and spi_ce;
 
    end if;
end process;

----------------------------
-- Busy process
----------------------------
process(clk, rst)
begin
    if rst='1' then
        busy <= '0';
    elsif rising_edge(clk) then
        if sm_stages=idle then
            busy <= '0';
        else
            busy <= '1';
        end if;
    end if;
end process;

end rtl;
