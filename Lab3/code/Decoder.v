//Subject:     CO project 3 - Decoder
//--------------------------------------------------------------------------------
//Version:     2.0
//--------------------------------------------------------------------------------
//Writer:      李柏漢0616077 陳昱螢0616091
//----------------------------------------------
//Date:        2019/05/17
//----------------------------------------------
//Description: ALU_Decoder
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    instr_func_i,   //use to distinguish jr instruction
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Jump_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o,
    BranchType_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] instr_func_i;

output reg         RegWrite_o;
output reg [4-1:0] ALU_op_o;
output reg         ALUSrc_o;
output reg [2-1:0] RegDst_o; //2:jal
output reg         Branch_o;
output reg [2-1:0] Jump_o; //0:branch 1:j jal 2:jr
output reg         MemRead_o;
output reg         MemWrite_o;
output reg [2-1:0] MemtoReg_o;
output reg [2-1:0] BranchType_o; //0:beq 1:ble 2:bltz 3:bne bnez
 
//Internal Signals

//Parameter

//Main function
always @ (*)
begin
    case (instr_op_i)
        //R-type
        //add, sub, and, or, slt, sra, srav, jr, mul
        6'b000000:
        begin
            if (instr_func_i == 6'b001000) // jr
            begin
                RegWrite_o <= 0;
                ALU_op_o <= 4'bxxxx;
                ALUSrc_o <= 1'bx;
                RegDst_o <= 2'bxx;
                Branch_o <= 0;
                Jump_o <= 2'b10;
                MemRead_o <= 0;
                MemWrite_o <= 0;
                MemtoReg_o <= 2'bxx;
                BranchType_o <= 2'bxx;
            end
            else // R-type
            begin
                RegWrite_o <= 1;
                ALU_op_o <= 4'b0010;
                ALUSrc_o <= 0;
                RegDst_o <= 2'b01;
                Branch_o <= 0;
                Jump_o <= 2'b00;
                MemRead_o <= 0;
                MemWrite_o <= 0;
                MemtoReg_o <= 0;
                BranchType_o <= 2'bxx;
            end
        end
        
        //I-type
        //beq
        6'b000100:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 4'b0001;
            ALUSrc_o <= 0;
            RegDst_o <= 2'bxx;
            Branch_o <= 1;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 2'bxx;
            BranchType_o <= 2'b00;
        end
        //bne bnez
        6'b000101:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 4'b0011;
            ALUSrc_o <= 0;
            RegDst_o <= 2'bxx;
            Branch_o <= 1;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 2'bxx;
            BranchType_o <= 2'b11;
        end
        //addi
        6'b001000:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 4'b0000;
            ALUSrc_o <= 1;
            RegDst_o <= 2'b00;
            Branch_o <= 0;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 0;
            BranchType_o <= 2'bxx;
        end
        //sltiu
        6'b001011:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 4'b0110;
            ALUSrc_o <= 1;
            RegDst_o <= 2'b01;
            Branch_o <= 0;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 0;
            BranchType_o <= 2'bxx;
        end

        //ori
        6'b001101:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 4'b0100;
            ALUSrc_o <= 1;
            RegDst_o <= 2'b00;
            Branch_o <= 0;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 0;
            BranchType_o <= 2'bxx;
        end

        //lw
        6'b100011:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 4'b0101;
            ALUSrc_o <= 1;
            RegDst_o <= 2'b00;
            Branch_o <= 0;
            Jump_o <= 2'b00;
            MemRead_o <= 1;
            MemWrite_o <= 0;
            MemtoReg_o <= 1;
            BranchType_o <= 2'bxx;
        end

        //sw
        6'b101011:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 4'b0111;
            ALUSrc_o <= 1;
            RegDst_o <= 2'bxx;
            Branch_o <= 0;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 1;
            MemtoReg_o <= 2'bxx;
            BranchType_o <= 2'bxx;
        end

        //jump
        6'b000010:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 4'bxxxx;
            ALUSrc_o <= 0;
            RegDst_o <= 2'bxx;
            Branch_o <= 0;
            Jump_o <= 2'b01;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 2'bxx;
            BranchType_o <= 2'bxx;
        end

        //jump and link
        6'b000011:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 4'b1001;
            ALUSrc_o <= 0;
            RegDst_o <= 2'b10;
            Branch_o <= 0;
            Jump_o <= 2'b01;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 0;
            BranchType_o <= 2'bxx;
        end

        //ble
        6'b000110:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 4'b1000;
            ALUSrc_o <= 0;
            RegDst_o <= 2'bxx;
            Branch_o <= 1;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 2'bxx;
            BranchType_o <= 2'b01;
        end

        //bltz
        6'b000001:
        begin
            RegWrite_o <= 0;
            ALU_op_o <= 4'b1010;
            ALUSrc_o <= 0;
            RegDst_o <= 2'bxx;
            Branch_o <= 1;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 2'bxx;
            BranchType_o <= 2'b10;
        end

        //li
        6'b001111:
        begin
            RegWrite_o <= 1;
            ALU_op_o <= 4'b0000;
            ALUSrc_o <= 1;
            RegDst_o <= 2'b00;
            Branch_o <= 0;
            Jump_o <= 2'b00;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            MemtoReg_o <= 0;
            BranchType_o <= 2'bxx;
        end        
    endcase
end
endmodule