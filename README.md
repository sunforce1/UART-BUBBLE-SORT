# UART-BUBBLE-SORT

In this project, I have implemented an UART protocol on an Xilinx Spartan-6 LX45 FPGA. The UART protocol has 2 functionalities in built:
1. When the FPGA receives a byte through UART, it shows the byte on the leds of the board
2. When the FPGA received 8 bytes through UART, it is sorting the characters based on their binary ascii code and resends them to the terminal
   sorted in ascending order

## UART protocol
The UART is an interface that sends out a byte over a single wire.  It does not forward a clock signal so it uses oversampling techniques in order retrieve the data in a correct way. I strongly recommend to check out Pong P. Chu's book for a nice explanation and UART design in Verilog and/or VHDL. This design of the UART uses a 100 mhz internal clock and 115200 baud rate in order to retrieve and transmit data. The data is 1 start bit, 1 byte and 1 stop bit, with no flow control or parity bits included. 
The UART consists of a receiver and transmitter, and as you could see in the code they are finite state machines with 4 states. Before you read my code, I would advise you to fully understand the protocol. Once you understand how the UART receiver works, the UART transmitter can be understood immediately, because it does the receiver's actions in a mirror :).

## Bubble Sort
Bubble Sort is a simple sorting algorithm that can be implemented in any programming language. In Verilog, for me, it was the easiest to implement using a finite state machine that has 4 states. This design of the algorithm supports sorting 8 bytes, which are characters in ascii code received by the UART receiver. If you do not understand the fsm, I strongly advise you to go through a full sort of an array (for example, 87654321 -> 12345678) on paper using the algorithm in order to fuuly grasp the idea of the FSM.

## Show Led
Show Led is a module that shows the binary number of every character received by the uart from terminal on leds. This was my initial project..
## The constraints file

## How to run the project
