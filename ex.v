
`include "defines.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ex(
    input wire rst,
    input wire[`AluOpBus] aluop_i,
    input wire[`AluSelBus] alusel_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o

    );

reg[`RegBus] logicout;

/*第一阶段:*/
always@(*) begin
    if(rst == `RstEnable) begin
        logicout <= `ZeroWord;
    end else begin
        case(aluop_i)
            `EXE_OR_OP:begin
                logicout <= reg1_i | reg2_i;
            end
            default: begin
                logicout <= `ZeroWord;
            end
        endcase
    end //if
end     //always

/*第二阶段:依据alusel_i指示的运算类�??,选择�??个运算结果作为最终结�??*/
always@(*) begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case (alusel_i)
        `EXE_RES_LOGIC: begin
            wdata_o <= logicout;
        end
        default: begin
            wdata_o <= `ZeroWord;
        end
    endcase
end


endmodule
