# Lab2 - Single-Cycle CPU (Simple Version)

### 操作指令
***

iverilog -o testbench.vvp Test\_Bench.v Simple\_Single\_CPU.v Adder.v ALU\_Ctrl.v ALU.v Decoder.v Instr\_Memory.v MUX\_2to1.v ProgramCounter.v Reg\_File.v Shift\_Left\_Two\_32.v Sign\_Extend.v

vvp testbench.vvp

### Reference
***

[MIPS Reference Sheet](https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_help.html)

[Plasma - most MIPS I(TM) opcodes :: Opcodes](https://opencores.org/projects/plasma/opcodes)

[The Control Unit](http://www.pitt.edu/~kmram/CoE0147/lectures/datapath3.pdf)

[The Control Unit 2](http://fourier.eng.hmc.edu/e85_old/lectures/processor/node5.html)