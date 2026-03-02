module hazard_detection (
    input  logic PCsel,

    output logic flush_2_ID,
    output logic stall_2_ID,
    output logic flush_2_EX,
    output logic stall_2_EX,
    output logic flush_2_MEM,
    output logic stall_2_MEM,
    output logic flush_2_WB,
    output logic stall_2_WB
    );
    always_comb begin
    if (PCsel) begin
        flush_2_ID  =   1'b1;
        stall_2_ID  =   1'b0;
        flush_2_EX  =   1'b1;
        stall_2_EX  =   1'b0;
        flush_2_MEM =   1'b0;
        stall_2_MEM =   1'b0;
        flush_2_WB  =   1'b0;
        stall_2_WB  =   1'b0;
    end else begin
        flush_2_ID  =   1'b0;
        stall_2_ID  =   1'b0;
        flush_2_EX  =   1'b0;
        stall_2_EX  =   1'b0;
        flush_2_MEM =   1'b0;
        stall_2_MEM =   1'b0;
        flush_2_WB  =   1'b0;
        stall_2_WB  =   1'b0;
    end
    end
endmodule
