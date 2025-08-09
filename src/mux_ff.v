module mux_ff#(
    parameter N = 18,
    parameter RSTTYPE = "SYNC"
) (
    input clk, rst, en, REG,
    input[N-1:0] d,
    output[N-1:0] q
);
reg[N-1:0] out;

generate
    if (RSTTYPE == "SYNC") begin
        always @(posedge clk) begin
            if(rst) out <= {N{1'b0}};
            else if(en) out <= d;
        end
    end
    else begin
        always @(posedge clk, posedge rst) begin
            if(rst) out <= {N{1'b0}};
            else if(en) out <= d;
        end
    end
endgenerate

assign q = (REG) ? out : d;

endmodule

