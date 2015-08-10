
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
port(

clk: in std_logic;
Input_Valid: in std_logic;
res: out std_logic
);
end debounce;

architecture Behavioral of debounce is

TYPE SWITCH_TYPE is (IDLE, PRESSED , RELEASED);
signal count1 : std_logic_vector(25 downto 0):= (OTHERS=>'0');
signal temp : std_logic;
Signal SWITCH_PRES, SWITCH_NEXT : SWITCH_TYPE:=IDLE;

begin
process(clk)
begin
	if rising_edge(clk) then
		SWITCH_PRES <= SWITCH_NEXT;
	end if;
end process;

process(count1,switch_pres,input_valid,temp,clk)
begin
		case SWITCH_PRES is
		
		when IDLE =>
		
			temp <= '0';
			count1 <= (OTHERS =>'0');
			if(Input_Valid = '0') then
				SWITCH_NEXT <= IDLE;
			else
				SWITCH_NEXT <= PRESSED;
			end if;
			
		when PRESSED => 
			if(input_valid='0' and count1(3)='0') then
				SWITCH_NEXT <= IDLE;
				count1 <=(OTHERS=>'0');
			elsif (count1(3) = '1') then
				SWITCH_NEXT <=RELEASED;
			else
				SWITCH_NEXT <=PRESSED;
				if rising_edge(clk) then
					count1 <= count1 + '1';
					temp <= '0';
				end if;
			end if;
		
		when RELEASED =>	
			if(Input_Valid = '1') then 
				SWITCH_NEXT <= RELEASED;
			else
				SWITCH_NEXT <= IDLE;
				temp <= '1';
				count1 <= (OTHERS=>'0');
			end if;
		end Case;
		res <= temp;
		
end process;

end Behavioral;

