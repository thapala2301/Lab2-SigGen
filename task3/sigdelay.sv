module sigdelay #(
    parameter ADDRESS_WIDTH = 9,
              DATA_WIDTH = 8
)(
    input logic clk,
    input logic rst,
    input logic en,
    input logic [ADDRESS_WIDTH-1:0] offset,
    input logic [DATA_WIDTH-1:0] mic_signal,
    output logic [DATA_WIDTH-1:0] delayed_signal
);

logic [ADDRESS_WIDTH-1:0] write_address;
logic [ADDRESS_WIDTH-1:0] read_address;

// Counter for write address (0 to 511)
always_ff @(posedge clk) begin
    if (rst)
        write_address <= {ADDRESS_WIDTH{1'b0}};
    else if (en)
        write_address <= write_address + 1;
end

// Read address with proper circular buffer calculation
// This ensures we always get valid addresses 0-511
assign read_address = (write_address >= offset) ? 
                     (write_address - offset) : 
                     (512 + write_address - offset);

// Dual-port RAM
ram2p my_ram (
    .clk(clk),
    .wr_en(en),
    .wr_addr(write_address),
    .rd_addr(read_address),
    .din(mic_signal),
    .dout(delayed_signal)
);

endmodule