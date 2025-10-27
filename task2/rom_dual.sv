module rom_dual #(
    parameter ADDRESS_WIDTH = 8,
              DATA_WIDTH = 8
)(
    input logic clk,
    input logic [ADDRESS_WIDTH-1:0] addr1,  // First address
    input logic [ADDRESS_WIDTH-1:0] addr2,  // Second address (with offset)
    output logic [DATA_WIDTH-1:0] dout1,    // First output
    output logic [DATA_WIDTH-1:0] dout2     // Second output
);

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading dual-port rom.");
    $readmemh("sinerom.mem", rom_array);
end

always_ff @(posedge clk) begin
    dout1 <= rom_array[addr1];
    dout2 <= rom_array[addr2];
end

endmodule
