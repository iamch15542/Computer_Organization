//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      李柏漢0616077 陳昱螢0616091
//----------------------------------------------
//Date:        2019/04/25
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    shamt,
    result_o,
    zero_o
    );
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [5-1:0]   shamt;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

wire        [32-1:0] unsigned_src1,
                     unsigned_src2;
wire signed [32-1:0] signed_src1,
                     signed_src2;

//Parameter

// R Type
parameter AND   =   0;
parameter OR    =   1;
parameter ADDU  =   2;
parameter SUBU  =   3;
parameter SLT   =   4;
parameter SRA   =   5;
parameter SRAV  =   6;

// I type
parameter BEQ   =   7;
parameter BNE   =   8;
parameter ADDI  =   9;
parameter SLTIU =   10;
parameter LUI   =   11;
parameter ORI   =   12;

parameter SLL   =   13;

//Main function
assign zero_o = (result_o == 0);
assign unsigned_src1 = src1_i;
assign unsigned_src2 = src2_i;
assign signed_src1 = src1_i;
assign signed_src2 = src2_i;

always @(ctrl_i, src1_i, src2_i) begin
    case (ctrl_i)
        AND     : result_o <= src1_i & src2_i;
        OR      : result_o <= src1_i | src2_i;
        ADDU    : result_o <= unsigned_src1 + unsigned_src2;
        SUBU    : result_o <= unsigned_src1 - unsigned_src2;
        SLT     : result_o <= (signed_src1 < signed_src2);
        SRA     : result_o <= signed_src2 >>> shamt;     // sign bit shifted
        SRAV    : result_o <= signed_src2 >>> signed_src1;    // sign bit shifted
        
        BEQ     : result_o <= (src1_i == src2_i) ? 32'b0 : 32'b1; // zero if true
        BNE     : result_o <= (src1_i != src2_i) ? 32'b0 : 32'b1; // zero if true
        ADDI    : result_o <= signed_src1 + signed_src2;
        SLTIU   : result_o <= (unsigned_src1 < unsigned_src2);
        LUI     : result_o <= {src2_i[15:0], 16'b0};
        ORI     : result_o <= src1_i | {16'b0, src2_i[15:0]};
        SLL     : result_o <= src1_i << shamt;
    endcase
end

endmodule