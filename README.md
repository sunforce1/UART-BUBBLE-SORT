# UART-BUBBLE-SORT

In this project, I have implemented an UART protocol on an Xilinx Spartan-6 LX45 FPGA. The UART protocol has 2 functionalities in built:
1. When the FPGA receives a byte through UART, it shows the byte on the leds of the board
2. When the FPGA received 8 bytes through UART, it is sorting the characters based on their binary ascii code and resends them to the terminal
   sorted in ascending order.
