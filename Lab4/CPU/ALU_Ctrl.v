//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     2.0
//--------------------------------------------------------------------------------
//Writer:      李柏漢0616077 陳昱螢0616091
//----------------------------------------------
//Date:        2019/05/17
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
input      [4-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
//R-type
parameter alu_and   = 4'd0;
parameter alu_or    = 4'd1;
parameter alu_addu  = 4'd2;
parameter alu_subu  = 4'd3;
parameter alu_slt   = 4'd4;
parameter alu_sra   = 4'd5;
parameter alu_srav  = 4'd6;

//I-type
parameter alu_beq   = 4'd7;
parameter alu_bne   = 4'd8; //bne bnez
parameter alu_addi  = 4'd9;
parameter alu_sltiu = 4'd10;
// parameter alu_lui   = 4'b1011;
parameter alu_ori   = 4'd11;

//new function
parameter alu_sll   = 4'd12; //perform as NOP
parameter alu_mul   = 4'd13;
parameter alu_jal   = 4'd14;

parameter dft   = 4'bxxxx;

//Select exact operation
always @ (*)
begin
    case (ALUOp_i)
        //R-type
        //add, sub, and, or, slt, sra, srav, jr, mul
        4'b0010:
        begin
            case (funct_i)
                6'b100100: ALUCtrl_o <= alu_and;  //and
                6'b100101: ALUCtrl_o <= alu_or;   //or
                6'b100001: ALUCtrl_o <= alu_addu; //addu
                6'b100011: ALUCtrl_o <= alu_subu; //subu
                6'b101010: ALUCtrl_o <= alu_slt;  //slt
                6'b000011: ALUCtrl_o <= alu_sra;  //sra
                6'b000111: ALUCtrl_o <= alu_srav; //srav
                6'b011000: ALUCtrl_o <= alu_mul;  //mul
                6'b000000: ALUCtrl_o <= alu_sll;  //sll
            endcase
        end

        //I-type
        4'b0001: ALUCtrl_o <= alu_beq;   //beq
        4'b0011: ALUCtrl_o <= alu_bne;   //bne bnez
        4'b0000: ALUCtrl_o <= alu_addi;  //addi
        4'b0110: ALUCtrl_o <= alu_sltiu; //sltiu
        4'b0100: ALUCtrl_o <= alu_ori;   //ori

        //lw sw
        4'b0101: ALUCtrl_o <= alu_addu;   //lw
        4'b0111: ALUCtrl_o <= alu_addu;   //sw

        //ble jal bltz
        4'b1000: ALUCtrl_o <= alu_subu;  //ble
        4'b1001: ALUCtrl_o <= alu_jal;  //jal
        4'b1010: ALUCtrl_o <= alu_subu; //bltz
        
        default: ALUCtrl_o <= dft;
    endcase
end
endmodule     