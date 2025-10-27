module counter #(
    parameter WIDTH = 8
)(
    // interface signals
    input logic clk,
    input logic rst,
    input logic en,
    input logic [WIDTH-1:0] incr,  // Step size
    output logic [WIDTH-1:0] count
);

always_ff @(posedge clk) 
if (rst) count <= {WIDTH{1'b0}};
else if (en) count <= count + incr;  // Add incr value each step
// else count stays the same

endmodule

