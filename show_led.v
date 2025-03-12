// 
// Module: show_led
// 
// Notes:
// - show_led module, takes input a byte and shows it on the 8 leds of the fpga
// - shows the same byte untill the led_enabled is high again
//

module show_led(
		input clk,
	   input led_enabled,
		input [7:0]byte_to_be_shown,
		output reg [7:0]led
    );
	 
	 reg [7:0] byte_copy = 0; // copy of the byte that is shown
	 
	 always @(posedge clk) begin
		if (led_enabled) begin
			byte_copy <= byte_to_be_shown;
		end
		
		
		led <= byte_copy; // led is the copy of the byte untill led_enabled is high again and its value changes
		
	 end

endmodule