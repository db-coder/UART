
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rx_uart is
    Port ( sys_clk : in  STD_LOGIC;  
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;   -- receiving_port
           rx_data: out  STD_LOGIC_VECTOR (7 downto 0);  -- final output
				rx_valid: out std_logic
			  );
end rx_uart;

architecture Behavioral of rx_uart is

Type RX_FSM is (Idle,Receiving);


signal count : STD_LOGIC_VECTOR(8 downto 0) := (others=>'0'); 
signal sampling_count: STD_LOGIC_VECTOR(3 downto 0) := (others=>'0'); 
signal sample: STD_LOGIC_VECTOR(3 downto 0) := (others=>'0'); 

signal rx_bit_count : STD_LOGIC_VECTOR(3 downto 0):= (others=>'0'); 
signal next_rx_bit_count : STD_LOGIC_VECTOR(3 downto 0):= (others=>'0'); 

signal tmp_tx :STD_LOGIC_VECTOR (7 downto 0):=(others=>'0'); 
signal next_tmp_tx :STD_LOGIC_VECTOR (7 downto 0):=(others=>'0'); 

signal temp_rx_data:STD_LOGIC_VECTOR (7 downto 0);
signal next_temp_rx_data:STD_LOGIC_VECTOR (7 downto 0);

signal temp_rx_valid: std_logic := '0';
signal next_temp_rx_valid: std_logic := '0';

signal reset_flag : std_logic := '0';
signal RPS,RNS : RX_FSM:=Idle;

begin

process (sys_clk)
begin
if rising_edge(sys_clk) then
	rps<=rns;
	rx_bit_count<=next_rx_bit_count;
	tmp_tx<=next_tmp_tx;
	temp_rx_valid<=next_temp_rx_valid;
	temp_rx_data<=next_temp_rx_data;
end if;
end process;


COUNTER:Process(sys_clk,rst)
begin
if rising_edge(sys_clk) then
	reset_flag <= '0';
	if rst='1' then
		sampling_count <= "0000";
		count <= "000000000";
		reset_flag <= '1';
	else
		count <= count + '1';
		if count = "101000101" then
			count<= "000000000";
			if sampling_count = "1111" then
				sampling_count <= "0000" ;
				sample <= "0000" ;
			else
				sampling_count <= sampling_count + '1' ;
				if rx = '1' then
					sample <= sample + '1' ;
				end if;
			end if;			
		end if;
	end if;
end if;
end Process COUNTER;



REC:Process(sampling_count,rst,rps)
begin
	RNS<=RPS;
	next_rx_bit_count<=rx_bit_count;
	next_tmp_Tx<=tmp_tx;
	next_temp_rx_valid<=temp_rx_valid;
	next_temp_rx_Data<=temp_rx_data;
	if reset_flag = '1' then
		rns<= IDLE;
	else
	case RPS is
		when Idle =>
			next_temp_rx_valid<='0';
			next_rx_bit_count <= (others=>'0') ;
			if sampling_count = "1111" then
				if sample < "1000" then
					RNS <= Receiving;
				end if;
			end if;
			
		when Receiving =>
		
			if sampling_count = "1111" then
				next_rx_bit_count <= rx_bit_count + '1';			---doubt
				if sample < "1000" then
					next_tmp_tx <= tmp_tx(6 downto 0) & '0';
					RNS <= Receiving;
				else
					if rx_bit_count = "1001" then
						next_temp_rx_valid <= '1';
						RNS <= Idle ;
						next_temp_rx_data <= tmp_tx ;
					else
						next_tmp_tx <= tmp_tx(6 downto 0) & '1';
						rns <= receiving;
					end if;
				end if;
			end if;
	end case;
end if;
end Process REC;

rx_valid<=temp_rx_valid;
rx_data <= temp_rx_data;
end Behavioral;