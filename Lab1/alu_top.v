`timescale 1ns/1ps

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               equal,      //1 bit equal    (input)
               cmpcontrol, //3 bit cmpctrl  (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               set         //1 bit set      (output)
               );

input         src1;
input         src2;
input         less;
input         equal;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
input [3-1:0] cmpcontrol;

output        result;
output        cout;
output        set;

reg           result;
reg           cout;
reg           tmpsrc1;
reg           tmpsrc2;

wire          set;
wire          tmpcout;
wire          tmpresult;


full_adder fa(tmpsrc1, tmpsrc2, cin, set, tmpcout);

compare comp(cmpcontrol, less, equal, tmpresult);

always @ (*)
begin
     case (A_invert)
          1'b0:
          begin
               tmpsrc1 = src1;
          end
          1'b1:
          begin
               tmpsrc1 = ~src1;   
          end
     endcase
     case (B_invert)
          1'b0:
          begin
               tmpsrc2 = src2;
          end
          1'b1:
          begin
               tmpsrc2 = ~src2;   
          end
     endcase
     case (operation)
          2'b00:
          begin
               result = tmpsrc1 & tmpsrc2;
          end
          2'b01:
          begin
               result = tmpsrc1 | tmpsrc2;
          end
          2'b10:
          begin
               result = set;
               cout = tmpcout;
          end
          2'b11:
          begin
               result = tmpresult;
               cout = tmpcout;
          end
     endcase
end

endmodule
