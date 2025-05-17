module reg_followed_by_mux(clk , enable , rst , in , out);
parameter RSTTYPE = "SYNC";
parameter WIDTH = 18;
parameter REG = 0;          //default no reg

input clk , enable , rst;
input [WIDTH-1 : 0] in;
output reg [WIDTH-1 : 0] out;

generate
    if(REG == 0)            //no reg.so,output = input
        begin
          //assign out = in;    //can not use assign with reg output
            always @(*) begin
                out = in;
            end
        end
    else
        begin
            if(RSTTYPE == "SYNC")           //synchronus control signal
                begin
                    always @(posedge clk) begin
                        if(rst)
                            out <= 0;       //non blocking assignment:sequential circuit
                        else if(enable)
                            out <= in;
                        else
                            out <= out;     //to prevent latch creation
                    end
                end
            else if(RSTTYPE == "ASYNC")     // Asynchronus control signal
                begin
                    always @(posedge clk , posedge rst) begin
                        if(rst)
                            out <= 0;
                        else if(enable)
                            out <= in;
                        else
                            out <= out;
                    end
                end
        end
endgenerate
endmodule