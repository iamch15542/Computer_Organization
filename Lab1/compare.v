`timescale 1ns/1ps

module compare(
                cmp_control,   //3 bit control (input)
                less,            //1 bit less    (input)
                equal,           //1 bit equal   (intpu)
                result           //1 bit result  (output)
               );

input         less;
input         equal;
input [3-1:0] cmp_control;

output        result;

reg           result;

always @(*) 
begin
    case (cmp_control)
        3'b000:
        begin
            result = less;
        end
        3'b001:
        begin
            result = ~(less | equal);
        end
        3'b010:
        begin
            result = (less | equal);
        end
        3'b011:
        begin
            result = ~less;
        end
        3'b110:
        begin
            result = equal;
        end
        3'b100:
        begin
            result = ~equal;
        end
    endcase
end       

endmodule