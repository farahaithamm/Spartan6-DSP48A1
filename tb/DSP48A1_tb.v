module DSP48A1_tb();
reg CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP, CARRYIN;
reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
reg[7:0] OPMODE;
reg[17:0] A, B, D, BCIN;
reg[47:0] C, PCIN;
wire CARRYOUT, CARRYOUTF;
wire[17:0] BOUT;
wire[35:0] M;
wire[47:0] P, POUT;

DSP48A1 D1(
    .CLK(CLK), .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN),
    .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP), .CARRYIN(CARRYIN),
    .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD),
    .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP), .OPMODE(OPMODE),
    .A(A), .B(B), .D(D), .BCIN(BCIN), .C(C), .PCIN(PCIN), .CARRYOUT(CARRYOUT), 
    .CARRYOUTF(CARRYOUTF), .BOUT(BOUT), .M(M), .P(P), .POUT(POUT)
);

initial begin
    CLK = 0;
    forever #1 CLK = ~CLK;
end

initial begin
    RSTA=1; RSTB=1; RSTC=1; RSTCARRYIN=1; RSTD=1; RSTM=1; RSTOPMODE=1; RSTP=1;
    CEA = $random; CEB = $random; CEC = $random; CECARRYIN = $random; CED = $random; 
    CEM = $random; CEOPMODE = $random; CEP = $random; CARRYIN = $random; OPMODE = $random;
    A = $random; B = $random; C = $random; D = $random; PCIN = $random; BCIN = $random;
    @(negedge CLK);

    RSTA=0; RSTB=0; RSTC=0; RSTCARRYIN=0; RSTD=0; RSTM=0; RSTOPMODE=0; RSTP=0;
    CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; CED = 1; CEM = 1; CEOPMODE = 1; CEP = 1;

    OPMODE = 8'b11011101; A = 20; B = 10; C = 350; D = 25;
    CARRYIN = $random; PCIN = $random; BCIN = $random;
    repeat(4) @(negedge CLK);
    if(BOUT != 18'hf || M != 36'h12c || P != 48'h32 || POUT != 48'h32 || CARRYOUT != 0 || CARRYOUTF != 0) begin
        $display("ERROR - BOUT= %h, M = %h, P = %h, POUT = %h, CARRYOUT = %h, CARRYOUTF = %h",BOUT, M, P, POUT, CARRYOUT, CARRYOUTF);
        $display("EXPECTED- BOUT= 18'hf, M = 36'h12c, P = 48'h32, POUT = 48'h32, CARRYOUT = 0, CARRYOUTF = 0");
        $stop;
    end

    OPMODE = 8'b00010000;
    CARRYIN = $random; PCIN = $random; BCIN = $random;
    repeat(3) @(negedge CLK);
    if(BOUT != 18'h23 || M != 36'h2bc || P != 48'h0 || POUT != 48'h0 || CARRYOUT != 0 || CARRYOUTF != 0) begin
        $display("ERROR - BOUT= %h, M = %h, P = %h, POUT = %h, CARRYOUT = %h, CARRYOUTF = %h",BOUT, M, P, POUT, CARRYOUT, CARRYOUTF);
        $display("EXPECTED- BOUT= 18'h23, M = 36'h2bc, P = 48'h0, POUT = 48'h0, CARRYOUT = 0, CARRYOUTF = 0");
        $stop;
    end

    OPMODE = 8'b00001010;
    CARRYIN = $random; PCIN = $random; BCIN = $random;
    repeat(3) @(negedge CLK);
    if(BOUT != 18'ha || M != 36'hc8 || P != 48'h0 || POUT != 48'h0 || CARRYOUT != 0 || CARRYOUTF != 0) begin
        $display("ERROR - BOUT= %h, M = %h, P = %h, POUT = %h, CARRYOUT = %h, CARRYOUTF = %h",BOUT, M, P, POUT, CARRYOUT, CARRYOUTF);
        $display("EXPECTED- BOUT= 18'ha, M = 36'hc8, P = 48'h0, POUT = 48'h0, CARRYOUT = 0, CARRYOUTF = 0");
        $stop;
    end

    OPMODE = 8'b10100111; A = 5; B = 6; C = 350; D = 25; PCIN = 3000; 
    CARRYIN = $random; BCIN = $random;
    repeat(4) @(negedge CLK);
    if(BOUT != 18'h6 || M != 36'h1e || P != 48'hfe6fffec0bb1 || POUT != 48'hfe6fffec0bb1 || CARRYOUT != 1 || CARRYOUTF != 1) begin
        $display("ERROR - BOUT= %h, M = %h, P = %h, POUT = %h, CARRYOUT = %h, CARRYOUTF = %h",BOUT, M, P, POUT, CARRYOUT, CARRYOUTF);
        $display("EXPECTED- BOUT= 18'h6, M = 36'h1e, P = 48'hfe6fffec0bb1, POUT = 48'hfe6fffec0bb1, CARRYOUT = 1, CARRYOUTF = 1");
        $stop;
    end

    $stop;
end

initial begin
    $monitor("BOUT= %h, M = %h, P = %h, POUT = %h, CARRYOUT = %h, CARRYOUTF = %h",BOUT, M, P, POUT, CARRYOUT, CARRYOUTF);
end

endmodule
