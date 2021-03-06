library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
PORT(
SYS_CLK: IN STD_LOGIC;
rst: in STD_LOGIC;
RX: IN STD_LOGIC;
TX:OUT STD_LOGIC;

TX_DATA: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
TX_DATA_VALID: IN STD_LOGIC;
RX_DATA: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
RX_VALID: OUT STD_LOGIC
);
end TOP;

architecture Behavioral of TOP is

component tx_uart
port(
			sys_clk : in std_logic;
			CLK: IN STD_LOGIC;
			SWITCH: in STD_LOGIC;
			DATA: IN STD_LOGIC_VECTOR(7 downto 0);
			TRANSMISSION_PORT: out STD_LOGIC
			--CLK_FEEDBACK: out std_logic
);
end component;

component rx_uart
Port ( 
			  sys_clk : in  STD_LOGIC;  
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;   -- receiving_port
           rx_data: out  STD_LOGIC_VECTOR (7 downto 0);
			  rx_valid: out std_logic
			  );
end component;

component clock_gen
port(
			clk: in std_logic;
			baud: out std_logic
			--clk_in:in std_logic
);
end component; 
signal s2: std_logic:='0';
signal s1: std_logic:='0';
signal s4: std_logic:='0';
signal s5: std_logic_vector (7 downto 0) := (OTHERS=>'0');
begin

clock1: clock_gen port map(
		clk=>sys_clk,
		baud=>s1
		--clk_in=>s2
);

Transmitter: tx_uart port map(
	sys_clk=>sys_clk,
	clk =>s1,
	switch=>tx_data_valid,											-----------------change to s4 for loopback
	data=>tx_data,														-----------------change to s5 for loopback
	transmission_port=>TX
	
);



Receiver: rx_uart port map(
			  sys_clk => sys_clk,
           rst=>rst,
           rx =>rx,
				rx_data => rx_data,									-----------------------change to s5 for loopback 
			  rx_valid => rx_valid					       		-----------------------change to s4 for loopback
			  
);


end Behavioral;

