module phase_4( clk , CECARRYIN , RSTCARRYIN ,CEP , RSTP                 //Signals & clock enables
                , opmode_5 , opmode_7 ,CARRYIN , mux_x_out , mux_z_out
                , P , PCOUT , CARRYOUT , CARRYOUTF);

parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter RSTTYPE = "SYNC";
parameter C_WIDTH = 48;
parameter CARRYINSEL = "OPMODE5";


input clk ,  CECARRYIN , RSTCARRYIN , CEP , RSTP;
input opmode_5 , opmode_7 ,CARRYIN;
input [C_WIDTH-1 : 0] mux_x_out , mux_z_out;

wire CYIinput , CYIoutput , cout ;
generate
    if(CARRYINSEL == "OPMODE5")
        assign CYIinput = opmode_5;
    else if(CARRYINSEL == "CARRYIN")
        assign CYIinput = CARRYIN;
    else
        assign CYIinput = 0;
endgenerate

output CARRYOUT , CARRYOUTF;
output  [C_WIDTH-1 : 0] P ;
output  [C_WIDTH-1 : 0] PCOUT;
wire [C_WIDTH-1 : 0] p1;


    reg_followed_by_mux #(RSTTYPE , 1 , CARRYINREG) CYI(clk , CECARRYIN , RSTCARRYIN , CYIinput , CYIoutput); 
    post_adder_sub #(C_WIDTH) post_adder_sub(mux_z_out , mux_x_out , opmode_7 , CYIoutput , cout , p1 );

    reg_followed_by_mux #(RSTTYPE , C_WIDTH , PREG) pREG(clk , CEP , RSTP , p1 , P); 
    assign PCOUT = P;
    reg_followed_by_mux #(RSTTYPE , 1 , CARRYOUTREG) CYO(clk , CECARRYIN , RSTCARRYIN , cout , CARRYOUT); 
    assign CARRYOUTF = CARRYOUT;


endmodule