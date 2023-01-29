--
--  Code from wiki page:
--
--      typedef unsigned int uint;
--      
--      // This function converts an unsigned binary number to reflected binary Gray code.
--      uint BinaryToGray(uint num)
--      {
--          return num ^ (num >> 1); // The operator >> is shift right. The operator ^ is exclusive or.
--      }
--      
--      // This function converts a reflected binary Gray code number to a binary number.
--      uint GrayToBinary(uint num)
--      {
--          uint mask = num;
--          while (mask) {           // Each Gray code bit is exclusive-ored with all more significant bits.
--              mask >>= 1;
--              num   ^= mask;
--          }
--          return num;
--      }


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray is
generic(
    DATA_WIDTH               :integer:= 10
);
port (
    data_to_encode_in        : in std_logic_vector(DATA_WIDTH-1 downto 0);
    data_to_decode_in        : in std_logic_vector(DATA_WIDTH-1 downto 0);

    data_to_encode_out       : out std_logic_vector(DATA_WIDTH-1 downto 0);
    data_to_decode_out       : out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end gray;

architecture rtl of gray is

constant zeros_const  : std_logic_vector(DATA_WIDTH-1 downto 0):=(others=>'0');
signal shift_register : std_logic_vector(DATA_WIDTH-1 downto 0);

function get_gray_decode(data_in : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
variable tmp        : std_logic_vector(DATA_WIDTH-1 downto 0);
variable tmp2       : std_logic_vector(DATA_WIDTH-1 downto 0);
variable last_iter  : integer:=0;
begin

    tmp         := data_in;
    tmp2        := tmp;
    last_iter   := 0;

    for k in 1 to DATA_WIDTH loop  
        if last_iter=0 then                                                        
            tmp2 := '0' & tmp2(tmp2'left downto 1);
            tmp := tmp xor tmp2;
            if tmp2=zeros_const then
                last_iter:=1;
            end if;
        end if;
    end loop;

    return tmp;
end function;


begin

-----------------------------------------------------------------
-- Gray encoder
-----------------------------------------------------------------

--Shift (data_to_encode_in considered UNSIGNED)
shift_register <= '0' & data_to_encode_in(data_to_encode_in'left downto 1);

--Xor
data_to_encode_out <= data_to_encode_in xor shift_register;


-----------------------------------------------------------------
-- Gray Decoder
-----------------------------------------------------------------
data_to_decode_out <= get_gray_decode(data_to_decode_in);

end rtl;