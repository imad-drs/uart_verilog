module transmitter(
    input clk, wr_enb, enb, rst, // clk is the system clock, wr_enb is the write enable signal to start transmission, enb is the enable signal from the baud rate generator, rst is the reset signal
    input [7:0] data_in, // the 8-bit parallel data input to be transmitted
    output reg tx , // the serial output (tx=0 for start bit, tx=data bits, tx=1 for stop bit)
    output busy // indicates that the transmitter is busy transmitting data (busy=1 when transmitting, busy=0 when idle
    );

    localparam idle_state = 2'b00;
    localparam start_state = 2'b01;
    localparam data_state = 2'b10;
    localparam stop_state = 2'b11;

    reg [7:0] data; // register to hold the data being transmitted
    reg [2:0] index; // index to keep track of which bit of the data is being transmitted (0 to 7)
    reg [1:0] state = idle_state;
        
    always@(posedge clk)
        begin
            if (rst) begin
                state <= idle_state;
                tx <= 1'b1;
                index <= 3'h0;
            end 
            else begin 

            case(state)

            idle_state: begin
                tx <= 1'b1; // idle state, tx is high
                if(wr_enb) begin
                    state <= start_state;
                    data <= data_in;
                    index <= 3'b000;
                end else begin
                    state <= idle_state;
                end
            end

            start_state: begin
                if(enb) begin
                    tx <= 1'b0;
                    state <= data_state;
                end else begin
                    state <= start_state;
                end
            end

            data_state: begin
                if(enb) begin
                    tx <= data[index]; // transmit the current data bit

                    if (index == 3'h7) begin
                    state <= stop_state;
                    end else begin
                    index <= index + 1'b1;
                    end
                end
            end

            stop_state:
            begin
                if(enb)
                begin
                    tx <= 1'b1; // transmit the stop bit (high)
                    state <= idle_state;
                end
            end

            default: begin
            tx <= 1'b1;
            state <= idle_state;
            end
            
            endcase
            end
        end

    

    assign busy = (state != idle_state) ; // the transmitter is busy when it is in any state other than idle
endmodule




