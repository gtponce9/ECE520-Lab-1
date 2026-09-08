# ECE520-Lab-1
Garrett Ponce

Led Blinker + RGB Blinker

## Project Abstract

Blinking LED's using a Zybo-20 board,  2023.2 Version of Vivado, and VHDL code. first code, Blinking_led.vhd is a single LED blinking when a switch enables it. RGB_led.vhd extends on this with 3 LED's controller by independant switches. Both programs run as intended and have testbenches to prove logic and demos will be done in person. I messed up on committing everything with the same comment. Still learning GitHub.

## Hardware
- Zynq - 7020 Development Board
- 1 USB cable
- Windows 10 Computer with software installed

## Software
- Vivado 2023.2
- VHDL 2000

## Prelab Code

### Blinking LED
The blinking LED ran off a 125MHz clock, and toggled after a counter reached CLK_CYCLES_PER_TOGGLE-1 clock cycles. For simulation, we set the CLK_CYCLES_PER_TOGGLE to 10, to allow quick debugging, but for hardware implementation, we set CLK_CYCLES_PER_TOGGLE to 62500000. If we divide the CLK_CYCLES_PER_TOGGLE at the hardware value by the clock frequency, the LED toggles every 0.5 seconds, toggling twice within a second. 

The condition for the counter to be active, were that the reset value had to be low ('0') and the enable (led_en) had to be high ('1') for the entire count. if the counter reached it's value of CLK_CYCLES_PER_TOGGLE-1, then the LED output (led_out) would toggle high until the counter reached CLK_CYCLES_PER_TOGGLE-1 again, where it would then toggle low. If the enable went low, or the reset went high, the counter would go back to 0, and the led_out would be forced back low. This was all done inside of a process using a clock synchronous reset. the code can be found in the blinking_led.vhd file with comments explaining each step.
  
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

The Blinking LED is instantiated into the testbench, and these test cases are conducted successfully. Please look at Figure 1 below for the waveform diagram below

![Figure 1: Blinking LED Simulation Waveform](https://github.com/gtponce9/ECE520-Lab-1/blob/1b9acd945958761f486f524b1bd6b442dd3d36b7/Lab_1_Simulation_Waveform_Blinking_LED.png)

Click the photo to get a better resolution. Where the red rectangle is, you can see test case 3, where the LED toggles on and off and then when reset is low and led enable is high. The counter also clearly shoes the toggling occuring at CLK_CYCLES_PER_TOGGLE-1 = 9.

### Blinking LED Hardware Implementation

To run the program on the Zybo, I had to reinstall my drivers so that my hardware manager could locate my board (this happened in 420 so this was pretty quick to figure out)

**CLK_CYCLES_PER_TOGGLE := 62500000**

A constraint file was found here on GitHub, and adjusted to the following
clock -> Sys_Clk (125 MHz)
Switch 0 -> led_en
Button 0 -> rst
LED 0 -> led_out

Demo will be shown in lab

## Post lab Code

### RGB LED
The post lab code expands on the pre lab code by having 3 LED's indepentantly working off switches on the board. The Blinking_led.vhd file was instantiated onto the rgb_led_top.vhd file, so the counter, reset, enable and output still follow the same rules. The top level now has 3 bit switch (sw) input and a 3 bit RGB output (rgb_out). Each bit on the rgb_out is assigned as the following:
- rgb_out[0] = Red
- rgb_out[1] = Green
- rgb_out[2] = Blue

The top level now runs a concurrent "when" statement that assigns the led_en <= '1' "001" (switch 0), "010" (switch 1), "100" (switch 2), and all other scenario's to led_en <= '0';. The blinking_led program now knows the start the counter when these switches are active to allow toggling, assuming reset is low

the top level then runs a sequential case statement that assigns the each bit of the rgb_out to led_out. This allows us to type match std_logic_vector to std_logic, allowing only 1 led to function at a time. If I wanted more LED's to run at the same time, I would need more std_logic output pins, or to convert led_out to std_logic_vector. 

### RGB LED Testbench
The testbench runs through 5 test scenario's after cycling reset for 5 clock cycles

**CLK_CYCLES_PER_TOGGLE := 5**

 **TEST 1: ALL INACTIVE SWITCHES: All switch conditions except the following, 001, 010, 100**
 
 - Led_En will be 0 the entire time
 - RGB_Out will be 0

 **TEST 2:ACTIVE SWITCHES WITH HIGH RESET: Switch conditions 001, 010, 100 with reset = 1**
 
 - Led_En will be 1
 - RGB_out will be 0

  
 **TEST 3: INTERMITANT RESET: Switch conditions 001, 010, 100 with reset = 1 at the 6th clock cycle**
 
 - Led_En will be 1
 - RGB_out will be 1 for 1 clcok cycle and then it will be reset, should it should be a 1 cycle spike

 
 **TEST 4: ONLY ACTIVE SWITCHES: Switch conditions 001, 010, 100 with reset = 0**
 
 - Led_En will be 1
 - RGB_out will be 1

 **TEST 5: FULL TEST: Switch conditions 000, 001, 010, 011, 100, 101, 110, 111 with reset = 0**
 
 - Led_En will be 1 and 0
 - RGB_out will be 1 and 0

The Figure shown below captures each test

![Figure 1: Blinking LED Simulation Waveform](https://github.com/gtponce9/ECE520-Lab-1/blob/1b9acd945958761f486f524b1bd6b442dd3d36b7/Lab_1_Simulation_Waveform_RGB%20LED.png)



## Overview

Had to run though my old textbook (Circuit Design with VHDL by Volnei A. Pedroni - Fantastic Book, highly recommend), plus my ECE 420 notes, because it's been a year since I last coded. I had a lot of troubleshooting to do, both on the code and the hardware (driver issue as mentioned earlier). This was a great lab to reintroduce me to the subject, and I'm glad I got this lab completed pretty hassle free

