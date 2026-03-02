module FW_unit (
    input logic [31:0] instr_EX,
    input logic [31:0] instr_MEM,
    input logic [31:0] instr_WB,
    input logic        RegWen_MEM,
    input logic        RegWen_WB,

    output logic [1:0] fw_select_A,
    output logic [1:0] fw_select_B
    );

logic [4:0] rs1_EX;
logic [4:0] rs2_EX;
assign rs1_EX = instr_EX[19:15];
assign rs2_EX = instr_EX[24:20];

logic [4:0] rd_MEM;
assign rd_MEM= instr_MEM[11:7];
logic zero_MEM_check;
assign zero_MEM_check = |rd_MEM;

logic [4:0] rd_WB;
assign rd_WB = instr_WB[11:7];
logic zero_WB_check;
assign zero_WB_check = |rd_WB;

///////////////////////////LOGIC FW A/////////////////////
logic fw_A_MEM;
assign fw_A_MEM = ~|(rs1_EX ^ rd_MEM) & zero_MEM_check & RegWen_MEM ;

logic fw_A_WB;
assign fw_A_WB = ~|(rs1_EX ^ rd_WB) & zero_WB_check & RegWen_WB;

always_comb begin
case ({fw_A_WB, fw_A_MEM})
2'b00: fw_select_A = 2'b00 ;
2'b01: fw_select_A = 2'b01;
2'b10: fw_select_A = 2'b10;
2'b11: fw_select_A = 2'b01;
endcase
end

///////////////////////////LOGIC FW B/////////////////////
logic fw_B_MEM;
assign fw_B_MEM = ~|(rs2_EX ^ rd_MEM) & zero_MEM_check & RegWen_MEM;

logic fw_B_WB;
assign fw_B_WB = ~|(rs2_EX ^ rd_WB) & zero_WB_check & RegWen_WB;

always_comb begin
case ({fw_B_WB, fw_B_MEM})
2'b00: fw_select_B = 2'b00 ;
2'b01: fw_select_B = 2'b01;
2'b10: fw_select_B = 2'b10;
2'b11: fw_select_B = 2'b01;
endcase
end
endmodule
