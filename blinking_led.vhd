
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blinking_led is


generic (
CLK_CYCLES_PER_TOGGLE: natural:= 62500000
);


    Port ( sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led_en : in STD_LOGIC;
           led_out : out STD_LOGIC := '0'
           );
end blinking_led;

architecture Behavioral of blinking_led is

signal counter: integer:= 0; -- counter signal for the "if" statement
signal output: std_logic := '0'; -- used to map to led_out after process

begin

led_out <= output;

process (sys_clk)
begin
    if rising_edge(sys_clk)then                        -- using rising edge to have a synchronous reset
        if rst = '1' or led_en = '0' then              -- turn off the led and reset the counter to 0 on rst or when enable is 0
        counter <= 0;
        output <= '0';
        
        elsif led_en ='1' then
            if counter = CLK_CYCLES_PER_TOGGLE - 1 then -- if we are at the generic value up top, then
            output <= not output;                       -- invert the output (toggle the LED)
            counter <= 0;                               -- reset the counter OR
            else counter <= counter + 1;                -- keep counting until you reach the generic value
            end if;
        end if;
     end if;
  
end process;

end Behavioral;
