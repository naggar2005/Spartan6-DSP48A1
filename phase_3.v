module phase_3(mult_out , c_out , PCIN , PCOUT
             , opmode_1_0 , opmode_3_2 ,conc_out
             , clk , cem , rstm
             ,  M , mux_x_out , mux_z_out);

parameter RSTTYPE = "SYNC";
parameter MREG = 1;         //REGISTER
parameter WIDTH = 18;
parameter C_WIDTH = 48;

input clk , cem , rstm;
input [35:0] mult_out;
input [C_WIDTH-1 : 0] c_out , PCIN , PCOUT ;
input [47 : 0]  conc_out;
input [1:0] opmode_1_0 , opmode_3_2;

output [(WIDTH*2)-1:0] M;       //width = 36
output reg [C_WIDTH-1 : 0] mux_x_out , mux_z_out;
wire [(WIDTH*2)-1:0] mult_out_reg;

    reg_followed_by_mux #(RSTTYPE , WIDTH*2 , MREG)
                         mreg (clk , cem , rstm , mult_out , mult_out_reg);
    assign M = mult_out_reg;

    always @(*)
        begin
            case (opmode_1_0)         //x_mux
                2'b11: mux_x_out = conc_out;
                2'b10: mux_x_out = PCOUT;
                2'b01: mux_x_out = {12'b0,mult_out_reg};
                default: mux_x_out = 0;
            endcase

            case(opmode_3_2)
                2'b11: mux_z_out = c_out;
                2'b10: mux_z_out = PCOUT;
                2'b01: mux_z_out = PCIN;
                default: mux_z_out = 0;
            endcase
        end



endmodule