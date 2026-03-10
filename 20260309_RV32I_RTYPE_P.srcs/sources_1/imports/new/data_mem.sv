`timescale 1ns / 1ps

module data_mem(
    input        clk,
    input        rst,
    input        dwe,
    input [2:0]  i_funct3,
    input [31:0] daddr,
    input [31:0] dwdata,
    output [31:0] drdata
    );


//byte address
//    logic [7:0]  dmem[0:31];
//
//    always_ff @( posedge clk, posedge rst ) begin : blockName
//        if (rst) begin
//            
//        end else begin 
//            if (dwe) begin
//                dmem[daddr+0] <= dwdata[7:0];
//                dmem[daddr+1] <= dwdata[15:8];
//                dmem[daddr+2] <= dwdata[23:16];
//                dmem[daddr+3] <= dwdata[31:24];
//            end
//        end 
//    end


    //block ram(word address) 
    logic [31:0] dmem[0:31];
    always_ff @( posedge  clk ) begin 
        if (dwe) begin
            if(i_funct3 == 3'b010)begin 
            dmem[daddr[31:2]] <= dwdata;
        end 
        end
        
    end 

    assign drdata = dmem[daddr[31:2]];

endmodule
