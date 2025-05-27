library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity fsm_forest is
generic(
    USE_ASYNC_RESET    :  boolean:=TRUE;
    USE_SYNC_RESET     :  boolean:=TRUE;
    ASYNC_RESET_ACTIVE :  std_logic:='1';
    SYNC_RESET_ACTIVE  :  std_logic:='1';
    REG_WIDTH          :  integer:=8;
    DEPTH              :  integer:=3;
    COUNTER_SIZE       :  integer:=8  --min=REG_WIDTH
);
port(
    clock       : in std_logic;
    async_reset : in std_logic;
    sync_reset  : in std_logic;
    reg_in      : in std_logic_vector(REG_WIDTH-1 downto 0);
    reg_out     : out std_logic_vector(REG_WIDTH-1 downto 0)
);
end entity;

architecture rtl of fsm_forest is

signal fsm_state                                : unsigned(DEPTH-1 downto 0):=(others=>'0');
type counter_array_type                         is array (0 to 2**DEPTH-1) of unsigned(COUNTER_SIZE-1 downto 0);
signal counter_array                            : counter_array_type:=(others=>(others=>'0'));

begin

fsm_pr: process(clock, async_reset)     
begin                               
    if (async_reset=ASYNC_RESET_ACTIVE) and (USE_ASYNC_RESET=true) then
        fsm_state <= (others=>'0');
        counter_array <= (others=>(others=>'0'));
    elsif rising_edge(clock) then  
        if (sync_reset=SYNC_RESET_ACTIVE) and (USE_SYNC_RESET=true) then
            fsm_state <= (others=>'0');
            counter_array <= (others=>(others=>'0'));
        else
        
            for I_STATES in 0 to 2**DEPTH-1 loop
                if I_STATES=0 then
                    if fsm_state=to_unsigned(0, DEPTH) then
                        if counter_array(0)(COUNTER_SIZE-1)='1' then
                            counter_array(0) <= (others=>'0');
                            fsm_state <= fsm_state+1;
                        else
                            counter_array(0) <= counter_array(0) + unsigned(reg_in);
                        end if;
                    end if;
                else
                    if fsm_state=to_unsigned(2**DEPTH-1, DEPTH) then
                        if counter_array(2**DEPTH-1)(COUNTER_SIZE-1)='1' then
                            counter_array(2**DEPTH-1) <= (others=>'0');
                            fsm_state <= (others=>'0');
                        else
                            counter_array(2**DEPTH-1) <= counter_array(2**DEPTH-1) + 1;
                        end if;
                    elsif fsm_state=to_unsigned(I_STATES, DEPTH) then
                        if counter_array(I_STATES)(COUNTER_SIZE-1)='1' then
                            counter_array(I_STATES) <= (others=>'0');
                            fsm_state <= fsm_state+1;
                        else
                            counter_array(I_STATES) <= counter_array(I_STATES) + 1;
                        end if;
                    end if;
                end if;
            end loop;
            reg_out <= std_logic_vector(counter_array(DEPTH-1)(REG_WIDTH-1 downto REG_WIDTH-REG_WIDTH));
        end if;
    end if;                         
end process;                        


end rtl;
