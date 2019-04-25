`timescale 1ns/1ps

module full_adder(
                x,         //1 bit source 1 (input)
                y,         //1 bit source 2 (input)
                cin,       //1 bit carry in (input)
                sum,       //1 bit sum      (output)
                cout       //1 bit carry out(output)
                );

input         x;
input         y;
input         cin;

output        sum;
output        cout;

wire          w1;
wire          w2;
wire          w3;

//sum
xor(w1, x, y);
xor(sum, w1, cin);

//carry out
and(w2, w1, cin);
and(w3, x, y);
or(cout, w2, w3);

endmodule