module IF_reg (
    input logic clk,
    input logic rstn,
    input logic stall_2_ID,
    input logic flush_2_ID,
    input logic [31:0]  i_pc_IF,
    input logic [31:0]  i_instr_IF,
    output logic [31:0] o_pc_IF,
    output logic [31:0] o_instr_IF,
    output logic        insn_vld_ID
    );

    always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    o_pc_IF <= 32'd0;
    o_instr_IF <= 32'd0;
    insn_vld_ID <= 1'b0;
end else if (stall_2_ID) begin
    o_pc_IF    <= o_pc_IF   ;
    o_instr_IF <= o_instr_IF;
    insn_vld_ID <= insn_vld_ID;
end else begin
    o_pc_IF    <= flush_2_ID ? 32'd0 : i_pc_IF   ;
    o_instr_IF <= flush_2_ID ? 32'd0 : i_instr_IF;
    insn_vld_ID <= flush_2_ID ? 1'b0 : 1'b1;
end
end
endmodule
