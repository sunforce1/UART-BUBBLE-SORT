# UART-BUBBLE-SORT

In this project, I have implemented an UART protocol on an Xilinx Spartan-6 LX45 FPGA. The UART protocol has 2 functionalities in built:
1. When the FPGA receives a byte through UART, it shows the byte on the leds of the board
2. When the FPGA received 8 bytes through UART, it is sorting the characters based on their binary ascii code and resends them to the terminal
   sorted in ascending order

## UART protocol
The UART is an interface that sends out a byte over a single wire.  It does not forward a clock signal so it uses oversampling techniques in order retrieve the data in a correct way. I strongly recommend to check out Pong P. Chu's book for a nice explanation and UART design in Verilog and/or VHDL. This design of the UART uses a 100 mhz internal clock and 115200 baud rate in order to retrieve and transmit data. The data is 1 start bit, 1 byte and 1 stop bit, with no flow control or parity bits included. 


## Bubble Sort

## The constraints file

## How to run the project
