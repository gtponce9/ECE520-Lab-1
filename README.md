# ECE520-Lab-1
Garrett Ponce

Led Blinker + RGB Blinker

## Project Abstract

Blinking LED's using a Zybo-20 board,  2023.2 Version of Vivado, and VHDL code. first code, Blinking_led.vhd is a single LED blinking when a switch enables it. RGB_led.vhd extends on this with 3 LED's controller by independant switches. Both programs run as intended and have testbenches to prove logic and demos will be done in person. I messed up on committing everything with the same comment. Still learning GitHub.

## Hardware
- Zynq - 7020 Development Board
- 1 USB cable

## Software
- Vivado 2023.2
- VHDL 2000

## Prelab Code

### Blinking LED
The blinking LED ran off a 125MHz clock, and toggled after a counter reached CLK_CYCLES_PER_TOGGLE-1 clock cycles. For simulation, we set the CLK_CYCLES_PER_TOGGLE to 5, to allow quick debugging, but for hardware implementation, we set CLK_CYCLES_PER_TOGGLE to 62500000. If we divide the CLK_CYCLES_PER_TOGGLE at the hardware value by the clock frequency, the LED toggles every 0.5 seconds, toggling twice within a second. The condition for the counter to be active, were that the reset value had to be low ('0') and the enable (led_en) had to be high ('1') for the entire count. if the counter reached it's value of CLK_CYCLES_PER_TOGGLE-1, then the LED output (led_out) would toggle high until the counter reached CLK_CYCLES_PER_TOGGLE-1 again, where it would then toggle low. If the enable went low, or the reset went high, the counter would go back to 0, and the led_out would be forced back low.
  
### Blinking LED Testbench
The testbench for the blinking LED runs through 3 tests after cycling reset for 5 clock cycles
- Test Case 1 – Reset Behavior

Start the simulation with rst = 1 and led_en = 0

Verify that led_out = 0 during reset and that the counter is held at 0

- Test Case 2 – Disabled Output

Deassert reset (rst = 0) but keep led_en = 0

Verify that led_out = 0 and that the counter is 0 while disabled

- Test Case 3 – LED Toggling

Verify that led_out toggles once every 10 rising edges of sys_clk

Also show that led_out becomes 1->0 when led_en = 0

The Blinking LED is instantiated into the testbench, and these test cases are conducted successfully. Please look at Figure 1 below for the waveform diagram 

![Figure 1: Blinking LED Simulation Waveform]("C:\Xilinx\ECE_520\Lab_1\Lab_1_Simulation_Waveform_Blinking_LED.png")


