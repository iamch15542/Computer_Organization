//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      李柏漢0616077 陳昱螢0616091
//----------------------------------------------
//Date:        2019/04/25
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input       clk_i;
input       rst_i;

//Internal Signles
wire        RegDst_ctrl,
            RegWrite_ctrl,
            AluSrc_ctrl,
            Branch_ctrl,
            Branch_set,
            Alu_zero;

wire [3-1:0]    AluOp_ctrl;
wire [4-1:0]    AluOpcode;
wire [5-1:0]    instr_rs,
                instr_rt,
                instr_rd,
                instr_shamt,
                WriteReg_addr;
wire [6-1:0]    instr_op,
                instr_func;
wire [16-1:0]   instr_immdt;
wire [32-1:0]   AluSrc1,
                AluSrc2,
                AluSrc2_reg,
                instr,
                Branch_addr,
                pc_next,
                pc_data,
                pc_add4,
                WriteReg_data,
                immdt_32,
                Shift_rst;

assign {instr_op, instr_rs, instr_rt, instr_rd, instr_shamt, instr_func} = instr;
assign instr_immdt = instr[15:0];
assign Branch_set = Alu_zero & Branch_ctrl;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_next) ,   
	    .pc_out_o(pc_data) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_data),     
	    .sum_o(pc_add4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_data),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_rt),
        .data1_i(instr_rd),
        .select_i(RegDst_ctrl),
        .data_o(WriteReg_addr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .RSaddr_i(instr_rs),  
        .RTaddr_i(instr_rt),  
        .RDaddr_i(WriteReg_addr),  
        .RDdata_i(WriteReg_data), 
        .RegWrite_i(RegWrite_ctrl),
        .RSdata_o(AluSrc1),  
        .RTdata_o(AluSrc2_reg)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_op), 
	    .RegWrite_o(RegWrite_ctrl), 
	    .ALU_op_o(AluOp_ctrl),   
	    .ALUSrc_o(AluSrc_ctrl),   
	    .RegDst_o(RegDst_ctrl),   
		.Branch_o(Branch_ctrl)   
	    );

ALU_Ctrl AC(
        .funct_i(instr_func),   
        .ALUOp_i(AluOp_ctrl),   
        .ALUCtrl_o(AluOpcode) 
        );
	
Sign_Extend SE(
        .data_i(instr_immdt),
        .data_o(immdt_32)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(AluSrc2_reg),
        .data1_i(immdt_32),
        .select_i(AluSrc_ctrl),
        .data_o(AluSrc2)
        );	
		
ALU ALU(
        .src1_i(AluSrc1),
	    .src2_i(AluSrc2),
	    .ctrl_i(AluOpcode),
	    .shamt(instr_shamt),
	    .result_o(WriteReg_data),
		.zero_o(Alu_zero)
	    );
		
Adder Adder2(
        .src1_i(pc_add4),     
	    .src2_i(Shift_rst),     
	    .sum_o(Branch_addr)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(immdt_32),
        .data_o(Shift_rst)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_add4),
        .data1_i(Branch_addr),
        .select_i(Branch_set),
        .data_o(pc_next)
        );	

endmodule
		  


