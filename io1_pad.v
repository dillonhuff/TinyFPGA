module io1_pad(input clk,
               input        reset,

               inout        pad,
               input        leaving_chip,
               output       entering_chip,

               /* verilator lint_off UNUSED */
               input [31:0] config_data,
               /* verilator lint_off UNUSED */
               input [31:0] config_addr,

               input [15:0] tile_id);

   reg                             io_mode;
   
   always @(posedge clk) begin
      if (reset) begin
         io_mode <= 1'b0;
      end else if (config_addr[15:0] == tile_id) begin
         io_mode <= config_data[0];
      end
   end

   assign pad = (io_mode == 1'b1) ? leaving_chip : 1'bz;
   
   assign entering_chip = pad;

endmodule; // io1_pad
