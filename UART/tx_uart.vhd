library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TX_UART is
Port(
sys_clk : in std_logic;
CLK: IN STD_LOGIC;
SWITCH: in STD_LOGIC;
DATA: IN STD_LOGIC_VECTOR(7 downto 0);
TRANSMISSION_PORT: out STD_LOGIC
);
end TX_UART;
architecture Behavorial of TX_UART is
--
--component debounce 
--port(
--
--clk: in std_logic;
--Input_Valid: in std_logic;
--res: out std_logic
--);

--end component;


signal counter : STD_LOGIC_VECTOR(4 downto 0) := (OTHERS=>'0');



Type TX_STATE_TYPE is (IDLE, BUSY, START, STOP);
Signal TX_PS : TX_STATE_TYPE := IDLE;
Signal TX_NS : TX_STATE_TYPE := IDLE;
--signal debouncer_temp : std_logic;
signal temp_stop : std_logic:='0';
signal index: std_logic_vector(2 downto 0):= "111";
signal tx_strt : std_logic:='0';

signal out_signal:std_logic := '1';
signal next_out_signal:std_logic := '1';

signal flag: std_logic := '0';
signal next_flag: std_logic := '0';

signal temp_start: std_logic := '0';
signal next_temp_start: std_logic := '0';


begin

--debouncer: debounce port map(
--	clk => clk,
--	Input_Valid=>SWITCH,
--	res=> debouncer_temp
--);

process (sys_CLK)
begin
if rising_edge(sys_CLK) then
	--if clk = '1' then	------------------------
		TX_PS <= TX_NS;
		out_signal <= next_out_signal;
		flag <= next_flag;
		temp_start<=next_temp_start;
--	end if;
end if;
end process;

Process(switch,TX_PS,DATA,clk,temp_stop,index )
begin	
	TX_NS<=TX_PS;
	next_out_signal <= out_signal;
	next_flag <= flag;
	next_temp_start<= temp_start;
	
	
	tx_strt<='0';
--	TX_NS <= IDLE;
	if(switch = '1') then
		next_flag <= '1';
	end if;
--	if clk = '1' then
		case TX_PS is
		when IDLE =>
			next_out_signal <= '1';
--			if(switch = '1') then
--				flag <= '1';
--			end if;
			if clk = '1' and flag = '1' then	---------------------doubt
				next_flag <= '0';
				next_temp_start <= '1';
			end if;
			if temp_start = '1' then
				TX_NS <= START;
			end if;
			
		when START =>
			next_out_signal<='0';
			next_temp_start <= '0';
			if(clk='1') then
				TX_NS<=BUSY;
			end if;
			
		when BUSY =>
			tx_strt<='1';
			
			if(temp_stop='1') then
				TX_NS<=STOP;
				--out_signal <= '1';
			else
				next_out_signal <= DATA(conv_integer(INDEX));
			end if;
		
		when STOP =>
			next_out_signal<='1';
			if(clk='1') then
				TX_NS<=IDLE;
			end if;
		end case;	
	
--	else 
--		if switch = '1' then
--			flag<='1';
--		end if;
--	
--	end if;
	
	
end process;

process(sys_clk)
begin
if rising_edge(sys_clk) then
	temp_stop<='0';
	if(conv_integer(INDEX) > 0 ) then
		if clk='1' and tx_strt='1' then
			INDEX <= INDEX - '1';
		end if;
	else
		if clk = '1' and tx_strt='1' then
			temp_stop<='1';
			INDEX <= "111";
		end if;
	end if;
end if;
end process;	

TRANSMISSION_PORT <= out_signal;

end Behavorial;

