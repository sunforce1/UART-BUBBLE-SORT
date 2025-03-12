// 
// Module: UART_transmitter
// 
// Notes:
// - UART transmitter module, uses BAUD rate of 115200, no parity bit, no flow control.
// - can send 8 bits, 1 start and 1 stop bit.
//
module UART_transmitter
	#(parameter clks_per_bit = 868)
	(	
	input clk,  // top level system clock input, 100 mhz
	input [63:0]output_array,  // bytes to be transmitted back to terminal
	input bytes_are_received,	// signal that bytes are ready to be sent
	output reg uart_tx,	// uart transmit pin
	output reg transmission_active	// if transmission is active
   );
		
		 // states of FSM
	    parameter IDLE = 3'b000;
		 parameter IDLE_WHEN_SENDING_BYTES = 3'b001;
		 parameter START = 3'b010;
		 parameter DATA = 3'b011;
		 parameter STOP = 3'b100;
		 
		 
		 reg [24:0]counter; // counter, 1 bits length is 868 clock cycles
		 reg [2:0]state_machine = 0; //state machine register
		 reg [2:0]output_index = 0; // index used for bits counter in a byte
		 reg [2:0]output_byte = 0; // index used for byte counter in 8 bytes
		 
		 
		 always @(posedge clk) begin
			case(state_machine)
			
			
			// IDLE state, waits for the input signal to start sending the 8 bytes
			IDLE: 
			begin
				uart_tx <= 1'b1;
			
				counter <=0;
				output_index <= 0;
				output_byte <= 0;
				
				if (bytes_are_received) begin
					transmission_active <= 1'b1;
					state_machine <= START;
				end else begin
					state_machine <= IDLE;
				end
			end
			
			// IDLE_WHEN_SENDING_BYTES state, idle state for 1 clock cycle
         //	between the 8 bytes that have to be sent
			IDLE_WHEN_SENDING_BYTES:
			begin
			   uart_tx <= 1'b1;
				counter <=0;
				output_index <= 0;
				
				state_machine <= START;
			end
			
			// START state, sends 0 bit for clks_per_bit - 1
			START:
			begin
				uart_tx <= 1'b0;
				
				if (counter == clks_per_bit - 1) begin
					
					counter <= 1'b0;
					state_machine <= DATA;
				
				end else begin
					counter <= counter + 1'b1;
					state_machine <= START;
				end
			
			end
			
			// DATA state, starts sending the actual byte
			DATA:
			begin
				uart_tx <= output_array[output_byte * 8 + output_index]; // output byte is the byte number (from 0..7) that is currently
				// sending and output_index is the index of the bit that is currently sending in the byte.
				
				
				if (counter == clks_per_bit - 1) begin
					counter <= 1'b0;
					
					if (output_index < 7) begin
						
						output_index <= output_index + 1'b1;
						state_machine <= DATA;
					end else begin
						output_index <= 1'b0;
						state_machine <= STOP;
					end
				end else begin
					counter <= counter + 1'b1;
					state_machine <= DATA;
				
				end
			
				
			end
			
			// STOP state, sends the STOP byte (which is high), return to IDLE_WHEN_SENDING_BYTES when
			// there are more bytes to be sent from the array, or to IDLE when all the 8 bytes have been sent
			STOP:
			
			begin
				
				uart_tx <= 1'b1;
				
				
				if (counter == clks_per_bit - 1) begin
					
					counter <= 1'b0;
					state_machine <= IDLE;
					
					if (output_byte < 7) begin
						
						output_byte <= output_byte + 1'b1;
						transmission_active <= 1'b1;
						state_machine <= IDLE_WHEN_SENDING_BYTES;				
					end else begin
						output_byte <= 1'b0;
						state_machine <= IDLE;
						transmission_active <= 1'b0;
					end
					
				
				end else begin
					counter <= counter + 1'b1;
					state_machine <= STOP;
				end
			
			
			end
			
			
			endcase
		 
		 end
	 


endmodule