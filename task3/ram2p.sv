module ram2p #(
    parameter ADDRESS_WIDTH = 9,
              DATA_WIDTH = 8
)(
    input logic clk,
    input logic wr_en,
    input logic [ADDRESS_WIDTH-1:0] wr_addr,
    input logic [ADDRESS_WIDTH-1:0] rd_addr,
    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout
);

logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

// Initialize RAM to avoid reading undefined values
initial begin
    for (int i = 0; i < 2**ADDRESS_WIDTH; i++) begin
        ram_array[i] = 8'd128;  // Initialize to midpoint
    end
end

always_ff @(posedge clk) begin
    if (wr_en) begin
        ram_array[wr_addr] <= din;
    end
    dout <= ram_array[rd_addr];
end

endmodule