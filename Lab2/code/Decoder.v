//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      李柏漢0616077 陳昱螢0616091
//----------------------------------------------
//Date:        2019/04/25
//----------------------------------------------
//Description: ALU_Decoder
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter

//Main function
always @ (*)
begin
    case (instr_op_i)
        //R-type
        //add, sub, and, or, slt, sra, srav
        6'b000000:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 3'b010;
            ALUSrc_o <= 0;
            RegDst_o <= 1;
            Branch_o <= 0;
        end
        
        //I-type
        //beq
        6'b000100:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 3'b001;
            ALUSrc_o <= 0;
            RegDst_o <= 0;
            Branch_o <= 1;
        end
        //bne
        6'b000101:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 3'b011;
            ALUSrc_o <= 0;
            RegDst_o <= 0;
            Branch_o <= 1;
        end
        //addi
        6'b001000:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 3'b000;
            ALUSrc_o <= 1;
            RegDst_o <= 0;
            Branch_o <= 0;
        end
        //sltiu
        6'b001011:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 3'b110;
            ALUSrc_o <= 1;
            RegDst_o <= 0;
            Branch_o <= 0;
        end
        //lui
        6'b001111:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 3'b101;
            ALUSrc_o <= 1;
            RegDst_o <= 0;
            Branch_o <= 0;
        end
        //ori
        6'b001101:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 3'b100;
            ALUSrc_o <= 1;
            RegDst_o <= 0;
            Branch_o <= 0;
        end
    endcase
end
endmodule