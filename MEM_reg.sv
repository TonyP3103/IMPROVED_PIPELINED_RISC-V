module MEM_reg (
    input logic clk,
    input logic rstn,
    input logic stall_2_WB,
    input logic flush_2_WB,
    input logic i_RegWen_MEM,
    input logic [31:0]  i_wb_data_MEM,
    input logic [31:0]  i_pc_MEM,
    input logic [31:0]  i_instr_MEM,
    output logic        o_RegWen_MEM,
    output logic [31:0] o_pc_MEM,
    output logic [31:0] o_wb_data_MEM,
    output logic [31:0] o_instr_MEM,


    input logic        insn_vld_MEM,
    input logic        mispred_MEM,
    input logic        ctrl_MEM,
    output logic        insn_vld_WB,
    output logic        mispred_WB,
    output logic        ctrl_WB
    );

    always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    o_RegWen_MEM <= 1'd0;
    o_pc_MEM <= 32'd0;
    o_instr_MEM <= 32'd0;
    o_wb_data_MEM <= 32'd0;
end else if (stall_2_WB) begin
    o_RegWen_MEM <= o_RegWen_MEM;
    o_pc_MEM    <= o_pc_MEM   ;
    o_instr_MEM <= o_instr_MEM;
    o_wb_data_MEM <= o_wb_data_MEM;
end else begin
    o_RegWen_MEM <=  flush_2_WB ? 32'd0 : i_RegWen_MEM;
    o_pc_MEM      <= flush_2_WB ? 32'd0 : i_pc_MEM   ;
    o_instr_MEM   <= flush_2_WB ? 32'd0 : i_instr_MEM;
    o_wb_data_MEM <= flush_2_WB ? 32'd0 :  i_wb_data_MEM;
end
end



always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
    insn_vld_WB    <= 1'b0;
    mispred_WB     <= 1'b0;
    ctrl_WB        <= 1'b0;
end else begin
    insn_vld_WB    <= insn_vld_MEM;      //When PCsel = 1 Flush activate
    mispred_WB     <= mispred_MEM ;
    ctrl_WB        <= ctrl_MEM    ;
end
end
endmodule

