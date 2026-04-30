`default_nettype none

module tt_um_riscv_alu (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,     // ← separate input
    output wire [7:0] uio_out,    // ← separate output
    output wire [7:0] uio_oe,     // ← output enable
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

// Unused
wire _unused = &{ena};

// Set bidirectional as inputs only
assign uio_out = 8'h00;
assign uio_oe  = 8'h00;   // all pins set to input

// Registers to hold 32-bit operands
reg [31:0] reg_a;
reg [31:0] reg_b;
reg [3:0]  reg_op;
reg [1:0]  out_sel;

// ui_in[7:6] = which byte of A to load
// ui_in[5:2] = ALU op (latched on A byte 0)
// ui_in[1:0] = which byte of B to load
// uio_in[7:0] = data byte in
// uio_in[7:6] = out_sel when reading result

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_a   <= 32'b0;
        reg_b   <= 32'b0;
        reg_op  <= 4'b0;
        out_sel <= 2'b0;
    end else if (ena) begin
        case (ui_in[7:6])
            2'b00: begin
                reg_a[7:0] <= uio_in;
                reg_op     <= ui_in[5:2];
            end
            2'b01: reg_a[15:8]  <= uio_in;
            2'b10: reg_a[23:16] <= uio_in;
            2'b11: reg_a[31:24] <= uio_in;
        endcase
        case (ui_in[1:0])
            2'b00: reg_b[7:0]   <= uio_in;
            2'b01: reg_b[15:8]  <= uio_in;
            2'b10: reg_b[23:16] <= uio_in;
            2'b11: reg_b[31:24] <= uio_in;
        endcase
        out_sel <= uio_in[7:6];
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
