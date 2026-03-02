//======================================
//          1KB BTB
//======================================
module BTB (
    input logic clk,
    input logic rstn,
    input logic PCsel,
    input logic [31:0] PC,
    input logic [31:0] PC_q,
    input logic [31:0] jmp_address,
    output logic         HIT,
    output logic [31:0] predicted_address
    );

//==========INITIALIZE 1KB RAM===========
logic [19:0] btb_tag [1023:0];

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        for (int i = 0; i < 1024; i++) begin
            btb_tag[i] <= 20'd0;
        end
    end else if (PCsel) begin
            btb_tag[PC[11:2]] <= PC[31:12];
    end
end


logic [31:0] btb_addr [1023:0];

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        for (int i = 0; i < 1024; i++) begin
            btb_addr[i] <= 32'd0;
        end
    end else if (PCsel) begin
            btb_addr[PC[11:2]] <= jmp_address[31:0];
    end
end

always_ff @(posedge clk or negedge rstn) begin
    predicted_address <= btb_addr[PC_q[11:2]];
end

assign HIT = ~|(btb_tag[PC[11:2]] ^ PC_q[31:12]);

endmodule
