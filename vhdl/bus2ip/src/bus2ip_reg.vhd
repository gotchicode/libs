library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bus2ip_reg is
generic(
    USE_ASYNC_RESET    :  boolean:=TRUE;
    USE_SYNC_RESET     :  boolean:=TRUE;
    ASYNC_RESET_ACTIVE :  std_logic:='1';
    SYNC_RESET_ACTIVE  :  std_logic:='1'
);
port(
    clock               : in std_logic;
    async_reset         : in std_logic;
    sync_reset          : in std_logic;
    Bus2IP_CS_Slave     : in std_logic;
    Bus2IP_addr_Slave   : in std_logic_vector(31 downto 0);
    Bus2IP_WrCE_Slave   : in std_logic;
    Bus2IP_RdCE_Slave   : in std_logic;
    Bus2IP_Data_Slave   : in std_logic_vector(31 downto 0);
    IP2Bus_WrAck_Slave  : out std_logic;
    IP2Bus_RdAck_Slave  : out std_logic;
    IP2Bus_Data_Slave   : out std_logic_vector(31 downto 0);
    IP2Bus_Error_Slave  : out std_logic;
    IP2Bus_CS_Master    : out std_logic;
    IP2Bus_addr_Master  : out std_logic_vector(31 downto 0);
    IP2Bus_WrCE_Master  : out std_logic;
    IP2Bus_RdCE_Master  : out std_logic;
    IP2Bus_Data_Master  : out std_logic_vector(31 downto 0);
    Bus2IP_WrAck_Master : in std_logic;
    Bus2IP_RdAck_Master : in std_logic;
    Bus2IP_Data_Master  : in std_logic_vector(31 downto 0);
    Bus2IP_Error_Master : in std_logic
);
end entity;

architecture rtl of bus2ip_reg is
constant IDLE_STATE         : std_logic_vector(2 downto 0):="000";
constant WR_STATE           : std_logic_vector(2 downto 0):="001";
constant WR_ACK_STATE       : std_logic_vector(2 downto 0):="010";
constant RD_STATE           : std_logic_vector(2 downto 0):="011";
constant RD_ACK_STATE       : std_logic_vector(2 downto 0):="100";

signal IP2Bus_WrCE_Master_t : std_logic;
signal IP2Bus_RdCE_Master_t : std_logic;
signal IP2Bus_WrAck_Slave_t : std_logic;
signal IP2Bus_RdAck_Slave_t : std_logic;


signal sm : std_logic_vector(2 downto 0);
begin

IP2Bus_WrAck_Slave <= IP2Bus_WrAck_Slave_t;
IP2Bus_RdAck_Slave <= IP2Bus_RdAck_Slave_t;
IP2Bus_WrCE_Master <= IP2Bus_WrCE_Master_t;
IP2Bus_RdCE_Master <= IP2Bus_RdCE_Master_t;

main_pr: process(clock, async_reset)     
begin                               
    if (async_reset=ASYNC_RESET_ACTIVE) and (USE_ASYNC_RESET=true) then
        sm <= IDLE_STATE;
        IP2Bus_WrAck_Slave_t    <= '0';             --: out std_logic;
        IP2Bus_RdAck_Slave_t    <= '0';             --: out std_logic;
        IP2Bus_Data_Slave       <= (others=>'0');   --: out std_logic_vector(31 downto 0);
        IP2Bus_Error_Slave      <= '0';             --: out std_logic;
        IP2Bus_CS_Master        <= '0';             --: out std_logic;
        IP2Bus_addr_Master      <= (others=>'0');   --: out std_logic_vector(31 downto 0);
        IP2Bus_WrCE_Master_t    <= '0';             --: out std_logic;
        IP2Bus_RdCE_Master_t    <= '0';             --: out std_logic;
        IP2Bus_Data_Master      <= (others=>'0');   --: out std_logic_vector(31 downto 0);
    elsif rising_edge(clock) then  
        if (sync_reset=SYNC_RESET_ACTIVE) and (USE_SYNC_RESET=true) then
            sm <= IDLE_STATE;
            IP2Bus_WrAck_Slave_t    <= '0';             --: out std_logic;
            IP2Bus_RdAck_Slave_t    <= '0';             --: out std_logic;
            IP2Bus_Data_Slave       <= (others=>'0');   --: out std_logic_vector(31 downto 0);
            IP2Bus_Error_Slave      <= '0';             --: out std_logic;
            IP2Bus_CS_Master        <= '0';             --: out std_logic;
            IP2Bus_addr_Master      <= (others=>'0');   --: out std_logic_vector(31 downto 0);
            IP2Bus_WrCE_Master_t    <= '0';             --: out std_logic;
            IP2Bus_RdCE_Master_t    <= '0';             --: out std_logic;
            IP2Bus_Data_Master      <= (others=>'0');   --: out std_logic_vector(31 downto 0);
        else
            case sm is
                when IDLE_STATE     =>
                    if Bus2IP_CS_Slave='1' then
                        if Bus2IP_WrCE_Slave='1' then
                            sm <= WR_STATE;
                            IP2Bus_WrCE_Master_t <= '1';
                            IP2Bus_addr_Master <= Bus2IP_addr_Slave;
                            IP2Bus_data_Master <= Bus2IP_data_Slave;
                        end if;
                        if Bus2IP_RdCE_Slave='1' then
                            sm <= RD_STATE;
                            IP2Bus_RdCE_Master_t <= '1';
                            IP2Bus_addr_Master <= Bus2IP_addr_Slave;
                        end if;
                    end if;
                when WR_STATE       =>
                    if Bus2IP_CS_Slave='0' or Bus2IP_WrCE_Slave='0' then
                        sm <= IDLE_STATE;                                    
                        IP2Bus_addr_Master      <= (others=>'0');   
                        IP2Bus_WrCE_Master_t    <= '0';                       
                    elsif IP2Bus_WrCE_Master_t='1' and Bus2IP_WrAck_Master='1' then
                        sm <= WR_ACK_STATE;
                        IP2Bus_WrCE_Master_t <= '0';
                        IP2Bus_WrAck_Slave_t <= '1';
                        IP2Bus_Error_Slave   <= Bus2IP_Error_Master;
                    end if;
                when WR_ACK_STATE   => 
                    if Bus2IP_WrCE_Slave='1' and IP2Bus_WrAck_Slave_t='1' then
                        sm <= IDLE_STATE;
                        IP2Bus_WrAck_Slave_t <= '0';
                    end if;
                when RD_STATE       => 
                    if Bus2IP_CS_Slave='0' or Bus2IP_RdCE_Slave='0' then
                        sm <= IDLE_STATE; 
                        IP2Bus_addr_Master      <= (others=>'0');   
                        IP2Bus_RdCE_Master_t    <= '0';    
                    elsif IP2Bus_RdCE_Master_t='1' and Bus2IP_RdAck_Master='1' then
                        sm <= RD_ACK_STATE;
                        IP2Bus_RdCE_Master_t <= '0';
                        IP2Bus_RdAck_Slave_t <= '1';
                        IP2Bus_Data_Slave <= Bus2IP_Data_Master;
                    end if;
                when RD_ACK_STATE   =>    
                    if Bus2IP_RdCE_Slave='1' and IP2Bus_RdAck_Slave_t='1' then
                        sm <= IDLE_STATE;
                        IP2Bus_RdAck_Slave_t <= '0';
                    end if;
                when others         =>
                    sm <= IDLE_STATE;
            end case;
            IP2Bus_CS_Master <= Bus2IP_CS_Slave;
        end if;
    end if;
end process;


end rtl;


















