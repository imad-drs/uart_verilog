`timescale 1ns / 1ps

module tb_uart_system();

    // 1. Declare virtual wires and registers to plug into our system
    reg clk;
    reg rst;
    reg wr_enb;
    reg [7:0] data_in;
    
    wire tx_pin;
    wire rdy;
    wire [7:0] data_out;
    
    // The Loopback: We use the tx_pin wire as the input for rx_pin!
    wire rx_pin = tx_pin; 

    // 2. Instantiate the system we just built (The "Device Under Test")
    uart_system uut (
        .clk(clk),
        .rst(rst),
        .wr_enb(wr_enb),
        .rx_pin(rx_pin),
        .data_in(data_in),
        .tx_pin(tx_pin),
        .rdy(rdy),
        .data_out(data_out)
    );

    // 3. Generate a fake Clock (toggles every 5 nanoseconds)
    always #5 clk = ~clk;

    // 4. The Test Sequence (The script of what to do)
    initial begin
        // Tell the simulator to record the waveforms so we can see them
        $dumpfile("uart_waves.vcd");
        $dumpvars(0, tb_uart_system);

        // --- STEP 1: Initialization ---
        clk = 0;
        rst = 1;         // Hold the reset button down
        wr_enb = 0;
        data_in = 8'b0;
        
        #100;            // Wait for 100 nanoseconds
        rst = 0;         // Let go of the reset button
        #100;
        
        // --- STEP 2: Send a Message ---
        // Let's send the binary pattern 10100101 (Hex: A5)
        data_in = 8'b10100101; 
        
        // Pulse the write enable flag for exactly one clock cycle
        wr_enb = 1;
        #10; 
        wr_enb = 0;
        
        // --- STEP 3: Wait and Verify ---
        // Now we wait for the receiver's 'rdy' flag to pop up!
        // Because UART is slow, this will take tens of thousands of clock cycles.
        wait(rdy == 1'b1);
        
        // Wait just a little bit longer so we can see the end of the waveform
        #1000;
        
        // Check if the received data matches what we sent
        if (data_out == 8'b10100101) begin
            $display("SUCCESS! The receiver caught the correct data: %b", data_out);
        end else begin
            $display("FAILED! The receiver caught: %b", data_out);
        end

        // End the simulation
        $finish;
    end

endmodule