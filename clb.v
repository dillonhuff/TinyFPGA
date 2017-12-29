module clb(input in0,
           input  in1,
           output out,

           input clk,
           input config_enable,
           input [1:0] config_data);

   reg [1:0]           config_data_reg;

   always @(posedge clk)
     begin
        if (config_enable)
          begin
             config_data_reg <= config_data;
          end
     end

   wire                and_out, or_out, xor_out;

   assign and_out = in0 & in1;
   assign or_out = in0 | in1;
   assign xor_out = in0 ^ in1;

   always @(*)
     begin
        case (config_data_reg)
          2'd0: out = and_out;
          2'd1: out = or_out;
          2'd2: out = xor_out;
          default: out = and_out;
        endcase
     end
   
endmodule; // clb
