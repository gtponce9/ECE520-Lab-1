
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rgb_led_top is
    Port ( sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sw : in std_logic_vector (2 downto 0);
           rgb_out : out std_logic_vector (2 downto 0));
end rgb_led_top;

architecture Behavioral of rgb_led_top is



------------------------------------------------------------
--Port Mapping Blinking Led Code to Top
------------------------------------------------------------
component blinking_led is

generic (
CLK_CYCLES_PER_TOGGLE: natural:= 62500000
);

    Port ( sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led_en : in STD_LOGIC;
           led_out : out STD_LOGIC := '0'
           );
end component;


signal led_en: std_logic;
signal led_out: std_logic;


begin

------------------------------------------------
-- instantiate led_blinking to top
------------------------------------------------
led_blinking_Instantiation: blinking_led
port map (
    sys_clk => sys_clk,
    rst => rst,
    led_en => led_en,
    led_out => led_out    
    );
 
 
------------------------------------------------
-- enables 1 switch at a time
-- when functions as a truth table, therefore the else statement takes care of the missing 5 entries
------------------------------------------------   
led_en <= '1' when (sw = "001") or
                   (sw = "010") or
                   (sw = "100")
              else '0';


process (sw, led_out)

begin

case sw is
------------------------------------------------
-- RGB = RED
------------------------------------------------
when "001" =>
    rgb_out(0) <= led_out;

------------------------------------------------
-- RGB = GREEN
------------------------------------------------
when "010" =>
    rgb_out(1) <= led_out;

------------------------------------------------
-- RGB = BLUE
------------------------------------------------
when "100" =>
    rgb_out(2) <= led_out;

------------------------------------------------
-- RGB = OFF ON ALL OTHER CONDITIONS
------------------------------------------------
when others =>
    rgb_out <= "000";

end case;

end process;

end Behavioral;
