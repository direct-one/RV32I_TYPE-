`timescale 1ns / 1ps


module instruction_mem(
    input [31:0] instr_addr,
    output [31:0] instr_data
    );

    logic [31:0] rom[0:31];

    initial begin
        rom[0] =32'h004182b3;  //  ADD X5, X3, X4
        rom[1] = 32'h00812123; // SW x2, 2(x8),
        rom[2] = 32'h00212383;  // LW, x7 x2, 2
        //rom[2] =32'h402852b3;
    end

    assign instr_data = rom[instr_addr[31:2]]; // delete '0', '1'

endmodule
