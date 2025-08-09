module DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
) (
    input CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP, 
    CARRYIN, RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP,
    input[7:0] OPMODE,
    input[17:0] A, B, D, BCIN,
    input[47:0] C, PCIN,
    output CARRYOUT, CARRYOUTF,
    output[17:0] BOUT,
    output[35:0] M,
    output[47:0] P, POUT
);

wire[7:0] OPMODE_reg;
wire[17:0] A0_reg, B0_reg, B_sel_wire, D_reg;
wire[47:0] C_reg;
assign B_sel_wire = (B_INPUT == "DIRECT") ? B : (B_INPUT == "CASCADE") ? BCIN : 0;

mux_ff #(.N(18), .RSTTYPE(RSTTYPE)) mA0(
    .clk(CLK), .rst(RSTA), .en(CEA), .REG(A0REG), .d(A),.q(A0_reg)
);
mux_ff #(.N(18), .RSTTYPE(RSTTYPE)) mB0(
    .clk(CLK), .rst(RSTB), .en(CEB), .REG(B0REG), .d(B_sel_wire), .q(B0_reg)
);
mux_ff #(.N(48), .RSTTYPE(RSTTYPE)) mC(
    .clk(CLK), .rst(RSTC), .en(CEC), .REG(CREG), .d(C), .q(C_reg)
);
mux_ff #(.N(18), .RSTTYPE(RSTTYPE)) mD(
    .clk(CLK), .rst(RSTD), .en(CED), .REG(DREG), .d(D), .q(D_reg)
);
mux_ff #(.N(8), .RSTTYPE(RSTTYPE)) mOP(
    .clk(CLK), .rst(RSTOPMODE), .en(CEOPMODE), .REG(OPMODEREG), .d(OPMODE), .q(OPMODE_reg)
);

wire[17:0] add_sub1_wire, A1_reg, B1_reg, B_mux_wire;
assign add_sub1_wire = (OPMODE_reg[6]) ? D_reg - B0_reg : D_reg + B0_reg;
assign B_mux_wire = (OPMODE_reg[4]) ? add_sub1_wire : B0_reg;

mux_ff #(.N(18), .RSTTYPE(RSTTYPE)) mA1(
    .clk(CLK), .rst(RSTA), .en(CEA), .REG(A1REG), .d(A0_reg), .q(A1_reg)
);
mux_ff #(.N(18), .RSTTYPE(RSTTYPE)) mB1(
    .clk(CLK), .rst(RSTB), .en(CEB), .REG(B1REG), .d(B_mux_wire), .q(B1_reg)
);

assign BOUT = B1_reg;

wire[35:0] mul_wire, mul_reg;
assign mul_wire = A1_reg*B1_reg;

mux_ff #(.N(36), .RSTTYPE(RSTTYPE)) mM(
    .clk(CLK), .rst(RSTM), .en(CEM), .REG(MREG), .d(mul_wire), .q(mul_reg)
);
assign M = mul_reg;

// mux x
reg[47:0] mux_x_wire;
wire[47:0] conc_wire = {D_reg[11:0], A1_reg, B1_reg};
always @(*) begin
    case(OPMODE_reg[1:0])
    2'b00: mux_x_wire = 0;
    2'b01: mux_x_wire = mul_reg;
    2'b10: mux_x_wire = P;
    default: mux_x_wire = conc_wire;
    endcase
end

//mux z
reg[47:0] mux_z_wire;
always @(*) begin
    case(OPMODE_reg[3:2])
    2'b00: mux_z_wire = 0;
    2'b01: mux_z_wire = PCIN;
    2'b10: mux_z_wire = P;
    default: mux_z_wire = C_reg;
    endcase
end

//

wire CARRY_CASCADE_wire, CARRYIN_reg;
assign CARRY_CASCADE_wire = (CARRYINSEL == "OPMODE5") ? OPMODE_reg[5] : (CARRYINSEL == "CARRYIN") ? CARRYIN : 0;

mux_ff #(.N(1), .RSTTYPE(RSTTYPE)) mCI(
    .clk(CLK), .rst(RSTCARRYIN), .en(CECARRYIN), .REG(CARRYINREG), .d(CARRY_CASCADE_wire), .q(CARRYIN_reg)
);

wire CARRYOUT_wire;
wire[47:0] add_sub2_wire;

assign {CARRYOUT_wire, add_sub2_wire} = (OPMODE_reg[7]) ? mux_z_wire - mux_x_wire - CARRYIN_reg : mux_z_wire + mux_x_wire + CARRYIN_reg;

mux_ff #(.N(1), .RSTTYPE(RSTTYPE)) mCO(
    .clk(CLK), .rst(RSTCARRYIN), .en(CECARRYIN), .REG(CARRYOUTREG), .d(CARRYOUT_wire), .q(CARRYOUT)
);

assign CARRYOUTF = CARRYOUT;

mux_ff #(.N(48), .RSTTYPE(RSTTYPE)) mP(
    .clk(CLK), .rst(RSTP), .en(CEP), .REG(PREG), .d(add_sub2_wire), .q(P)
);

assign POUT = P;

endmodule