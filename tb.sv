`timescale 1ns/1ns
module tb;
////////////////////////////////CLK INIT////////////////////////////////////
logic clk, rstn;

initial begin
    clk = 0;
    rstn= 0;
    forever #5 clk = !clk;
end

initial begin
    #7;
    rstn= 1;
end

/////////////////////////WAVE DUMP///////////////////

initial begin
  $shm_open("waves.shm");
  $shm_probe("ASM" );
end

  logic [31:0]  pc_debug;
  logic [31:0]  io_sw  ;
  logic [31:0]  io_lcd ;
  logic [31:0]  io_ledr;
  logic [31:0]  io_ledg;
  logic [ 6:0]  io_hex0;
  logic [ 6:0]  io_hex1;
  logic [ 6:0]  io_hex2;
  logic [ 6:0]  io_hex3;
  logic [ 6:0]  io_hex4;
  logic [ 6:0]  io_hex5;
  logic [ 6:0]  io_hex6;
  logic [ 6:0]  io_hex7;
  logic         ctrl    ;
  logic         mispred ;
  logic         insn_vld;


pipelined dut (
    .i_clk     (clk      ),
    .i_reset   (rstn     ),
    // Input peripherals
    .i_io_sw   (32'h12345678   ),
    // Output peripherals
    .o_io_lcd  (io_lcd   ),
    .o_io_ledr (io_ledr  ),
    .o_io_ledg (io_ledg  ),
    .o_io_hex0 (io_hex0  ),
    .o_io_hex1 (io_hex1  ),
    .o_io_hex2 (io_hex2  ),
    .o_io_hex3 (io_hex3  ),
    .o_io_hex4 (io_hex4  ),
    .o_io_hex5 (io_hex5  ),
    .o_io_hex6 (io_hex6  ),
    .o_io_hex7 (io_hex7  ),
    // Debug
    .o_ctrl    (ctrl     ),
    .o_mispred (mispred  ),
    .o_pc_debug(pc_debug ),
    .o_insn_vld(insn_vld )
  );

  initial begin
#50_000 $finish;
      end
//////////////////////////////DUT instance////////////////////////////////////////
//logic PCsel;
//logic [31:0] PC;
//logic [31:0] PC_q;
//logic [31:0] jmp_address;
//logic HIT;
//logic [31:0] predicted_address;
//
//logic [9:0] tag;
//assign tag = PC[11:2];
//
////regfile REGFILE (
////    .i_clk(clk),
////    .i_rst(rstn),
////    .i_rs1_addr(),
////    .i_rs2_addr(]),
////    .i_rd_addr(o_instr_EX[11:7]),
////    .i_rd_data(o_wb_data_MEM),
////    .i_rd_wren(1'b1),
////    .o_rs1_data(i_rs1_data),
////    .o_rs2_data(i_rs2_data)
////);
//always_ff @(posedge clk or negedge rstn) begin
//    if (!rstn) begin
//    PC_q <= 32'd0;
//end else begin
//    PC_q <= PC;
//end
//end
//
//
//BTB DUT(
//.clk(clk),
//.rstn(rstn),
//.PCsel(PCsel),
//.PC(PC),                //THIS FROM O_PC
//.PC_q(PC_q),            //THIS FROM PC (MUX) .jmp_address(jmp_address),
//.HIT(HIT),
//.predicted_address(predicted_address)
//);
//
///////////////////////////////////DUMPER//////////////////////////////////
////logic [31:0] test_q, test_d;
////initial begin
////test_d = 32'h12345678;
////#15 test_d = 32'hAABBCCDD;
////end
////always_ff @(posedge clk or negedge rstn) begin
////    if (!rstn) begin
////    test_q <= 32'd0;
////end else begin
////    test_q <= test_d;
////end
////end
//
//
/////////////////////////////////////DRIVER/////////////////////////////
//initial begin
//PCsel = 1'd0;
//PC    = 32'd0;
//jmp_address = 32'd0;
//fork
//    forever #5  PCsel = $urandom_range(0,1);
//    forever #10 PC    = $urandom;
//    forever #5 jmp_address = $random;
//    forever #5 $display ("PCsel = %h, PC = %h, jmp_address = %h", PCsel, PC, jmp_address);
//
//join_none
//#50 $finish;
//end
//


endmodule
