module baud_rate_generator(
    input clk, 
    output rx_enb, tx_enb
    );

    reg [12:0] tx_counter; // counts from 0 to 5207 to generate a tick every 5208 clock cycles (for 9600 baud rate with a 50 MHz clock)
    reg [9:0] rx_counter; // counts from 0 to 324 to generate a tick every 325 clock cycles (for 16 times the baud rate, which is 9600*16=153600 baud, with a 50 MHz clock)
    
    initial begin
        tx_counter = 13'b0;
        rx_counter = 10'b0;
    end

    // Transmitter Clock Divider (Standard Baud Rate)
    always @(posedge clk ) 
        begin
            if (tx_counter == 13'd5208) 
                tx_counter <= 0;
            else
                tx_counter <= tx_counter + 1'b1;
        end

    // Receiver Clock Divider (16x Baud Rate)
    always @(posedge clk ) 
        begin
            if (rx_counter == 10'd325) 
                rx_counter <= 0;
            else
                rx_counter <= rx_counter + 1'b1;
        end

    // Generate a 1-clock-cycle pulse when the counters hit 0
    assign tx_enb = (tx_counter == 0);
    assign rx_enb = (rx_counter == 0);

endmodule