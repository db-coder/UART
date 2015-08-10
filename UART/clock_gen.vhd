library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLOCK_GEN is
    Port (baud : out STD_LOGIC;
			 CLK : in STD_LOGIC
			 --clk_in: in std_logic
	 );
end CLOCK_GEN;

architecture Behavioral of CLOCK_GEN is
signal temp : STD_LOGIC := '0';
signal counter : STD_LOGIC_VECTOR(12 downto 0) := (OTHERS=>'0');
Type CLK_STATE_TYPE is (BUSY,IDLE);
signal ps,ns: clk_state_type := idle;

begin

process(clk)
begin
if(rising_edge(clk)) then
	ps<=ns;
end if;
end process;
--
--process(clk_in) 
--begin
--if(clk_in='1') then
--	ns <= busy;
--end if;
--end process;

baud<=temp;

process(ps,clk)
begin

case ps is
when busy=>
	if(rising_edge(CLK)) then
		if(counter = "1010001011000") then
			counter <= "0000000000001";
			temp<='1';
			ns<=idle;
		else
			counter <= counter + '1';
			temp <= '0';
		end if;
	end if;
when idle=>
	temp<='0';
	ns<=busy;
end case;

end process;

end Behavioral;
