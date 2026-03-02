module LSU(
input logic i_clk, i_rst, i_lsu_wren,
input logic [2:0] funct3,
input logic [31:0] instruction_EX,
input logic [31:0] i_lsu_data,                                   // the input data for LSU comes from output 2 of register files                                                                 
input logic [31:0] i_lsu_addr,                                  //the address for LSU comes from ALU
input logic [31:0] i_io_sw,
input logic [31:0] i_io_btn,

output logic [31:0]  o_io_ledr, o_io_ledg, o_io_lcd, o_ld_data,
output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5);


logic [31:0] data_data, io_data;

logic data_mem_enable, io_mem_enable;
logic o_data_wren, o_io_wren;
logic [31:0] o_data_mem, o_data_io;
logic data_enable, io_enable;

logic data_enable_q, io_enable_q;


Decoder  decoder_inst ( .i_ls_address(i_lsu_addr[31:28]),                               //take the msb nible
                        .store_enable(i_lsu_wren),
                        .i_data(i_lsu_data),
                        .o_data_wren(o_data_wren),
                        .o_data_mem(o_data_mem),
                        .o_io_wren(o_io_wren),
                        .o_data_io(o_data_io),
                        .data_enable(data_enable),
                        .io_enable(io_enable)
);


////////////////////////////////STORE LOGIC////////////////////////////////////////////
logic [3:0] byteena;
logic [3:0] byteenb;
logic [31:0] o_data;

store_logic store_logic_inst(
        .opcode  (instruction_EX[6:0]),
        .funct3  (instruction_EX[14:12]),
        .i_data  (o_data_mem),
        .o_data  (o_data),
        .addr_lsb(i_lsu_addr[1:0]),
        .byteena (byteena)
);

logic [31:0] q_a, q_b;
slave_DMEM slave_DMEM_inst (
    .address_a      (i_lsu_addr[15:2]),
    .address_b      (i_lsu_addr[15:2] + 1'b1),
    .byteena_a      (byteena),
    .byteena_b      (4'b0000),
    .clock          (i_clk),
    .data_a         (o_data),
    .data_b         (32'd0),
    .rden_a         (1'b1),
    .rden_b         (1'b1),
    .wren_a         (o_data_wren),
    .wren_b         (1'b0),
    .q_a            (q_a),
    .q_b            (q_b)
                );

logic [31:0] i_lsu_addr_q;
always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
    i_lsu_addr_q <= 32'd0;
    end else begin
    i_lsu_addr_q <= i_lsu_addr;
    end
    end


 load_LSU_logic load_LSU_logic_inst(
                .i_address     (i_lsu_addr_q[1:0]),
                .i_data       (q_a),
                .i_nxt_data   (q_b),
                .o_data      (data_data)
);


ram_1KB_IO   ram_1KB_IO_DUT
(   .i_clk(i_clk),
    .i_rst(i_rst),
    .i_wren(o_io_wren),
    .io_enable(io_enable),
    .i_address(i_lsu_addr[16:0]), // 17 lsb of addresses for IO                             
    .i_data(o_data),
    .o_data(io_data),
    .i_io_sw(i_io_sw),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_lcd(o_io_lcd),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .funct3(funct3)                     //add function_3 to store load byte and half word
    );

logic  [1:0] lsu_sel;

always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
        io_enable_q <= 1'b0;
        data_enable_q <= 1'b0;
end else begin
    io_enable_q   <= io_enable  ;
    data_enable_q <= data_enable;

end
end


assign lsu_sel = {io_enable_q, data_enable_q};

LSU_MUX LSU_MUX_inst (  .data_data(data_data),
                        .io_data(io_data),
                        .lsu_sel(lsu_sel),
                        .lsu_data_out(o_ld_data)
                );

endmodule   
