module pipelined (
    input  logic         i_clk     ,
    input  logic         i_reset   ,
    // Input peripherals
    input  logic [31:0]  i_io_sw   ,
    // Output peripherals
    output logic [31:0]  o_io_lcd  ,
    output logic [31:0]  o_io_ledr ,
    output logic [31:0]  o_io_ledg ,
    output logic [ 6:0]  o_io_hex0 ,
    output logic [ 6:0]  o_io_hex1 ,
    output logic [ 6:0]  o_io_hex2 ,
    output logic [ 6:0]  o_io_hex3 ,
    output logic [ 6:0]  o_io_hex4 ,
    output logic [ 6:0]  o_io_hex5 ,
    output logic [ 6:0]  o_io_hex6 ,
    output logic [ 6:0]  o_io_hex7 ,
    // Debug
    output logic [31:0]  o_pc_debug,
    output logic         o_insn_vld,
    output logic         o_ctrl    ,
    output logic         o_mispred
    );

///////////////FETCH LOGIC////////////////
logic [31:0] i_pc;
logic [31:0] i_pc_FF;
logic [31:0] o_pc;
logic [31:0] o_pc_FF;
logic [31:0] i_pc_IF;
logic [31:0] i_instr_IF;
logic        PCsel;
logic [31:0] PC;

///////////////DECODE LOGIC////////////////
logic flush_2_ID;
logic stall_2_ID;
logic [31:0] o_pc_IF;
logic [31:0] o_instr_IF;
logic [31:0] i_rs1_data;
logic [31:0] i_rs2_data;
logic [31:0] o_rs1_data;
logic [31:0] o_rs2_data;


///////////////EXECUTE LOGIC////////////////
logic flush_2_EX;
logic stall_2_EX;
logic [31:0] o_pc_ID;
logic [31:0] o_instr_ID;
logic [31:0] IMM;
logic [ 1:0] fw_select_A;
logic [ 1:0] fw_select_B;
logic [31:0] fw_data_A;
logic [31:0] fw_data_B;
logic        i_RegWen_EX;
logic        o_RegWen_EX;
logic [31:0] i_ALU_EX;
logic [31:0] o_ALU_EX;
logic        Asel;
logic        Bsel;
logic        MemRW;
logic [ 3:0] ALU_sel;
logic        br_un;
logic [ 1:0] i_wb_select_EX;
logic [ 1:0] o_wb_select_EX;
logic [31:0] data_A;
logic [31:0] data_B;
logic [31:0] LSU_DATA;
logic        LUI_flag;
logic        insn_vld_EX;
///////////////MEMORY LOGIC////////////////
logic       stall_2_MEM;
logic       flush_2_MEM;
logic [31:0] o_pc_EX   ;
logic [31:0] o_instr_EX;
logic [31:0] wb_select_MEM;
logic [31:0] i_wb_data_MEM;
logic [31:0] o_wb_data_MEM;
logic        o_RegWen_MEM;
logic        insn_vld_MEM;
logic        mispred_MEM;
logic        ctrl_MEM;
///////////////WRITEBACK LOGIC////////////////
logic       stall_2_WB;
logic       flush_2_WB;
logic [31:0]  o_pc_MEM;
logic [31:0]  o_instr_MEM;
logic [31:0]  wb_data_WB;
logic         insn_vld_WB;
logic        mispred_WB;
logic        ctrl_WB;


//assign flush_2_ID = 1'b0;
//assign flush_2_EX = 1'b0;
//assign flush_2_MEM= 1'b0;
//assign flush_2_WB = 1'b0;
//assign stall_2_ID = 1'b0;
//assign stall_2_EX = 1'b0;
//assign stall_2_MEM= 1'b0;
//assign stall_2_WB = 1'b0;
PC PC_INST (
    .i_pc(PC),
    .o_pc(i_pc_FF)
    );

///////////////   FF_PC    /////////////////////////
always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
    o_pc_FF <= 32'd0;
end else begin
    o_pc_FF <= i_pc_FF;
end
end
//////////////// MUX PC ////////////////////////////
assign PC = PCsel ? i_ALU_EX : o_pc_FF;



///////////////   FF_IF    /////////////////////////
always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
    i_pc_IF <= 32'd0;
end else begin
    i_pc_IF <= PC;
end
end

imem #(.MEM_FILE ("../02_test/isa_4b.hex"))
IMEM (
    .address(PC[12:2]),
    .clock(i_clk),
    .reset(i_reset),
    .q(i_instr_IF)
    );


    IF_reg IF (
        .clk(i_clk),
        .rstn(i_reset),
        .stall_2_ID(stall_2_ID),
        .flush_2_ID(flush_2_ID),
        .i_pc_IF(i_pc_IF),
        .i_instr_IF(i_instr_IF),
        .o_pc_IF(o_pc_IF),
        .o_instr_IF(o_instr_IF)
    );


////////////////////////////////////////////////////////////

regfile REGFILE (
    .i_clk(i_clk),
    .i_rst(i_reset),
    .flush_2_EX(flush_2_EX),
    .stall_2_EX(stall_2_EX),
    .i_rs1_addr(o_instr_IF[19:15]),
    .i_rs2_addr(o_instr_IF[24:20]),
    .i_rd_addr(o_instr_EX[11:7]),
    .i_rd_data(o_wb_data_MEM),
    .i_rd_wren(o_RegWen_EX),
    .o_rs1_data(o_rs1_data),
    .o_rs2_data(o_rs2_data)
);


ID_reg ID (
    .clk(i_clk),
    .rstn(i_reset),
    .stall_2_EX(stall_2_EX),
    .flush_2_EX(flush_2_EX),
    .i_pc_ID(o_pc_IF),
    .i_instr_ID(o_instr_IF),
    .o_pc_ID(o_pc_ID),
    .o_instr_ID(o_instr_ID)
    );

////////////////////////////////////////////////////////////


imm_gen IMM_GEN (
    .i_imm(o_instr_ID[31:7]),
    .i_sel(o_instr_ID[ 6:0]),
    .o_imm(IMM)
);


controller_unit CONTROLLER (
    .instr_data(o_instr_ID),
    .RegWen(i_RegWen_EX),
    .Asel(Asel),
    .Bsel(Bsel),
    .MemRW(MemRW),
    .ALU_sel(ALU_sel),
    .br_un(br_un),
    .wb_select(i_wb_select_EX)
);



FW_unit FW_UNIT(
.instr_EX(o_instr_ID),
.instr_MEM(o_instr_EX),
.instr_WB(o_instr_MEM),
.RegWen_MEM(o_RegWen_EX),
.RegWen_WB(o_RegWen_MEM),
.fw_select_A(fw_select_A),
.fw_select_B(fw_select_B)
    );




///////////////////MUX FW A///////////////////////////////
always_comb begin
case (fw_select_A)
2'b00: fw_data_A = o_rs1_data;
2'b01: fw_data_A = o_wb_data_MEM;
2'b10: fw_data_A = wb_data_WB;
2'b11: fw_data_A = o_rs1_data;
endcase
end


///////////////////MUX FW B///////////////////////////////
always_comb begin
case (fw_select_B)
2'b00: fw_data_B = o_rs2_data;
2'b01: fw_data_B = o_wb_data_MEM;
2'b10: fw_data_B = wb_data_WB;
2'b11: fw_data_B = o_rs1_data;
endcase
end

BRC BRANCH_CONTROL (
    .i_rs1_data(fw_data_A),
    .i_rs2_data(fw_data_B),
    .instr_data(o_instr_ID),
    .ALU_sel(ALU_sel),
    .i_br_un(br_un),
    .o_pc_sel(PCsel)
);
assign LUI_flag = o_instr_ID[6:0] == 7'b0110111;
assign data_A = Asel ? o_pc_ID : (LUI_flag) ? 32'd0 : fw_data_A;
assign data_B = Bsel ? IMM     : fw_data_B;


ALU ALU_INST (
.i_operand_a(data_A),
.i_operand_b(data_B),
.i_alu_op(ALU_sel),
.mux_out(i_ALU_EX)
);


LSU LOAD_STORE_UNIT (
    .i_clk(i_clk),
    .i_rst(i_reset),
    .i_lsu_wren(MemRW),
    .funct3(o_instr_ID[14:12]),
    .instruction_EX(o_instr_ID),
    .i_lsu_data(fw_data_B),
    .i_lsu_addr(i_ALU_EX),
    .i_io_sw(i_io_sw),
    .i_io_btn(32'hAABBCCDD),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_lcd(o_io_lcd),
    .o_ld_data(LSU_DATA),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5)
);


EX_reg EX (
    .clk(i_clk),
    .rstn(i_reset),
    .stall_2_MEM(stall_2_MEM),
    .flush_2_MEM(flush_2_MEM),
    .i_RegWen_EX(i_RegWen_EX),
    .i_wb_select_EX(i_wb_select_EX),
    .i_ALU_EX(i_ALU_EX),
    .i_pc_EX(o_pc_ID),
    .i_instr_EX(o_instr_ID),
    .o_pc_EX(o_pc_EX),
    .o_instr_EX(o_instr_EX),
    .o_RegWen_EX(o_RegWen_EX),
    .o_wb_select_EX(o_wb_select_EX),
    .o_ALU_EX(o_ALU_EX),

    .PCsel(PCsel),
    .insn_vld_MEM(insn_vld_MEM),
    .mispred_MEM(mispred_MEM),
    .ctrl_MEM(ctrl_MEM)
    );
////////////////////////////////////////////

always_comb begin
case (o_wb_select_EX)
2'b00: i_wb_data_MEM = LSU_DATA;
2'b01: i_wb_data_MEM = o_ALU_EX;
2'b10: i_wb_data_MEM = o_pc_EX + 4;
2'b11: i_wb_data_MEM = LSU_DATA;
endcase
end

load_logic LOAD_LOGIC (
.funct3(o_instr_EX[14:12]),
.opcode(o_instr_EX[6:0]),
.i_wback_data(i_wb_data_MEM),
.o_wback_data(o_wb_data_MEM)
);

MEM_reg MEM (
.clk(i_clk),
.rstn(i_reset),
.stall_2_WB(stall_2_WB),
.flush_2_WB(flush_2_WB),
.i_RegWen_MEM(o_RegWen_EX),
.i_wb_data_MEM(o_wb_data_MEM),
.i_pc_MEM(o_pc_EX),
.i_instr_MEM(o_instr_EX),
.o_RegWen_MEM(o_RegWen_MEM),
.o_pc_MEM(o_pc_MEM),
.o_wb_data_MEM(wb_data_WB),
.o_instr_MEM(o_instr_MEM),

.insn_vld_MEM(insn_vld_MEM),
.mispred_MEM(mispred_MEM),
.ctrl_MEM(ctrl_MEM),
.insn_vld_WB(insn_vld_WB),
.mispred_WB(mispred_WB),
.ctrl_WB(ctrl_WB)
    );

hazard_detection HAZARD (
    .PCsel(PCsel),
    .flush_2_ID(flush_2_ID),
    .stall_2_ID(stall_2_ID),
    .flush_2_EX(flush_2_EX),
    .stall_2_EX(stall_2_EX),
    .flush_2_MEM(flush_2_MEM),
    .stall_2_MEM(stall_2_MEM),
    .flush_2_WB(flush_2_WB),
    .stall_2_WB(stall_2_WB)
    );


assign o_insn_vld = insn_vld_WB;
assign o_ctrl     = ctrl_WB;
assign o_mispred  = mispred_WB;
assign o_pc_debug = o_pc_MEM;

endmodule
