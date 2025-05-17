module adder_sub(in1 , in2 , opmode , cin , cout , out );
parameter WIDTH = 18;
input opmode , cin;
input [WIDTH-1 : 0 ] in1 , in2;
output cout;
output [WIDTH-1 : 0 ] out;

/*    always @(*) begin
        case (opmode)
            1'b0:  {cout , out} = in1 + in2 + cin;
            1'b1:  {cout , out} = in1 - in2;
        endcase
    end
*/
    assign {{cout , out}} = (opmode == 0) ? in1 + in2 + cin : in1 - in2;


endmodule