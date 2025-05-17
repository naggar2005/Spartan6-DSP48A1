module phase_2(clk , cea ,a_out ,rsta , ceb ,  b_out , rstb, d_out , opmode_6 , opmode_4
                , mult_out , BCOUT , conc_out);
parameter WIDTH = 18;
parameter A1REG = 1;
parameter B1REG = 1;
parameter RSTTYPE = "SYNC";

input [ WIDTH-1 : 0 ] a_out , b_out , d_out;
input opmode_6 , opmode_4 , cea , ceb , rsta , rstb , clk;
wire [ WIDTH-1 : 0 ] mux_out , mult_in1 , mult_in2 , adder_out;
wire adder_cout;        //negligable

output [17 : 0 ] BCOUT;
output [ 47 : 0 ] conc_out;
output [35 : 0] mult_out;

    adder_sub #(WIDTH) add_sub_1 (d_out , b_out , opmode_6 , 1'b0 , adder_cout, adder_out );

    assign mux_out = (opmode_4 == 0) ? b_out : adder_out ;
    reg_followed_by_mux #(RSTTYPE ,WIDTH , A1REG ) A1(clk , cea , rsta , a_out , mult_in1);      //de elly t7t
    reg_followed_by_mux #(RSTTYPE ,WIDTH , B1REG ) B1(clk , ceb , rstb , b_out , mult_in2);


    //outputs
    assign BCOUT =  mult_in2;
    assign conc_out = {d_out[11:0] , mult_in1 , mult_in2};

    assign mult_out = mult_in1 * mult_in2 ;



endmodule