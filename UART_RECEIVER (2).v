// 
// Module: UART_RECEIVER 
// 
// Notes:
// - UART receiver module, uses BAUD rate of 115200, no parity bit, no flow control.
// - can receive 8 bits, 1 start and 1 stop bit.
//
module UART_RECEIVER
	#(parameter clks_per_bit = 868) // 10 ^ 7 / baud rate which is 9600
   ( 
	input wire clk,	// top level system clock input, 100 mhz
	input wire comp_signal, // uart receive pin
	output reg byte_is_received, // output signal when a single byte received
	output reg [7:0]byte_received, // the single byte received
	output reg [63:0]eight_bytes_received, // array of 8 continuous bytes received
	output reg bytes_are_received // output signal when 8 bytes are received
   );
		 
		 // states of FSM
		 parameter IDLE = 3'b000;
		 parameter START = 3'b001;
		 parameter DATA = 3'b010;
		 parameter STOP = 3'b011;
		 
		 reg [24:0]counter; // counter, 1 bits length is 868 clock cycles
		 reg [2:0]state_machine = 0; //state machine register
		 reg [2:0]output_index = 0; // index used for bits counter in a byte
		 reg [2:0] byte_index = 0;  // index used for byte counter in 8 bytes
		 
		 always@(posedge clk) begin
		 case(state_machine)
			
			//IDLE state, waits for a start bit
			IDLE: 
			begin
				counter <= 0;
				byte_is_received <= 0;
				output_index <= 0;
				bytes_are_received <= 0;
				
				if (comp_signal == 0) begin
					state_machine <= START;
				end else begin
					state_machine <= IDLE;
				
				end
			end
			
			// START state, identifies the start bit
			START:
			begin
			
				if (counter == ((clks_per_bit - 1)/ 2)) begin // middle of start bit
					if (comp_signal == 0) begin
						counter <= 0;
						state_machine <= DATA;
					end else begin
						state_machine <= IDLE;
					end
				end else begin
					counter <= counter + 1'b1;
					state_machine <= START;
				end
			
			end
			
			// DATA state, computes the byte received using oversampling
			DATA:
			begin
			
				if (counter == clks_per_bit - 1) begin
					
					counter <= 0;
					byte_received[output_index] <= comp_signal;
					
					if (output_index < 7) begin
						output_index <= output_index + 1'b1;
						state_machine <= DATA;
					
					end else begin
					
						state_machine <= STOP;
						output_index <= 0;
					end
					
					
				end else begin 
					counter <= counter + 1'b1;
					state_machine <= DATA;
				end
			
			end
			
			
			// STOP state, received STOP bit, and saves the received byte in an individual array of 8
			// or in an 8 byte array to be sent to the bubble sort module. 
			STOP:
			begin
			
			if (counter == clks_per_bit - 1) begin
				byte_is_received <= 1; // byte ready to be sent to show led module
				counter <= 0;
				state_machine <= IDLE;
				
				// save byte at the byte_index position in the array
				if (byte_index < 7) begin
					
					case (byte_index) 
							3'b000 : eight_bytes_received[7 : 0] <= byte_received;
							3'b001 : eight_bytes_received[15 : 8] <= byte_received;
							3'b010 : eight_bytes_received[23 : 16] <= byte_received;
							3'b011 : eight_bytes_received[31 : 24] <= byte_received;
							3'b100 : eight_bytes_received[39 : 32] <= byte_received;
							3'b101 : eight_bytes_received[47 : 40] <= byte_received;
							3'b110 : eight_bytes_received[55 : 48] <= byte_received;
					
					endcase
					byte_index <= byte_index + 1'b1;
				end else begin
					
					eight_bytes_received[63:56] <= byte_received;
					bytes_are_received <= 1'b1; // 8 bytes are received, ready to be sent to bubble sort module
					byte_index <= 0; //reset byte index
				end
			end else begin
				state_machine <= STOP;
				counter <= counter + 1'b1;
			end
			end
			
			
			default: 
				state_machine <= IDLE;
			
			
		 
		 endcase
		 
		 
		 end


	endmodule
	