module rom #(
    parameter ADDRESS_WIDTH = 8,
              DATA_WIDTH = 8
)(
    input logic clk,
    input logic [ADDRESS_WIDTH - 1:0] addr,
    output logic [DATA_WIDTH - 1:0] dout
);

logic [DATA_WIDTH - 1:0] rom_array [2**ADDRESS_WIDTH - 1:0];

initial begin
    $display("Loading rom.");
    $readmemh("sinerom.mem", rom_array);
end;

always_ff @ (posedge clk)
    dout <= rom_array [addr];

endmodule

/*This is a ROM module that stores pre-defined data that can be read but not modified. We input an address 
and the output will be the value stored at that address. There are two key parameters, AW which holds 256 
memory locations and DW which shows that each location holds 1 byte.

Line 10 - creates 256 locations with each storing a byte of information
Line 14 - Loads data from sinerom.mem into ROM
Line 17 - This is a clocked loop, on each clock cycle the output is updated with thee rom_array[addr] or 
rather the data stored from the addressed location.  Since this is a synchronous system, the output will
appear on the next clock edge.*/


