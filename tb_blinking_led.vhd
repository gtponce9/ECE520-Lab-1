
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_blinking_led is
end tb_blinking_led;

architecture Behavioral of tb_blinking_led is

    component blinking_led is
        port (
           sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led_en : in STD_LOGIC;
           led_out : inout STD_LOGIC
        );
     end component;
     
     constant CLK_PERIOD : time := 12.5 ns; -- 125MHz Clock
     signal sys_clk_tb : STD_LOGIC := '1';
     signal rst_tb : STD_LOGIC;
     signal led_en_tb : STD_LOGIC := '0';
     signal led_out_tb : STD_LOGIC := '0';
     
begin

  ------------------------------------------------------------------------------
  -- Free running clock from the board
  ------------------------------------------------------------------------------
  clk_process : process
  begin
    sys_clk_tb <= '0';
    wait for CLK_PERIOD/2;
    sys_clk_tb <= '1';
    wait for CLK_PERIOD/2;
  end process;


  ------------------------------------------------------------------------------
  -- Device Under Test
  ------------------------------------------------------------------------------
  DUT : blinking_led
    port map(
      sys_clk   => sys_clk_tb,
      rst => rst_tb,
      led_en => led_en_tb,
      led_out  => led_out_tb
      );
      
 ------------------------------------------------------------------------------
  -- Test Cases
 ------------------------------------------------------------------------------    
      
   test_case: process
   begin
 ------------------------------------------------------------------------------
   -- TEST CASE 0: RESET FOR THE FIRST 5 CLOCK CYCLES
 ------------------------------------------------------------------------------

   rst_tb <= '1';
   wait for CLK_PERIOD * 5; -- reset is high for the first 5 clock cycles
   rst_tb <= '0';
   report "RESET COMPLETE";
   
   led_en_tb <= '1';
   wait for CLK_PERIOD * 2; -- Little wait time so I don't drive the reset high again immediately
   
  ------------------------------------------------------------------------------
   -- TEST CASE 1: RESET BEHAVIOR
   -- START SIMULATION WITH RESET = 1 AND LED_EN = 0
  ------------------------------------------------------------------------------
   
   rst_tb <= '1';
   led_en_tb <= '0';
   
   wait for CLK_PERIOD * 5;
   
   ------------------------------------------------------------------------------
   -- TEST CASE 2: DISABLE OUTPUT
   -- SET SIMULATION WITH RESET = 0 AND LED_EN = 0
  ------------------------------------------------------------------------------
   
   rst_tb <= '0';
   led_en_tb <= '0';
   
   wait for CLK_PERIOD * 5;
   
   ------------------------------------------------------------------------------
   -- TEST CASE 3: LED TOGGLING
   -- SET SIMULATION WITH RESET = 0 AND LED_EN = 1
  ------------------------------------------------------------------------------
   
   rst_tb <= '0';
   led_en_tb <= '1';
   
    wait for 1000 ns;
  end process;
   
      
end Behavioral;
