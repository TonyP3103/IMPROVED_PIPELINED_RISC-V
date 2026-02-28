module MEM_reg (
    input logic clk,
    input logic rstn,
    input logic stall_2_WB,
    input logic flush_2_WB,
    input logic [31:0]  i_wb_data_MEM,
    input logic [31:0]  i_pc_MEM,
    input logic [31:0]  i_instr_MEM,
    output logic [31:0] o_pc_MEM,
    output logic [31:0] o_wb_data_MEM,
    output logic [31:0] o_instr_MEM
    );

    always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    o_pc_MEM <= 32'd0;
    o_instr_MEM <= 32'd0;
    o_wb_data_MEM <= 32'd0;
end else if (stall_2_WB) begin
    o_pc_MEM    <= o_pc_MEM   ;
    o_instr_MEM <= o_instr_MEM;
    o_wb_data_MEM <= o_wb_data_MEM;
end else begin
    o_pc_MEM      <= flush_2_WB ? 32'd0 : i_pc_MEM   ;
    o_instr_MEM   <= flush_2_WB ? 32'd0 : i_instr_MEM;
    o_wb_data_MEM <= flush_2_WB ? 32'd0 :  i_wb_data_MEM;
end
end
endmodule

