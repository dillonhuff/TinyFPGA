module switch_box(
                  output       left_0,
                  input        left_1,
                  output       left_2,
                  input        left_3,

                  input        right_0,
                  output       right_1,
                  input        right_2,
                  output       right_3,

                  input        top_0,
                  output       top_1,
                  input        top_2,
                  output       top_3,
                  
                  output       bottom_0,
                  input        bottom_1,
                  output       bottom_2,
                  input        bottom_3,

                  input clb_result,

                  input [15:0] config_data,
                  input        config_enable,
                  input        clk
                  );

   reg [15:0]                  config_data_reg;

   // Set configuration data
   always @(posedge clk)
     begin
        if (config_enable)
          begin
             config_data_reg <= config_data;
          end
     end

   wire [1:0] config_left_0;
   wire [1:0] config_left_2;

   wire [1:0] config_right_1;
   wire [1:0] config_right_3;

   wire [1:0] config_top_1;
   wire [1:0] config_top_3;
   
   wire [1:0] config_bottom_0;
   wire [1:0] config_bottom_2;

   assign config_left_0 = config_data_reg[1:0];
   assign config_left_2 = config_data_reg[3:2];

   assign config_right_1 = config_data_reg[5:4];
   assign config_right_3 = config_data_reg[7:6];

   assign config_top_1 = config_data_reg[9:8];
   assign config_top_3 = config_data_reg[11:10];

   assign config_bottom_0 = config_data_reg[13:12];
   assign config_bottom_2 = config_data_reg[15:14];

   always @(*)
     begin

        case (config_top_1)
          2'd0: top_1 = bottom_1;
          2'd1: top_1 = right_0;
          
          default: top_1 = clb_result;
        endcase

        case (config_top_3)
          2'd0: top_3 = bottom_3;

          default: top_3 = clb_result;
          
        endcase

        case (config_right_1)
          2'd0: right_1 = left_1;

          default: right_1 = clb_result;
          
        endcase

        case (config_right_3)
          2'd0: right_3 = left_3;
          
          default: right_3 = clb_result;
          
        endcase
        
        case (config_left_0)
          2'd0: left_0 = right_0;
          2'd1: left_0 = top_0;
          2'd2: left_0 = bottom_1;
          2'd3: left_0 = clb_result;
          
        endcase

        case (config_left_2)

          2'd0: left_2 = right_2;
          2'd1: left_2 = top_2;
          2'd2: left_2 = bottom_3;
          2'd3: left_2 = clb_result;
          
        endcase

        case (config_bottom_0)
          2'd0: bottom_0 = top_0;
          2'd1: bottom_0 = left_1;
          2'd2: bottom_0 = right_0;
          2'd3: bottom_0 = clb_result;
          
        endcase

        case (config_bottom_2)
          2'd0: bottom_2 = top_2;
          2'd1: bottom_2 = left_3;
          2'd2: bottom_2 = right_2;
          2'd3: bottom_2 = clb_result;
          
        endcase
        
     end
   
endmodule // switch_box
