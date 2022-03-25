library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_divider is
generic(
    IN_WIDTH        : integer:=64;
    IN_WIDTH_LOG    : integer:=6
);
port (
    clk                         : in  std_logic;
    rst                         : in  std_logic;
    
    numerator                   : in std_logic_vector(IN_WIDTH-1 downto 0);
    denominator                 : in std_logic_vector(IN_WIDTH-1  downto 0);
    enable_in                   : in std_logic;

    quotient                    : out std_logic_vector(IN_WIDTH-1  downto 0);
    reminder                    : out std_logic_vector(IN_WIDTH-1  downto 0);
    enable_out                  : out std_logic;
    busy                        : out std_logic

);
end serial_divider;

architecture rtl of serial_divider is

    type divider_state_type is (IDLE_state,A_state, B_state, C_state, D_state);
	signal divider_state        : divider_state_type:=A_state;
    signal counter              : unsigned(IN_WIDTH_LOG+1 downto 0);
    signal numerator_stored     : unsigned(IN_WIDTH-1  downto 0);
    signal denominator_stored   : unsigned(IN_WIDTH-1  downto 0);
    signal r                    : unsigned(IN_WIDTH-1 +1+IN_WIDTH-1 +1-1 downto 0);
    
begin

process(clk, rst)
variable tmp : integer;
begin
    if rst='1' then
        divider_state <= IDLE_state;
        numerator_stored   <= (others=>'0'); 
        denominator_stored  <= (others=>'0');
        counter <= (others=>'0');
        r <= (others=>'0');
        enable_out <= '0';
        busy <= '0';
    elsif rising_edge(clk) then

        case divider_state is 
            when IDLE_state =>

                enable_out <='0';
                if enable_in='1' then
                    divider_state   <= A_state;
                    numerator_stored   <= unsigned(numerator);
                    denominator_stored  <= unsigned(denominator);
                    counter         <= to_unsigned(IN_WIDTH-1,counter'length);
                    r <= (others=>'0');
                    busy <= '1';
                else
                    busy <= '0';
                end if;
                
            when A_state =>

                divider_state <= B_state;
                -- R:= R<<1 
                -- R(0) := N(I)
                tmp := to_integer(counter);
                r <= r(r'left-1 downto 0) & numerator_stored(tmp);

            when B_state =>

                --if R ≥ D then
                --    R := R − D
                --    Q(i) := 1
                --end
                if r >= resize(denominator_stored,r'length) then
                    r <= r-resize(denominator_stored,r'length);
                    quotient(tmp) <= '1';
                else
                    quotient(tmp) <= '0';  
                end if;
                
                if counter=to_unsigned(0,counter'length) then
                    divider_state <= IDLE_STATE; 
                    enable_out <= '1'; 
                else
                    divider_state <= A_state;  
                    counter <= counter-1;
                end if;

            when others =>
                divider_state <= IDLE_state;

        end case;

    end if;
end process;

reminder <= std_logic_vector(r(reminder'left downto 0));

end rtl;