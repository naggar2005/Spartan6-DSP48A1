module main(CLK , OPMODE_IN ,
            A , B , C , D , BCIN , PCIN , CARRYIN , 
            CEA , CEB , CEC , CED , CECARRYIN , CEM , CEOPMODE , CEP ,
            RSTA , RSTB , RSTC , RSTD , RSTCARRYIN , RSTM , RSTOPMODE , RSTP ,
            BCOUT , CARRYOUT , CARRYOUTF , PCOUT , P , M);


parameter A0REG =0;
parameter A1REG =1;
parameter B0REG =0;
parameter B1REG =1;
parameter CREG =1;
parameter DREG =1;
parameter MREG =1;
parameter PREG =1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT="DIRECT";
parameter RSTTYPE = "SYNC";
            //      parameters written by me
parameter WIDTH = 18;
parameter C_WIDTH = 48;

input [ WIDTH-1 : 0 ] A , B , D , BCIN;
input [47:0] PCIN;
input [ C_WIDTH-1 : 0 ] C;
input CARRYIN , CLK;
input [7:0] OPMODE_IN;
input CEA , CEB , CEC , CECARRYIN , CED , CEM , CEOPMODE , CEP;
input RSTA , RSTB , RSTC , RSTD , RSTCARRYIN , RSTM , RSTOPMODE , RSTP;


output [47:0] P , PCOUT ;
output [17:0] BCOUT;
output [35:0] M;
output CARRYOUT , CARRYOUTF;

wire [7:0] OPMODE;

reg_followed_by_mux #(RSTTYPE , 8 , OPMODEREG) OPREG (CLK , CEOPMODE , RSTOPMODE , OPMODE_IN , OPMODE);



wire [ WIDTH-1 : 0 ] a_out , b_out , d_out;
wire  [ C_WIDTH-1 : 0 ] c_out;

    phase_1 #(A0REG , B0REG , CREG , DREG , B_INPUT , RSTTYPE , WIDTH , C_WIDTH)
         p1 (CLK , A , RSTA , CEA, B , RSTB , CEB , C , RSTC , CEC , D , RSTD , CED , BCIN
            ,a_out , b_out , c_out , d_out);

wire [35 : 0] mult_out;
wire [ 47 : 0 ] conc_out;

    phase_2 #(WIDTH , A1REG , B1REG , RSTTYPE) 
            P2(CLK , CEA ,a_out ,RSTA , CEB ,  b_out , RSTB, d_out , OPMODE[6] , OPMODE[4]
            , mult_out , BCOUT , conc_out);

wire [C_WIDTH-1 : 0] mux_x_out , mux_z_out;


phase_3 #(RSTTYPE , MREG , WIDTH , C_WIDTH) 
            P3(mult_out , c_out , PCIN , PCOUT
             , OPMODE[1:0] , OPMODE[3:2] , conc_out
             , CLK , CEM , RSTM
             ,  M , mux_x_out , mux_z_out);



phase_4 #(PREG , CARRYINREG , CARRYOUTREG , RSTTYPE , C_WIDTH , CARRYINSEL) 
        P4( CLK , CECARRYIN , RSTCARRYIN ,CEP , RSTP         
        , OPMODE[5] , OPMODE[7] ,CARRYIN , mux_x_out , mux_z_out
        , P , PCOUT , CARRYOUT , CARRYOUTF);



endmodule