-- Cosine and sine generator from a quarter period stored in a LUT

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity sin_cos_lut is
    generic (
        phase_in_size               : integer:=4096; -- must be a power of 2
        phase_in_bit_size           : integer:=12; -- phase quantization 
        sin_cos_data_size           : integer:=16 -- amplitude quantization
    );
port(
    clk                             : in std_logic;
    rst                             : in std_logic;
    
    phase_in_en                     : in std_logic;
    phase_in                        : in std_logic_vector(phase_in_bit_size-1 downto 0);  
    
    sin_out                         : out std_logic_vector(sin_cos_data_size-1 downto 0);
    cos_out                         : out std_logic_vector(sin_cos_data_size-1 downto 0);
    sin_out_en                      : out std_logic

 );
end entity sin_cos_lut;

architecture rtl of sin_cos_lut is

type sin_cos_table_type                 is array(0 to phase_in_size/4-1) of unsigned(sin_cos_data_size-1 downto 0);  
signal sin_table                        : sin_cos_table_type;

signal phase_in_for_sin_en              : std_logic; 
signal phase_in_for_sin                 : std_logic_vector(phase_in_bit_size-1 downto 0); 
signal phase_in_for_cos                 : std_logic_vector(phase_in_bit_size-1 downto 0); 
signal phase_in_for_sin_d1              : std_logic_vector(phase_in_bit_size-1 downto 0); 
signal phase_in_for_sin_d2              : std_logic_vector(phase_in_bit_size-1 downto 0); 
signal phase_in_for_cos_d1              : std_logic_vector(phase_in_bit_size-1 downto 0); 
signal phase_in_for_cos_d2              : std_logic_vector(phase_in_bit_size-1 downto 0); 

signal phase_recalc_sin                 : unsigned(phase_in_bit_size-1-2 downto 0);  
signal phase_recalc_cos                 : unsigned(phase_in_bit_size-1-2 downto 0);  
signal phase_recalc_sin_en              : std_logic;
signal sin_table_out                    : unsigned(sin_cos_data_size-1 downto 0);
signal cos_table_out                    : unsigned(sin_cos_data_size-1 downto 0);
signal sin_table_out_en                 : std_logic;

signal sin_out_int                      : std_logic_vector(sin_cos_data_size-1 downto 0);
signal cos_out_int                      : std_logic_vector(sin_cos_data_size-1 downto 0);
signal sin_out_en_int                   : std_logic;

begin

------------------------------------------                                                           
-- sin 1/4 period Look Up Table generation                                                             
------------------------------------------ 
-- sin_table is implemented inside a Ram block on Altera/Intel devices
sin_table_generation: 
for I in 0 to phase_in_size/4-1 generate
    sin_table(I) <= to_unsigned(integer(ROUND(real(2**(sin_cos_data_size-1)-1) * SIN( real(I) / real(phase_in_size/4) * real(1.5707963267948966192313216916398)))),sin_cos_data_size);
end generate sin_table_generation;

------------------------------------------                                                           
-- sin cos main process                                                            
------------------------------------------ 
sin_cos_lut_integration_pr: process(clk, rst)
variable v_phase_in_for_sin_cos_case : std_logic_vector(1 downto 0);
begin
    if rst='1' then
    
        phase_in_for_sin_en     <= '0';
        phase_in_for_sin        <= (others=>'0');
        phase_in_for_cos        <= (others=>'0');
        phase_in_for_sin_d1     <= (others=>'0');
        phase_in_for_sin_d2     <= (others=>'0');
        phase_in_for_cos_d1     <= (others=>'0');
        phase_in_for_cos_d2     <= (others=>'0');
        phase_recalc_sin        <= (others=>'0');
        phase_recalc_cos        <= (others=>'0');
        phase_recalc_sin_en     <= '0';
        sin_table_out           <= (others=>'0');
        cos_table_out           <= (others=>'0');
        sin_table_out_en        <= '0';
        sin_out_int             <= (others=>'0');  
        cos_out_int             <= (others=>'0');   
        sin_out_en_int          <= '0';
        cos_out                 <= (others=>'0');
        sin_out                 <= (others=>'0');
        sin_out_en              <= '0';
        
    elsif rising_edge(clk) then
        
        ------------------------------------------                                                           
        -- PIPE 1                                                
        ------------------------------------------ 
        --First delay the phase
        phase_in_for_sin     <= phase_in;
        phase_in_for_cos     <= std_logic_vector(unsigned(phase_in)+phase_in_size/4);
        phase_in_for_sin_en  <= phase_in_en;

        ------------------------------------------                                                           
        -- PIPE 2                                                
        ------------------------------------------ 
        --The phase input is split into 4 quadrans for sin
        --MSBs: "00" / Use directly the value from table for sinus
        --MSBs: "01" / Table index = phase_max/4-1 - index
        --MSBs: "10" / Table index = index(-2 downto 0) *-1
        --MSBs: "11" / Table index = index(-2 downto 0) *-1

        -- Sin phase recalc
        v_phase_in_for_sin_cos_case := phase_in_for_sin(phase_in_bit_size-1 downto phase_in_bit_size-2);
        case v_phase_in_for_sin_cos_case is  
            when "00" =>
                phase_recalc_sin <= unsigned(phase_in_for_sin(phase_in_bit_size-3 downto 0));
            when "01" =>
                phase_recalc_sin <= phase_in_size/4-1 - unsigned(phase_in_for_sin(phase_in_bit_size-3 downto 0));
            when "10" =>
                phase_recalc_sin <= unsigned(phase_in_for_sin(phase_in_bit_size-3 downto 0));
            when "11" =>
                phase_recalc_sin <= phase_in_size/4-1 - unsigned(phase_in_for_sin(phase_in_bit_size-3 downto 0));
            when others =>
        end case;
        
        -- Cos phase recalc
        v_phase_in_for_sin_cos_case := phase_in_for_cos(phase_in_bit_size-1 downto phase_in_bit_size-2);
        case v_phase_in_for_sin_cos_case is  
            when "00" =>
                phase_recalc_cos <= unsigned(phase_in_for_cos(phase_in_bit_size-3 downto 0));
            when "01" =>
                phase_recalc_cos <= phase_in_size/4-1 - unsigned(phase_in_for_cos(phase_in_bit_size-3 downto 0));
            when "10" =>
                phase_recalc_cos <= unsigned(phase_in_for_cos(phase_in_bit_size-3 downto 0));
            when "11" =>
                phase_recalc_cos <= phase_in_size/4-1 - unsigned(phase_in_for_cos(phase_in_bit_size-3 downto 0));
            when others =>
        end case;
        phase_recalc_sin_en <= phase_in_for_sin_en;
        phase_in_for_sin_d1 <= phase_in_for_sin;
        phase_in_for_cos_d1 <= phase_in_for_cos;

        ------------------------------------------                                                           
        -- PIPE 3                                                
        ------------------------------------------ 
        -- Data from table is read
        if phase_recalc_sin_en='1' then
            for I in 0 to phase_in_size/4-1 loop
                if unsigned(phase_recalc_sin)=to_unsigned(I,phase_in_bit_size-2) then
                    sin_table_out <= sin_table(I);
                end if;
            end loop;
            for I in 0 to phase_in_size/4-1 loop
                if unsigned(phase_recalc_cos)=to_unsigned(I,phase_in_bit_size-2) then
                    cos_table_out <= sin_table(I);
                end if;
            end loop;
        end if;
        phase_in_for_sin_d2 <= phase_in_for_sin_d1;
        phase_in_for_cos_d2 <= phase_in_for_cos_d1;
        sin_table_out_en <= phase_recalc_sin_en;
        
        ------------------------------------------                                                           
        -- PIPE 4                                                
        ------------------------------------------ 
        -- Data polarity from table is reordered
        v_phase_in_for_sin_cos_case := phase_in_for_sin_d2(phase_in_for_sin_d2'left downto phase_in_for_sin_d2'left-1);
        case v_phase_in_for_sin_cos_case is  
            when "00" =>
                sin_out_int <= std_logic_vector(sin_table_out);
            when "01" =>
                sin_out_int <= std_logic_vector(sin_table_out);
            when "10" =>
                sin_out_int <= std_logic_vector(not(unsigned(sin_table_out))+1);
            when "11" =>
                sin_out_int <= std_logic_vector(not(unsigned(sin_table_out))+1);
            when others =>
                sin_out_int <= sin_out_int;
        end case;
        v_phase_in_for_sin_cos_case := phase_in_for_cos_d2(phase_in_for_cos_d2'left downto phase_in_for_cos_d2'left-1);
        case v_phase_in_for_sin_cos_case is  
            when "00" =>
                cos_out_int <= std_logic_vector(cos_table_out);
            when "01" =>
                cos_out_int <= std_logic_vector(cos_table_out);
            when "10" =>
                cos_out_int <= std_logic_vector(not(unsigned(cos_table_out))+1);
            when "11" =>
                cos_out_int <= std_logic_vector(not(unsigned(cos_table_out))+1);
            when others =>
                cos_out_int <= cos_out_int;
        end case;
        sin_out_en_int <= sin_table_out_en;

        ------------------------------------------                                                           
        -- PIPE 5                                                
        ------------------------------------------ 
        sin_out     <= sin_out_int;
        cos_out     <= cos_out_int;
        sin_out_en  <= sin_out_en_int;

    end if;
end process;


end rtl;