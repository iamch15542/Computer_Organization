`timescale 1ns/1ps

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		       bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input  [4-1:0]  ALU_control;
input  [3-1:0]  bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire   [32-1:0] result;
wire   [32-1:0] set;
wire   [32-1:0] carryout;
reg             less;
reg             cout;
reg             overflow;
reg             zero;

generate
  genvar i;
  for(i = 0; i < 32; i = i + 1)
  begin
    if(i == 0)
      begin
        alu_top alut(src1[0], 
                     src2[0],
                     less,
                     ALU_control[3],
                     ALU_control[2],
                     ALU_control[2],
                     ALU_control[1:0],
                     (set == 0) & ~overflow,
                     bonus_control[2:0],
                     result[0],
                     carryout[0],
                     set[0]
                     );
      end
    else
      begin
        alu_top alut(src1[i], 
                     src2[i],
                     1'b0,
                     ALU_control[3],
                     ALU_control[2],
                     carryout[i - 1],
                     ALU_control[1:0],
                     1'b0,
                     3'b000,
                     result[i],
                     carryout[i],
                     set[i]
                     );
      end
  end
endgenerate

//Set less than
always @(*) 
begin
  if (set[31] ^ overflow) 
  begin
    less = 1'b1;
  end
  else 
  begin
    less = 1'b0;
  end
end

//carry out
always @ (*)
begin
  if(ALU_control == 4'b0010 || ALU_control == 4'b0110)
    begin
      cout = carryout[31];
    end
  else
    begin
      cout = 0;
    end
end

//overflow
always @(*) 
begin
  if (ALU_control == 4'b0010 || ALU_control == 4'b0110) 
    begin
      overflow = carryout[31] ^ carryout[30];
    end
  else 
    begin
      overflow = 0;
    end
end

//zero
always @(*) 
begin
  if (result == 0) 
    begin
      zero = 1;
    end
  else 
    begin
      zero = 0;
    end
end

endmodule
