# Lab2 - Single-Cycle CPU (Simple Version)

### 操作指令
--

iverilog -o testbench.vvp Test\_Bench.v Simple\_Single\_CPU.v Adder.v ALU\_Ctrl.v ALU.v Decoder.v Instr\_Memory.v MUX\_2to1.v ProgramCounter.v Reg\_File.v Shift\_Left\_Two\_32.v Sign\_Extend.v

vvp testbench.vvp
 