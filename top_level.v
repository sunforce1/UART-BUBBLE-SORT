// 
// Module: top_level
// 
// Notes:
// - Top level module to be used in an implementation.
// - Includes uart receive and transmitter module
// - Has 2 functionalities with the bits received from uart:
//   1. every byte received from uart is shown  as binary on the fpga leds
//	  2. when it receives 8 bytes, it sorts them ascending using bubble sort and echos them back to terminal.
//

module top_level
	(
	   input  clk,		//top level system clock input
		input  uart_rx,	  //uart receive pin
		output uart_output, //uart transmit pin
		output  [7:0]led_output // led output of ascii byte characters
    );
	 
	 
	 wire clk_ibufg;
    wire clk_int;
    IBUFG clk_ibufg_inst (.I(clk), .O(clk_ibufg));
    BUFG clk_bufg_inst (.I(clk_ibufg), .O(clk_int));
	 
	 // transmission of a byte
	 wire rx_done_tick;
	 wire [7:0] rx_data_out;
	 
	 // transmitting active
	 wire is_transmitting_active;
	 wire uart_transmitting_output;
	 
	 //transmission of 8 bites
	 wire [63:0] eight_bytes_received;
	 wire  bytes_received;
	 
	 // the 8 bytes sorted using bubble sort
	 wire [63:0] sorted_array_bubble;
	 wire is_array_sorted;

	 
	 //
	 // UART Receiver module.
    //
	 UART_RECEIVER UART_rc (
		 .clk(clk_int) , 
		 .comp_signal(uart_rx), 
		 .byte_is_received(rx_done_tick), 
		 .byte_received(rx_data_out), 
		 .eight_bytes_received(eight_bytes_received), 
		 .bytes_are_received(bytes_received)
	 );
	 
	 //
	 // Bubblesort module.
    //
	 BUBBLESORT bubble (
		 .clk(clk_int), 
		 .array_to_be_sorted(eight_bytes_received), 
		 .bytes_are_received(bytes_received), 
		 .sorted_array(sorted_array_bubble), 
		 .array_is_sorted(is_array_sorted)
	 );
	 
	 //
	 // UART Transmitter module.
    //
	 UART_transmitter UART_tr (
		.clk(clk_int), 
		.output_array(sorted_array_bubble), 
		.bytes_are_received(is_array_sorted), 
		.uart_tx(uart_transmitting_output) , 
		.transmission_active(is_transmitting_active)
	);
	 
	 assign uart_output = is_transmitting_active? uart_transmitting_output : 1'b1;
	 
	 //
	 //Led showing module.
    //
	 show_led led (
		.clk(clk_int), 
		.led_enabled(rx_done_tick), 
		.byte_to_be_shown(rx_data_out), 
		.led(led_output)
	);
	
	
endmodule