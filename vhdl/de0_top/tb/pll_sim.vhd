LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pll IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		    : OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END pll;


ARCHITECTURE SYN OF pll IS

begin


END SYN;

