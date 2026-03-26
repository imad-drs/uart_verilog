module uart_system(
    input clk, rst, wr_enb, rx_pin,
    input [7:0] data_in,
    output tx_pin, rdy,
    output [7:0] data_out   
    );

    wire tx_tick;
    wire rx_tick;

    baud_rate_generator baud_gen_inst (
        .clk(clk),
        .rx_enb(rx_tick),
        .tx_enb(tx_tick)
    );
    
    transmitter tx_inst (
        .clk(clk),
        .wr_enb(wr_enb),
        .rst(rst),
        .data_in(data_in),
        .tx(tx_pin),
        .enb(tx_tick)
    );

    receiver rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx_pin),
        .rx_enb(rx_tick),
        .data_out(data_out),
        .rdy(rdy)
    );

endmodule