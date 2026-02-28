module PC (
input logic [31:0] i_pc,
output logic [31:0] o_pc
);

adder_32_bit adder_32bit_inst   (  .a(i_pc),
                                    .b(32'd4),
                                    .cin(1'b0),
                                    .sum(o_pc),
                                    .G(),
                                    .P(),
                                    .cout(),
                                    .overflow());

endmodule 
