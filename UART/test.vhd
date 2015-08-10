--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:20:45 04/12/2015
-- Design Name:   
-- Module Name:   C:/Users/Anmol/Desktop/UART_v2/UART/test.vhd
-- Project Name:  UART
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART
    PORT(
         CLK : IN  std_logic;
         SWITCH : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         TRANSMISSION_PORT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal SWITCH : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal TRANSMISSION_PORT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          CLK => CLK,
          SWITCH => SWITCH,
          DATA => DATA,
          TRANSMISSION_PORT => TRANSMISSION_PORT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
   		DATA <= "10101011";
		SWITCH <= '1';

      -- insert stimulus here 

      wait;
   end process;

END;
