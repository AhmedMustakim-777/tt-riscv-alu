`default_nettype none

// TinyTapeout wrapper for rv32i RISC-V ALU
// UCF EEE-5390C Full Custom VLSI Design
//
// Protocol:
//   Load A: ui_in[7]=1, ui_in[6:5]=byte_sel(0-3),
//            ui_in[4:1]=ALU_op (on byte 0 only)
//            uio_in[7:0]=data byte
//
//   Load B: ui_in[7]=0, ui_in[6:5]=byte_sel(0-3),
//            ui_in[0]=0
//            uio_in[7:0]=data byte
//
//   Read:   ui_in[0]=1
//            uio_in[7:6]=result byte select (0-3)
//            uo_out = selected result byte

module tt_um_riscv_alu (
    input  wire [7:0] ui_in,    // control + op
    output wire [7:0] uo_out,   // result byte output
    input  wire [7:0] uio_in,   // data byte input / out_sel
    output wire [7:0] uio_out,  // unused output
    output wire [7:0] uio_oe,   // all inputs (0=input)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Bidirectional pins all set to input mode
    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;

    // Suppress unused warning
    wire _unused = &{ena};

    // Internal registers
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
            if (ui_in[7]) begin
                // ── Load A byte ────────────────────────────
                case (ui_in[6:5])
                    2'b00: begin
                        reg_a[7:0] <= uio_in;
                        reg_op     <= ui_in[4:1]; // latch op with byte 0
                    end
                    2'b01: reg_a[15:8]  <= uio_in;
                    2'b10: reg_a[23:16] <= uio_in;
                    2'b11: reg_a[31:24] <= uio_in;
                endcase
            end else if (!ui_in[0]) begin
                // ── Load B byte ────────────────────────────
                case (ui_in[6:5])
                    2'b00: reg_b[7:0]   <= uio_in;
                    2'b01: reg_b[15:8]  <= uio_in;
                    2'b10: reg_b[23:16] <= uio_in;
                    2'b11: reg_b[31:24] <= uio_in;
                endcase
            end

            if (ui_in[0]) begin
                // ── Read mode: latch output byte select ────
                out_sel <= uio_in[7:6];
            end
        end
    end

    // Instantiate the RISC-V ALU unchanged
    wire [31:0] alu_result;

    riscv_alu u_alu (
        .alu_op_i (reg_op),
        .alu_a_i  (reg_a),
        .alu_b_i  (reg_b),
        .alu_p_o  (alu_result)
    );

    // Output selected byte of 32-bit result
    assign uo_out = (out_sel == 2'b00) ? alu_result[7:0]   :
                    (out_sel == 2'b01) ? alu_result[15:8]  :
                    (out_sel == 2'b10) ? alu_result[23:16] :
                                         alu_result[31:24];

endmodule
