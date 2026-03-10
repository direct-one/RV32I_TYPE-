`timescale 1ns / 1ps
`include "define.vh"


module rv32i_datapath(
        input         clk,
        input         rst,
        input         rf_we,
        input [ 3:0]  alu_control,
        input [31:0]  instr_data,
        output [31:0] instr_addr



    );

    logic [31:0] rd1, rd2,alu_result;

 program_counter U_PC (
    .clk(clk),
    .rst(rst),
    .program_counter(instr_addr)
);




    register_file U_REG_FILE (
    .clk(clk),
    //.rst(rst),
    .RA1(instr_data[19:15]),
    .RA2(instr_data[24:20]),
    .WA(instr_data[11:7]),
    .Wdata(alu_result),
    .rf_we(rf_we),
    .RD1(rd1),
    .RD2(rd2)
);

    alu U_ALU (
    .rd1(rd1),
    .rd2(rd2),
    .alu_control(alu_control), 
    .alu_result(alu_result)
);

endmodule



module register_file (
    input        clk,
    //input        rst,
    input  [4:0] RA1,  // instruction code RS1
    input  [4:0] RA2,  // instruction code RS2
    input  [4:0] WA,   // instruction code RD
    input [31:0] Wdata,     //instruction RD wirte data
    input        rf_we,     // Register File wirte enable
    output [31:0] RD1,      //Register File RS1 ouput 
    output [31:0] RD2       //Register File RS2 output 
);

    logic [31:0] register_file [0:31];

`ifdef SIMULATION
    initial begin
        for(int i =0; i<32; i++)begin
            register_file [i] = i;
        end
        
    end
`endif


    always_ff @( posedge clk) begin 
            if(rf_we)begin
                register_file[WA] <= Wdata;    
            
            end
        end


    //output CL

    assign RD1 = (RA1 != 0) ?  register_file[RA1]:0;
    assign RD2 = (RA2 != 0) ?  register_file[RA2]:0;
    
    
endmodule



module alu (
    input   logic [31:0] rd1,   //RS1  //$signed --> assign signed 
    input   logic [31:0] rd2,   //RS2
    input   logic [3:0]  alu_control,  //function7 [6],funct3 : 4bit   
    output  logic [31:0] alu_result
);

    always_comb begin 
        alu_result = 0;
        case (alu_control)
                `ADD:  alu_result = rd1 + rd2;  //add rd  = rs1 + rs2
                `SUB:  alu_result = rd1 - rd2; //sub rd = rs1 - rs2
                `SLL:  alu_result = rd1 << rd2 [4:0]; // SLL rd = rs1 << rs2
                `SLT:  alu_result = ($signed(rd1) < $signed(rd2)) ? 1:0; // slt rd = (rs1 < rs2) ? 1:0
                `SLTU: alu_result = (rd1 < rd2) ? 1 : 0; //slt_u rd = rs1 - rs2
                `XOR:  alu_result = rd1 ^ rd2; //xor rd = rs1 ^ rs2
                `SRL:  alu_result = rd1 >> rd2[4:0]; //SRL rd = rs1 >> rs2
                `SRA:  alu_result = $signed(rd1) >>> rd2[4:0]; //SRA rd = rs1 >> rs2, msb_extention, arithmetic right shift 
                `OR:   alu_result = rd1 | rd2; //or rd = rs1 | rs2
                `AND:  alu_result = rd1 & rd2; //and rd = rs1 & rs2
        endcase
    end
    
endmodule

module program_counter (
    input clk,
    input rst,
    output [31:0] program_counter
);

logic [31:0] pc_alu_out;

 pc_alu U_PC_ALU_4 (
    .a(32'd4),
    .b(program_counter), 
    .pc_alu_out(pc_alu_out) 
);

 register U_PC_REG (
    .clk(clk), 
    .rst(rst),
    .data_in(pc_alu_out),
    .data_out(program_counter)
);

    
endmodule


module pc_alu (
    input [31:0] a,
    input [31:0] b, 
    output [31:0] pc_alu_out 
);

assign pc_alu_out = a+b;
    
endmodule
module register (
    input clk, 
    input rst,
    input [31:0] data_in,
    output [31:0] data_out
);

logic [31:0] register;

always_ff @( posedge clk, posedge rst ) begin 
    
end
    
endmodule