library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_skid_buffer is
generic(
    MODE       : integer:=1; -- 0: Off, 1: Skid buffer, 2: Combinatorial backpressure
    DATA_WIDTH : integer:=8
);
port(
    clk         : in std_logic;
    rst_n       : in std_logic;

    -- upstream interface
    s_tvalid : in std_logic;
    s_tdata  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    s_tready : out std_logic;

    -- downstream interface
    m_tvalid : out std_logic;
    m_tdata  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    m_tready : in  std_logic
  );
end axi_skid_buffer;

architecture rtl of axi_skid_buffer is

    -- internal signals
    signal s_tready_int         : std_logic;
    signal m_tvalid_int         : std_logic;

    -- overflow registers
    signal overflow_data_reg    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal overflow_valid_reg   : std_logic:='0';

    -- standard registers
    signal main_data_reg      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal main_valid_reg     : std_logic:='0';

begin

    -- internal signals to out
    s_tready <= s_tready_int;
    m_tvalid <= m_tvalid_int;
    

    GEN_MODE_OFF: if MODE=0 generate
        s_tready_int <= '0';
        m_tvalid_int <= '0';
        m_tdata <= (others=>'0');
    end generate GEN_MODE_OFF;

    GEN_MODE_SKID_BUFFER: if MODE=1 generate
        process(clk, rst_n) is
        begin
            if rst_n='0' then
                overflow_data_reg   <= (others=>'0');
                overflow_valid_reg  <= '0';
                overflow_data_reg   <= (others=>'0');
                overflow_valid_reg  <= '0';
            elsif rising_edge(clk) then
                
                if s_tready_int='1' then
                    main_valid_reg    <= s_tvalid;
                    main_data_reg     <= s_tdata;
                    if m_tready='0' then
                        overflow_valid_reg  <= main_valid_reg;
                        overflow_data_reg   <= main_data_reg;
                    end if;
                end if;

                if m_tready='1' then
                    overflow_valid_reg  <= '0';
                end if;

            end if;
        end process;

        s_tready_int <= not overflow_valid_reg;
        m_tvalid_int <= overflow_valid_reg or main_valid_reg;
        m_tdata  <= overflow_data_reg when overflow_valid_reg else main_data_reg;
    end generate GEN_MODE_SKID_BUFFER;

    GEN_MODE_COMBI_BACKPRESSURE: if MODE=2 generate

        process(clk, rst_n) is
        begin
            if rst_n='0' then
                m_tvalid_int <= '0';
                m_tdata  <= (others=>'0');
            elsif rising_edge(clk) then
                if s_tready_int='1' then
                    m_tvalid_int    <= s_tvalid;
                    m_tdata     <= s_tdata;
                end if;
            end if;
        end process;

        s_tready_int <= m_tready or not(m_tvalid_int);

    end generate GEN_MODE_COMBI_BACKPRESSURE;
    

end rtl;