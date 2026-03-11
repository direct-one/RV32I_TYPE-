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
            case (i_funct3)
                3'b010:begin //SB
                    dmem[daddr[6:2]] <= dwdata;
                end 
                3'b001:begin //SH
                    if(daddr[1])begin
                    dmem[daddr[6:2]][31:16] <= dwdata[15:0];
                end else begin
                    dmem[daddr[6:2]][15:0] <= dwdata[15:0];
                end
                end 
                3'b000:begin //SW
                    case (daddr[1:0])
                        2'b00:dmem[daddr[6:2]][7:0] <= dwdata[7:0]; 
                        2'b01:dmem[daddr[6:2]][15:8] <= dwdata[7:0];
                        2'b10:dmem[daddr[6:2]][23:16] <= dwdata[7:0];
                        2'b11:dmem[daddr[6:2]][31:24] <= dwdata[7:0]; 
                    
                    endcase
                end
            endcase
        
        end
        
    end 

    assign drdata = dmem[daddr[6:2]];

endmodule

//before 
//if(i_funct3 == 3'b010)begin 
//            dmem[daddr[31:2]] <= dwdata;
//end



//module zero_extender (
//    input i_funct3
//    input drdata,
//    output o_drdata
//);
//
//    
//    
//endmodule