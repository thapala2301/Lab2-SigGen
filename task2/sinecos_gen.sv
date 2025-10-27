module sinecos_gen(
    input logic [7:0] incr,
    input logic rst,
    input logic en,
    input logic clk,
    input logic [7:0] phase_offset,  // From VBuddy rotary encoder
    output logic [7:0] dout1,
    output logic [7:0] dout2
);

logic [7:0] counter_address;
logic [7:0] offset_address;

counter my_counter(
    .clk(clk),
    .rst(rst),
    .en(en),
    .incr(incr),
    .count(counter_address)
);

// Calculate offset address (automatic 8-bit wrap-around)
assign offset_address = counter_address + phase_offset;

rom_dual my_rom(
    .clk(clk),
    .addr1(counter_address),
    .addr2(offset_address),
    .dout1(dout1),
    .dout2(dout2)
);

endmodule
