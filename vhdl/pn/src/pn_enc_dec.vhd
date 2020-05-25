library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity pn_enc_dec is
    generic (
              bit_size      : integer:=8
    );
 port (
            clk             : in std_logic;
            rst_n             : in std_logic;
     
            enc_data_in     : in std_logic_vector(bit_size-1 downto 0);
            enc_data_in_en  : in std_logic;
            enc_data_out    : out std_logic_vector(bit_size-1 downto 0);
            enc_data_out_en : out std_logic;
    
            dec_data_in     : in std_logic_vector(bit_size-1 downto 0);
            dec_data_in_en  : in std_logic;
            dec_data_out    : out std_logic_vector(bit_size-1 downto 0);
            dec_data_out_en : out std_logic
 );
end entity pn_enc_dec;

architecture rtl of pn_enc_dec is

signal p1_enc_data_out_en : std_logic;
signal p1_enc_data_out    : std_logic_vector(bit_size-1 downto 0);

signal p1_dec_data_out_en : std_logic;
signal p1_dec_data_out    : std_logic_vector(bit_size-1 downto 0);

begin

--template_pr: process(clk, rst_n)
--begin
--    if rst_n='1' then
--    elsif rising_edge(clk) then
--    end if;
--end process;

enc_pr: process(clk, rst_n)
variable v_tmp                : std_logic;
variable v_out_tmp            : std_logic; 
variable v_out                : std_logic; 
variable v_out_enc_table      : std_logic_vector(bit_size-1 downto 0); 
variable v_shift_reg_enc      : std_logic_vector(31 downto 1);
begin
    if rst_n='0' then
        v_tmp                :='0';
        v_out_tmp            :='0';    
        v_out                :='0';    
        v_out_enc_table      := (others=>'0');  
        v_shift_reg_enc      := (others=>'0');
        
        p1_enc_data_out_en   <= '0';   
        p1_enc_data_out      <= (others=>'0');     

        enc_data_out_en      <= '0';
        enc_data_out         <= (others=>'0'); 
        
    elsif rising_edge(clk) then
    
        if enc_data_in_en='1' then
            for I in 0 to bit_size-1 loop
                v_tmp := enc_data_in(I);
                v_out_tmp := v_shift_reg_enc(23) xor v_shift_reg_enc(18);
                v_out := v_tmp xor v_out_tmp;
                v_out_enc_table(I) := v_out;
                v_shift_reg_enc(31 downto 2) := v_shift_reg_enc(30 downto 1);
                v_shift_reg_enc(1) := v_out;
            end loop;
        end if;
        
        p1_enc_data_out_en <= enc_data_in_en;
        p1_enc_data_out    <= v_out_enc_table;
        
        enc_data_out_en <= p1_enc_data_out_en;
        enc_data_out    <= p1_enc_data_out;
        
    end if;
end process;

dec_pr: process(clk, rst_n)
variable v_tmp                : std_logic;
variable v_out_tmp            : std_logic; 
variable v_out                : std_logic; 
variable v_out_dec_table      : std_logic_vector(bit_size-1 downto 0); 
variable v_shift_reg_dec      : std_logic_vector(31 downto 1);
begin
    if rst_n='0' then
        v_tmp                :='0';
        v_out_tmp            :='0';    
        v_out                :='0';    
        v_out_dec_table      := (others=>'0');  
        v_shift_reg_dec      := (others=>'0');
        
        p1_dec_data_out_en   <= '0';   
        p1_dec_data_out      <= (others=>'0');     

        dec_data_out_en      <= '0';
        dec_data_out         <= (others=>'0'); 
        
    elsif rising_edge(clk) then
    
        if dec_data_in_en='1' then
            for I in 0 to bit_size-1 loop
                v_tmp := dec_data_in(I);
                v_out_tmp := v_shift_reg_dec(23) xor v_shift_reg_dec(18);
                v_out := v_tmp xor v_out_tmp;
                v_out_dec_table(I) := v_out;
                v_shift_reg_dec(31 downto 2) := v_shift_reg_dec(30 downto 1);
                v_shift_reg_dec(1) := v_tmp;
            end loop;
        end if;
        
        p1_dec_data_out_en <= dec_data_in_en;
        p1_dec_data_out    <= v_out_dec_table;
        
        dec_data_out_en <= p1_dec_data_out_en;
        dec_data_out    <= p1_dec_data_out;
        
    end if;
end process;

end rtl;