//miss_pred shows if last predict is correct
module prediction (
    input logic i_clk,
    input logic rstn,
    input logic miss_pred,
    input logic [31:0] instr_EX,          //check BRANCH instruction
    output logic predict
    );
// if miss reverse the predict
logic jmp_flag;
assign jmp_flag = (instr_EX[6:0] == 7'b1100011) || (instr_EX[7:0] == 7'b1101111);
always_ff @(posedge i_clk or negedge rstn) begin
if(!rstn) begin
    predict <= 1'b0;
end else if (miss_pred & jmp_flag) begin
    predict <= !predict;
end else begin
    predict <= predict;
end
end
endmodule
