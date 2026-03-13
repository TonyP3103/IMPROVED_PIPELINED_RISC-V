module PC_mux_select (
    input logic PCsel,
    input logic VALID,
    input logic miss_pred,
    input logic [31:0] o_pc_FF,
    input logic [31:0] i_ALU_EX,
    input logic [31:0] predicted_address,
    input logic [31:0] PC_EX,
//==============OUTPUT==============
    output logic [31:0] PC
    );


logic [31:0] predicted_path;
logic [31:0] re_predicted_path;

logic [31:0] PC_EX_plus4;
PC PC_EX_ADD_4 (
    .i_pc(PC_EX),
    .o_pc(PC_EX_plus4)
    );

assign predicted_path = VALID ? predicted_address : o_pc_FF;
assign re_predicted_path = PCsel ? i_ALU_EX : PC_EX_plus4;

assign PC = miss_pred ? re_predicted_path : predicted_path;

endmodule
