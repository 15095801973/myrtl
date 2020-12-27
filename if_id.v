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


module if_id(
	input wire clk,
    input wire rst,
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus] if_inst,

    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst
    );

    always@(posedge clk) begin
    if (rst == `RstEnable) begin
        id_pc <= `ZeroWord;
        id_inst <= `ZeroWord;
    end else begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
    end


	
endmodule
