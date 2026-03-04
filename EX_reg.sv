module EX_reg (
    input logic clk,
    input logic rstn,
    input logic stall_2_MEM,
    input logic flush_2_MEM,
    input logic         i_RegWen_EX,
    input logic [ 1:0]  i_wb_select_EX,
    input logic [31:0]  i_ALU_EX,
    input logic [31:0]  i_pc_EX,
    input logic [31:0]  i_instr_EX,
    output logic [31:0] o_pc_EX,
    output logic [31:0] o_instr_EX,
    output logic        o_RegWen_EX,
    output logic [ 1:0] o_wb_select_EX,
    output logic [31:0] o_ALU_EX,

    input logic        PCsel,
    output logic        insn_vld_MEM,
    output logic        mispred_MEM,
    output logic        ctrl_MEM
    );

    always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    o_pc_EX         <= 32'd0;
    o_instr_EX      <= 32'd0;
    o_RegWen_EX     <=  1'd0;
    o_wb_select_EX  <=  2'd0;
    o_ALU_EX        <= 32'd0;
end else if (stall_2_MEM) begin
    o_pc_EX         <= o_pc_EX   ;
    o_instr_EX      <= o_instr_EX;
    o_RegWen_EX     <= o_RegWen_EX   ;
    o_wb_select_EX  <= o_wb_select_EX;
    o_ALU_EX        <= o_ALU_EX      ;
end else begin
    o_pc_EX         <= flush_2_MEM ? 32'd0 : i_pc_EX   ;
    o_instr_EX      <= flush_2_MEM ? 32'd0 : i_instr_EX;
    o_RegWen_EX     <= flush_2_MEM ?  1'd0 : i_RegWen_EX   ;
    o_wb_select_EX  <= flush_2_MEM ?  2'd0 : i_wb_select_EX;
    o_ALU_EX        <= flush_2_MEM ? 32'd0 : i_ALU_EX      ;
end
end


always_comb begin
    insn_vld_MEM    = !PCsel;      //When PCsel = 1 Flush activate
    mispred_MEM     = PCsel;
    ctrl_MEM        = PCsel;
end
endmodule
