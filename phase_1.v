module phase_1(clk , a , rsta , cea, b , rstb , ceb , c , rstc , cec , d , rstd , ced , BCIN
                ,a_out , b_out , c_out , d_out);
parameter A0REG = 0;
parameter B0REG = 0;
parameter CREG = 0;
parameter DREG = 0;
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";
parameter WIDTH = 18;
parameter C_WIDTH = 48;

input clk , rsta , rstb , rstc , rstd;
input cea , ceb , cec , ced;
input [ WIDTH-1 : 0 ] a , b , d , BCIN;
input  [ C_WIDTH-1 : 0 ] c;
wire   [ WIDTH-1 : 0 ] b_in;

output [ WIDTH-1 : 0 ] a_out , b_out , d_out;
output  [ C_WIDTH-1 : 0 ] c_out;

    generate
        if(B_INPUT == "DIRECT")
            assign b_in = b;
        else if(B_INPUT == "CASCADE")
            assign b_in = BCIN;
        else
            assign bin = 0;
    endgenerate

            //Instantiations
    reg_followed_by_mux#(RSTTYPE ,WIDTH , A0REG ) A0(clk , cea , rsta , a , a_out);
    reg_followed_by_mux#(RSTTYPE ,WIDTH , B0REG ) B0(clk , ceb , rstb , b_in , b_out);
    reg_followed_by_mux#(RSTTYPE ,WIDTH , DREG ) D0(clk , ced , rstd , d , d_out);
    reg_followed_by_mux#(RSTTYPE ,C_WIDTH , CREG ) C0(clk , cec , rstc , c , c_out);


endmodule