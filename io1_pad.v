module io1_pad(input clk,
               input        reset,

               inout        pad,
               input        f2p,
               output       p2f,

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

   assign pad = (io_mode == 1'b1) ? f2p : 1'bz;
   assign p2f = pad;

endmodule; // io1_pad
