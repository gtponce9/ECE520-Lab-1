
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_rgb_led_top is
end tb_rgb_led_top;

architecture Behavioral of tb_rgb_led_top is

component rgb_led_top is
    Port ( sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sw : in std_logic_vector (2 downto 0);
           rgb_out : out std_logic_vector (2 downto 0));
end component;


constant CLK_PERIOD : time := 12.5 ns; -- 125MHz Clock
signal sys_clk_tb: std_logic;
signal rst_tb :STD_LOGIC;
signal sw_tb :std_logic_vector (2 downto 0) := "000";
signal rgb_out_tb :std_logic_vector (2 downto 0);

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
  -- rbg_led_top Instantiation
  ------------------------------------------------------------------------------
  
DUT: rgb_led_top

port map (

sys_clk => sys_clk_tb,
rst     => rst_tb,
sw      => sw_tb,
rgb_out => rgb_out_tb
);


------------------------------------------------------------------------------
  -- Testing
------------------------------------------------------------------------------

test_case : process
begin

 ------------------------------------------------------------------------------
 --RESET FOR THE FIRST 5 CLOCK CYCLES
 ------------------------------------------------------------------------------

   rst_tb <= '1';
   wait for CLK_PERIOD * 5; -- reset is high for the first 5 clock cycles
   rst_tb <= '0';
   wait for CLK_PERIOD;
   report "RESET COMPLETE";
   
 ------------------------------------------------------------------------------
 -- README: Clock Cycles per toggle is currently 5
 -- TEST 1: ALL INACTIVE SWITCHES: All switch conditions except the following, 001, 010, 100
 -- Led_En will be 0 the entire time
 -- RGB_Out will be 0
 ------------------------------------------------------------------------------ 
 
    sw_tb <= "000";
    wait for CLK_PERIOD * 10;
    sw_tb <= "011";
    wait for CLK_PERIOD * 10;
    sw_tb <= "101";
    wait for CLK_PERIOD * 10;
    sw_tb <= "110";
    wait for CLK_PERIOD * 10; 
    sw_tb <= "111";
    wait for CLK_PERIOD * 10; 
  ------------------------------------------------------------------------------
 -- README: Clock Cycles per toggle is currently 5
 -- TEST 2:ACTIVE SWITCHES WITH HIGH RESET: Switch conditions 001, 010, 100 with reset = 1
 -- Led_En will be 1
 -- RGB_out will be 0
 ------------------------------------------------------------------------------
   rst_tb <= '1';
   sw_tb <= "001";
   wait for CLK_PERIOD * 10;
   sw_tb <= "010";
   wait for CLK_PERIOD * 10; 
   sw_tb <= "100";
   wait for CLK_PERIOD * 10;
  ------------------------------------------------------------------------------
 -- README: Clock Cycles per toggle is currently 5
 -- TEST 3: INTERMITANT RESET: Switch conditions 001, 010, 100 with reset = 1 at the 6th clock cycle
 -- Led_En will be 1
 -- RGB_out will be 1 for 1 clcok cycle and then it will be reset, should it should be a 1 cycle spike
 ------------------------------------------------------------------------------
   rst_tb <= '0';
   sw_tb <= "001";
   wait for CLK_PERIOD * 6;
   rst_tb <= '1';
   wait for CLK_PERIOD;
   rst_tb <= '0';
   sw_tb <= "010";
   wait for CLK_PERIOD * 6;
   rst_tb <= '1';
   wait for CLK_PERIOD;
   rst_tb <= '0';
   sw_tb <= "100";
   wait for CLK_PERIOD * 6;
   rst_tb <= '1';
   wait for CLK_PERIOD;
   rst_tb <= '0';

 ------------------------------------------------------------------------------
 -- README: Clock Cycles per toggle is currently 5
 -- TEST 4: ONLY ACTIVE SWITCHES: Switch conditions 001, 010, 100 with reset = 0
 -- Led_En will be 1
 -- RGB_out will be 1
 ------------------------------------------------------------------------------
   sw_tb <= "001";
   wait for CLK_PERIOD * 10;
   sw_tb <= "010";
   wait for CLK_PERIOD * 10;
   sw_tb <= "100";
   wait for CLK_PERIOD * 10;

 ------------------------------------------------------------------------------
 -- README: Clock Cycles per toggle is currently 5
 -- TEST 5: FULL TEST: Switch conditions 000, 001, 010, 011, 100, 101, 110, 111 with reset = 0
 -- Led_En will be 1 and 0
 -- RGB_out will be 1 and 0
 ------------------------------------------------------------------------------
   sw_tb <= "000";
   wait for CLK_PERIOD * 10;
   sw_tb <= "001";
   wait for CLK_PERIOD * 10;
   sw_tb <= "010";
   wait for CLK_PERIOD * 10;
   sw_tb <= "011";
   wait for CLK_PERIOD * 10;
   sw_tb <= "100";
   wait for CLK_PERIOD * 10;
   sw_tb <= "101";
   wait for CLK_PERIOD * 10;
   sw_tb <= "110";
   wait for CLK_PERIOD * 10;
   sw_tb <= "111";
   wait for CLK_PERIOD * 10;
 
end process;
end Behavioral;
