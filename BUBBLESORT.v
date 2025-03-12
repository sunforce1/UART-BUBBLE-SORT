// 
// Module: BUBBLESORT 
// 
// Notes:
// - Bubble sort module, can sort an array of 8 bytes.
// - uses an FSM Implementation.
//

module BUBBLESORT(
		input clk, //// top level system clock input, 100 mhz
		input [63:0]array_to_be_sorted, // input of the array of 8 bytes to be sorted
		input bytes_are_received, // input signal when the array is ready to be sorted
		output reg [63:0] sorted_array, // sorted array
		output reg array_is_sorted //outpu signal when the array is sorted and ready to be sent
    );
	 
	    //states of the FSM
	    parameter IDLE = 3'b000;
		 parameter STORE_INPUT = 3'b001;
		 parameter BUBBLE_SORT = 3'b010;
		 parameter OUTPUT_READY = 3'b011;
	 
		
		reg [2:0]state_machine = 0; // fsm register
		reg [7:0] array [7:0]; // 2d array that needs to be sorted
		
		reg [2:0] index_i; // out loop index
		reg [2:0] index_j; // inner loop index
		
		reg [2:0]output_index; // index that is used when the array is stored
		reg [2:0]array_index; // index that is used when the array is sent
		
		
		always @(posedge clk) begin
		
			case (state_machine)
				
				//IDLE state, waits for array input
				IDLE:
				begin
					index_i <= 7;
					index_j <= 0;
					array_is_sorted <= 1'b0;
					output_index <=0;
					array_index <= 0;
					
					if (bytes_are_received) begin
						state_machine <= STORE_INPUT;
					end else begin
						state_machine <= IDLE;
					end
				end
				
				// STORE_INPUT state, stores the array input, 64 bits,  into 2D array,8 * 8 bits 
				STORE_INPUT:
				begin
				
				if (output_index < 7) begin
				
					array[output_index] <= array_to_be_sorted[8 * output_index +:8];
					output_index <= output_index + 1'b1;
					state_machine <= STORE_INPUT;
					
				end else if (output_index == 7) begin
					
					array[7] <= array_to_be_sorted[63:56];
					output_index <=0;
					array_index <= 0;
					state_machine <= BUBBLE_SORT;
					
				end
					
				end
			
			// BUBBLE_SORT state, sorts the 2D array using the bubble sort algorithm (index_i) represents
			// the outer loop and index_j the inner loop
			BUBBLE_SORT:
			begin
				if (index_i == 0) begin
					
					array_index <= 1'b0;
					state_machine <= OUTPUT_READY;
				
				end else if (index_i >= 1) begin
					
					if (index_j < index_i - 1'b1) begin
					
						if (array[index_j] > array[index_j + 1'b1]) begin
							//temp <= array[index_j];
							array[index_j] <= array[index_j + 1'b1];
							array[index_j + 1'b1] <= array[index_j];
						end
						
						index_j <= index_j + 1'b1;
					
					end else if (index_j == index_i - 1'b1) begin
					
						if (array[index_j] > array[index_j + 1'b1]) begin
						
							array[index_j] <= array[index_j + 1'b1];
							array[index_j + 1'b1] <= array[index_j];
						end
						
						index_j <= 0;
						index_i <= index_i - 1'b1;
					
					end
					
					state_machine <= BUBBLE_SORT;
			
				end
			
			end
			
			
			// OUTPUT_READY state, stores in output array the 2*d sorted array
			OUTPUT_READY:
			begin
			
			
				if (array_index < 7) begin
					
					sorted_array[8*array_index +: 8] <= array[array_index];
					array_index <= array_index + 1'b1;
					state_machine <= OUTPUT_READY;
					
				end else if (array_index == 7) begin
					sorted_array[63 : 56] <= array[7];
					array_index <= 1'b0;
					array_is_sorted <= 1'b1;
					state_machine <= IDLE;
				end
			
			
			end
			
			// default state, IDLE
			default:
				state_machine <= IDLE;
			
			endcase
		
		
		end


endmodule
