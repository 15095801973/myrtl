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


module id(
    input wire rst,
    input wire[`InstAddrBus] pc_i,
    input wire[`InstBus] inst_i,

    //处于执行阶段的指令的运算结果
    input wire ex_wreg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,

    //处于访存阶段的指令的运算结果
    input wire mem_wreg_i,
    input wire[`RegBus] mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,

    input wire[`RegBus] reg1_data_i,
    input wire[`RegBus] reg2_data_i,

    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,

    output reg[`AluOpBus] aluop_o,
    output reg[`AluSelBus] alusel_o,
    output reg[`RegBus] reg1_o,
    output reg[`RegBus] reg2_o,
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o

    );

wire[5:0] op = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];

reg[`RegBus] imm;

reg instvalid;

/*第一阶段:对指令进行译码*/
always@(*) begin
    if(rst == `RstEnable) begin
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= `NOPRegAddr;
        wreg_o <= `WriteDisable;
        instvalid <= `InstValid;
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        reg1_addr_o <= `NOPRegAddr;
        reg2_addr_o <= `NOPRegAddr;
        imm <= 32'h0;
    end else begin 
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= inst_i[15:11];
        wreg_o <= `WriteDisable;
        instvalid <= `InstValid;
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        reg1_addr_o <= inst_i[25:21];
        reg2_addr_o <= inst_i[20:16];
        imm <= `ZeroWord;

        case(op)
            `EXE_SPECIAL_INST: begin
                case(op2)
                    5'b00000: begin
                        case(op3)
                            `EXE_OR:begin
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_OR_OP;
                                alusel_o <= `EXE_RES_LOGIC;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_AND:begin
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_AND_OP;
                                alusel_o <= `EXE_RES_LOGIC;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_XOR:begin
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_XOR_OP;
                                alusel_o <= `EXE_RES_LOGIC;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_NOR:begin
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_NOR_OP;
                                alusel_o <= `EXE_RES_LOGIC;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_SLLV:begin
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_SLL_OP;
                                alusel_o <= `EXE_RES_SHIFT;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_SRLV:begin
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_SRL_OP;
                                alusel_o <= `EXE_RES_SHIFT;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_SRAV:begin  //srav  zhiling
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_SRA_OP;
                                alusel_o <= `EXE_RES_SHIFT;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            `EXE_SYNC:begin  //sync  zhiling
                                wreg_o <= `WriteEnable;
                                aluop_o <= `EXE_NOP_OP;
                                alusel_o <= `EXE_RES_NOP;
                                reg1_read_o <= 1'b1;
                                reg2_read_o <= 1'b1;
                                instvalid <= `InstValid;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    default:begin
                        
                    end
                endcase
            end
            `EXE_ORI: begin  //ori  zhiling
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
            end
            `EXE_ANDI: begin  //andi  zhiling
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_AND_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
            end
            `EXE_XORI: begin  //xori  zhiling
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_XOR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
            end
            `EXE_LUI: begin  //lui zhiling
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {inst_i[15:0], 16'h0};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
            end
            `EXE_PREF: begin //pref zhiling
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            instvalid <= `InstValid;
            end
            default: begin
            end

        endcase

        if(inst_i[31:21] == 11'b00000000000) begin
            if(op3 == `EXE_SLL) begin    //sll
                wreg_o <= `WriteEnable;
                aluop_o <= `EXE_SLL_OP;
                alusel_o <= `EXE_RES_SHIFT;
                reg1_read_o <= 1'b0;
                reg2_read_o <= 1'b1;
                imm <= inst_i[10:6];
                wd_o <= inst_i[15:11];
                instvalid <= `InstValid;
            end else if(op3 == `EXE_SRL) begin //srl
                wreg_o <= `WriteEnable;
                aluop_o <= `EXE_SRL_OP;
                alusel_o <= `EXE_RES_SHIFT;
                reg1_read_o <= 1'b0;
                reg2_read_o <= 1'b1;
                imm <= inst_i[10:6];
                wd_o <= inst_i[15:11];
                instvalid <= `InstValid;
            end else if(op3 == `EXE_SRA) begin //sra
                wreg_o <= `WriteEnable;
                aluop_o <= `EXE_SRA_OP;
                alusel_o <= `EXE_RES_SHIFT;
                reg1_read_o <= 1'b0;
                reg2_read_o <= 1'b1;
                imm <= inst_i[10:6];
                wd_o <= inst_i[15:11];
                instvalid <= `InstValid;
            end
        end
    end //if else 
end //always

/*第二阶段:确定进行运算的源操作数1*/
//给reg1_o赋值的过程增加了两种情况:
//1.读取的寄存器就是执行阶段要写的目的寄存器,
//那么把ex_wdata_i作为reg1_o的值;
//2.如果端口1要读取的寄存器就是访存阶段要写的目的寄存器,
//那么把mem_wdata_i作为reg1_o的值;
always@(*)begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
    end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1)
                && (ex_wd_i == reg1_addr_o)) begin
        reg1_o <= ex_wdata_i;
    end else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1)
                && (mem_wd_i == reg1_addr_o)) begin
        reg1_o <= mem_wdata_i;
    end else if(reg1_read_o ==1'b1) begin
        reg1_o <= reg1_data_i;
    end else if(reg1_read_o == 1'b0) begin
        reg1_o <= imm;
    end else begin
        reg1_o <= `ZeroWord;
    end
end

/*第三阶段:确定进行运算的源操作数2*/
//给reg1_o赋值的过程增加了两种情况:同reg1_o
always@(*)begin
    if(rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
    end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1)
                && (ex_wd_i == reg2_addr_o)) begin
        reg2_o <= ex_wdata_i;
    end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1)
                && (mem_wd_i == reg2_addr_o)) begin
        reg2_o <= mem_wdata_i;
    end else if(reg2_read_o ==1'b1) begin
        reg2_o <= reg2_data_i;
    end else if(reg2_read_o == 1'b0) begin
        reg2_o <= imm;
    end else begin
        reg2_o <= `ZeroWord;
    end
end

endmodule
