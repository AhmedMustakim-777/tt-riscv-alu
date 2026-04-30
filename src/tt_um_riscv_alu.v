`default_nettype none

module tt_um_riscv_alu (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    inout  wire [7:0] uio,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

wire _unused = &{ena, clk, rst_n};
assign uio = 8'hzz;

reg [31:0] reg_a;
reg [31:0] reg_b;
reg [3:0]  reg_op;
reg [1:0]  out_sel;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_a   <= 32'b0;
        reg_b   <= 32'b0;
        reg_op  <= 4'b0;
        out_sel <= 2'b0;
    end else if (ena) begin
        case (ui_in[7:6])
            2'b00: begin
                reg_a[7:0] <= uio;
                reg_op     <= ui_in[5:2];
            end
            2'b01: reg_a[15:8]  <= uio;
            2'b10: reg_a[23:16] <= uio;
            2'b11: reg_a[31:24] <= uio;
        endcase
        case (ui_in[1:0])
            2'b00: reg_b[7:0]   <= uio;
            2'b01: reg_b[15:8]  <= uio;
            2'b10: reg_b[23:16] <= uio;
            2'b11: reg_b[31:24] <= uio;
        endcase
        out_sel <= uio[7:6];
    end
end

wire [31:0] result;

riscv_alu u_alu (
    .alu_op_i (reg_op),
    .alu_a_i  (reg_a),
    .alu_b_i  (reg_b),
    .alu_p_o  (result)
);

assign uo_out = (out_sel == 2'b00) ? result[7:0]  :
                (out_sel == 2'b01) ? result[15:8]  :
                (out_sel == 2'b10) ? result[23:16] :
                                     result[31:24];
endmodule
