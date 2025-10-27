module sinegen(
    input logic [7:0] incr,
    input logic rst,
    input logic en,
    input logic clk,
    output logic [7:0] dout 
);

logic [7:0] counter_address;

counter my_counter(
    .clk(clk),
    .rst(rst),
    .en(en),
    .incr(incr),
    .count(counter_address)
);

rom my_rom(
    .clk(clk),
    .addr(counter_address),
    .dout(dout)
);

endmodule
