 module regfile
(
input logic i_clk, i_rst,
input logic flush_2_EX,
input logic stall_2_EX,
input logic [4:0] i_rs1_addr, i_rs2_addr,

input logic [4:0] i_rd_addr,
input logic [31:0] i_rd_data,
input logic i_rd_wren,

output logic [31:0] o_rs1_data, o_rs2_data);



logic [31:0] reg_array [31:0];

logic [31:0] data_temp;

assign data_temp = (i_rd_addr) ? i_rd_data : 32'b0;


always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
        reg_array[0] <= 32'b0;
        reg_array[1] <= 32'b0;
        reg_array[2] <= 32'b0;
        reg_array[3] <= 32'b0;
        reg_array[4] <= 32'b0;
        reg_array[5] <= 32'b0;
        reg_array[6] <= 32'b0;
        reg_array[7] <= 32'b0;
        reg_array[8] <= 32'b0;
        reg_array[9] <= 32'b0;
        reg_array[10] <= 32'b0;
        reg_array[11] <= 32'b0;
        reg_array[12] <= 32'b0;
        reg_array[13] <= 32'b0;
        reg_array[14] <= 32'b0;
        reg_array[15] <= 32'b0;
        reg_array[16] <= 32'b0;
        reg_array[17] <= 32'b0;
        reg_array[18] <= 32'b0;
        reg_array[19] <= 32'b0;
        reg_array[20] <= 32'b0;
        reg_array[21] <= 32'b0;
        reg_array[22] <= 32'b0;
        reg_array[23] <= 32'b0;
        reg_array[24] <= 32'b0;
        reg_array[25] <= 32'b0;
        reg_array[26] <= 32'b0;
        reg_array[27] <= 32'b0;
        reg_array[28] <= 32'b0;
        reg_array[29] <= 32'b0;
        reg_array[30] <= 32'b0;
        reg_array[31] <= 32'b0;
    end else begin
        if (i_rd_wren) begin
            reg_array[i_rd_addr] <= data_temp;
        end
end
    end

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_rs1_data <= 32'd0;
            o_rs2_data <= 32'd0;
        end else if (stall_2_EX) begin
        o_rs1_data <= o_rs1_data ;
        o_rs2_data <= o_rs2_data ;
        end else begin
        o_rs1_data <= flush_2_EX ? 32'd0 : reg_array[i_rs1_addr];
        o_rs2_data <= flush_2_EX ? 32'd0 : reg_array[i_rs2_addr];
    end
end
endmodule
