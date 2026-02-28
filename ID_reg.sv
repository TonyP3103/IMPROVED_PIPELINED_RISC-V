module ID_reg (
    input logic clk,
    input logic rstn,
    input logic stall_2_EX,
    input logic flush_2_EX,
    input logic [31:0]  i_pc_ID,
    input logic [31:0]  i_instr_ID,
    output logic [31:0] o_pc_ID,
    output logic [31:0] o_instr_ID
    );

    always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    o_pc_ID <= 32'd0;
    o_instr_ID <= 32'd0;
end else if (stall_2_EX) begin
    o_pc_ID    <= o_pc_ID   ;
    o_instr_ID <= o_instr_ID;
end else begin
    o_pc_ID    <= flush_2_EX ? 32'd0 : i_pc_ID   ;
    o_instr_ID <= flush_2_EX ? 32'd0 : i_instr_ID;
end
end
endmodule
