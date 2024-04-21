**DECODE STAGE**

It uses the same components as RF but includes 6 new files:

1) mux2_1 multiplexer to handle the alu_out, mem_out

2) mux2_1_5bit that handles the instr part

3) imm_handler that does the zerofill, singextend, shift

4) small_matrix **Package** that creates a matrix with size of 5

5) **new top entity** DECSTAGE.vhd along with its 

6) testbench for DECSTAGE
