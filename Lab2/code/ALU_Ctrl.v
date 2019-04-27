//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      李柏漢0616077 陳昱螢0616091
//----------------------------------------------
//Date:        2019/04/25
//----------------------------------------------
//Description: ALU_controller
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
//R-type
parameter alu_and   = 4'b0000;
parameter alu_or    = 4'b0001;
parameter alu_addu  = 4'b0010;
parameter alu_subu  = 4'b0011;
parameter alu_slt   = 4'b0100;
parameter alu_sra   = 4'b0101;
parameter alu_srav  = 4'b0110;

//I-type
parameter alu_beq   = 4'b0111;
parameter alu_bne   = 4'b1000;
parameter alu_addi  = 4'b1001;
parameter alu_sltiu = 4'b1010;
parameter alu_lui   = 4'b1011;
parameter alu_ori   = 4'b1100;

parameter alu_sll   = 4'b1101; //13
       
//Select exact operation
always @ (*)
begin
    case (ALUOp_i)
        //R-type
        //add, sub, and, or, slt, sra, srav
        3'b010:
        begin
            case (funct_i)
                6'b100100: //and
                begin
                    ALUCtrl_o <= alu_and;
                end
                6'b100101: //or
                begin
                    ALUCtrl_o <= alu_or;
                end
                6'b100001: //addu
                begin
                    ALUCtrl_o <= alu_addu;
                end
                6'b100011: //subu
                begin
                    ALUCtrl_o <= alu_subu;
                end
                6'b101010: //slt
                begin
                    ALUCtrl_o <= alu_slt;
                end
                6'b000011: //sra
                begin
                    ALUCtrl_o <= alu_sra;
                end
                6'b000111: //srav
                begin
                    ALUCtrl_o <= alu_srav;
                end
                6'b000000: //sll
                begin
                    ALUCtrl_o <= alu_sll;
                end
            endcase
        end
        //I-type
        //beq
        3'b001:
        begin
            ALUCtrl_o <= alu_beq;
        end
        //bne
        3'b011:
        begin
            ALUCtrl_o <= alu_bne;
        end
        //addi
        3'b000:
        begin
            ALUCtrl_o <= alu_addi;
        end
        //sltiu
        3'b110:
        begin
            ALUCtrl_o <= alu_sltiu;
        end
        //lui
        3'b101:
        begin
            ALUCtrl_o <= alu_lui;
        end
        //ori
        3'b100:
        begin
            ALUCtrl_o <= alu_ori;
        end
    endcase
end
endmodule     