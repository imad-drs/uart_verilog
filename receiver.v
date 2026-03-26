module receiver(
    input clk, rst, rx, rx_enb,  //rx is the serial input, rx_enb is the enable signal from the baud rate generator
	output reg[7:0] data_out, // the final parallel output after receiving the 8 bits of data
	output reg rdy // ready signal (indicates thata data is ready when rdy=1)
    );
	
    localparam idle_state = 2'b00;
	localparam start_state = 2'b01;
    localparam data_state = 2'b10;
	localparam stop_state = 2'b11;

	reg [1:0] state = idle_state; // current state of the receiver FSM
	reg [2:0] index; // index to keep track of which bit of the data is being received (0 to 7)
	reg [7:0] data; // register to hold the data being received
	reg [3:0] tick_count; // counts from 0 o 15 to keep track of the baud rate ticks (16 ticks per bit)

	always@(posedge clk) begin 
		if (rst) begin 
			state <= idle_state;
			data_out <= 0;
			index <= 0;
			tick_count <= 0;
			rdy <= 0;
			data <= 0;
		end else begin 
			rdy <= 0;

			if(rx_enb) begin 
				case (state) 
				idle_state: begin 
                    if (rx == 0) begin // start bit detected
						state <= start_state;
						tick_count <= 0;
					end else begin 
						state <= idle_state;
					end
				end
				
				start_state: begin 
                        if (tick_count == 4'd7) begin // middle of the start bit
                            if (rx == 1'b0) begin // confirm start bit is still low
                                state <= data_state;
                                tick_count <= 4'b0;
                                index <= 3'b0;
                            end else begin 
                                state <= idle_state; // false start bit, go back to idle
                            end 
                        end else begin 
                            tick_count <= tick_count + 1'b1;
                        end
                end

				data_state: begin 
					if (tick_count == 4'd15) begin // end of the current data bit
						data[index] <= rx; // sample the data bit
						if (index == 3'h7) begin // last data bit received
							state <= stop_state;
						end else begin 
							index <= index + 1;
						end
						tick_count <= 0;
					end else begin 
						tick_count <= tick_count + 1;
					end
				end

				stop_state: begin 
					if (tick_count == 4'd15) begin // end of the stop bit
						if (rx == 1) begin // confirm stop bit is high
							data_out <= data; // output the received data
							rdy <= 1; // indicate data is ready
						end 
						state <= idle_state; 
					end else begin 
						tick_count <= tick_count + 1;
					end
				end

				endcase
			end
		end
	end
	
endmodule 