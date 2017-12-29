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

                  input [31:0] config_data,
                  input config_enable,
                  input        clk
                  );

   reg [31:0]                  config_data_reg;

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

        
        // // Configure left_0
        // if (config_data_reg[1:0] == 2'd0)
        //   begin
        //      left_0 <= right_0;
        //   end

        // if (config_data_reg[3:2] == 2'd1)
        //   begin
        //      left_0 <= top_0;
        //   end

        // if (config_data_reg[5:4] == 2'd3)
        //   begin
        //      left_0 <= bottom_1;
        //   end

        // // Configure left_2
        // if (config_data_reg[] == 2'd0)
        //   begin
        //      left_2 <= right_0;
        //   end

        // if (config_data_reg[8:7] == 2'd1)
        //   begin
        //      left_2 <= top_0;
        //   end

        // if (config_data_reg[10:9] == 2'd3)
        //   begin
        //      left_2 <= bottom_1;
        //   end

     end
   
endmodule // switch_box
