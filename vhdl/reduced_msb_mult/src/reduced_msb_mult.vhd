library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.reduced_msb_mult_pkg.all;

entity reduced_msb_mult is
generic(
    G_USE_ASYNC_RESET    :  boolean:=TRUE;
    G_USE_SYNC_RESET     :  boolean:=TRUE;
    G_ASYNC_RESET_ACTIVE :  std_logic:='1';
    G_SYNC_RESET_ACTIVE  :  std_logic:='1';
    G_KERNEL_SIZE        :  integer:=12;
    G_DATA_WIDTH         :  integer:=32;
    G_USER_WIDTH         :  integer:=32
);
port(
    clock       : in std_logic;
    async_reset : in std_logic;
    sync_reset  : in std_logic;
    data_in     : in data_array;
    signs_in    : in std_logic_vector(G_KERNEL_SIZE-1 downto 0);
    valid_in    : in std_logic;
    data_out    : out std_logic_vector(G_DATA_WIDTH-1 downto 0);
    valid_out   : out std_logic;
    user_in     : in std_logic_vector(G_USER_WIDTH-1 downto 0);
    user_out    : out std_logic_vector(G_USER_WIDTH-1 downto 0)
);
end entity;

architecture rtl of reduced_msb_mult is

signal mult_result_array                : data_array;
signal mult_result_array_en             : std_logic;
signal mult_result_array_array_delays   : data_array_array;
signal mult_result_array_array_delays_en: std_logic;
signal add_results                      : data_array;
signal add_results_en                   : std_logic_vector(G_KERNEL_SIZE-1 downto 0);

type user_array_type is array (0 to C_MAX_NB_ELEMENTS-1) of std_logic_vector(G_USER_WIDTH-1 downto 0);
signal user_array                       : user_array_type;

begin

G_MULT_GEN: for I in 0 to G_KERNEL_SIZE-1 generate
    mult_result_array(I) <= data_in(I) when signs_in(I)='0' else std_logic_vector(not(signed(data_in(I)))+1);
end generate;

mult_result_array_en <= valid_in;

main_pr: process(clock, async_reset)     
begin                               
    if (async_reset=G_ASYNC_RESET_ACTIVE) and (G_USE_ASYNC_RESET=true) then
        for I in 0 to G_KERNEL_SIZE-1 loop
            add_results(I) <= (others=>'0');
            for J in 0 to G_KERNEL_SIZE-1 loop
                mult_result_array_array_delays(I)(J) <= (others=>'0');
            end loop;
        end loop;
        mult_result_array_array_delays_en <= '0';
        add_results_en <= (others=>'0');
        user_array <= (others=>(others=>'0'));
        user_out <= (others=>'0');
    elsif rising_edge(clock) then  
        if (sync_reset=G_SYNC_RESET_ACTIVE) and (G_USE_SYNC_RESET=true) then
            for I in 0 to G_KERNEL_SIZE-1 loop
                add_results(I) <= (others=>'0');
                for J in 0 to G_KERNEL_SIZE-1 loop
                    mult_result_array_array_delays(I)(J) <= (others=>'0');
                end loop;
            end loop;
            mult_result_array_array_delays_en <= '0';
            add_results_en <= (others=>'0');
            user_array <= (others=>(others=>'0'));
            user_out <= (others=>'0');
        else
        
            -- Pipe1
            mult_result_array_array_delays_en <= mult_result_array_en;
        
            -- Others delays pipes
            for I in 0 to G_KERNEL_SIZE-1 loop
            
                -- Initialize the delay array of mult results
                if I=0 then
                    for J in 0 to G_KERNEL_SIZE-1 loop
                        mult_result_array_array_delays(0)(J) <= mult_result_array(J);
                    end loop;
                else -- Delays all mult resuts
                    for J in 0 to G_KERNEL_SIZE-1 loop
                        mult_result_array_array_delays(I)(J) <= mult_result_array_array_delays(I-1)(J);
                    end loop;
                end if;
                
                -- Compute additions
                if I=0 then
                    add_results(I) <= mult_result_array_array_delays(0)(I);
                else
                    add_results(I) <= std_logic_vector(signed(add_results(I-1)) + signed(mult_result_array_array_delays(I)(I)));
                end if;
                
                
            end loop;
            
            -- Pipe2
            add_results_en(0) <= mult_result_array_array_delays_en;
            add_results_en(G_KERNEL_SIZE-1 downto 1) <= add_results_en(G_KERNEL_SIZE-2 downto 0);
            
            -- Pipe3
            data_out <= add_results(G_KERNEL_SIZE-1)(G_DATA_WIDTH-1 downto 0);
            valid_out <= add_results_en(G_KERNEL_SIZE-1);

            -- User delay
            
            user_array(0) <= user_in;
            user_array(1 to G_KERNEL_SIZE) <= user_array(0 to G_KERNEL_SIZE-1);

            user_out <= user_array(G_KERNEL_SIZE);
            
        end if;
    end if;                         
end process;


end rtl;
