#include "Vio1_pad.h"
#include "verilated.h"

#define OUTPUT_PAD 1
#define INPUT_PAD 0

int main() {
  Vio1_pad* pad = new Vio1_pad();

  pad->tile_id = 1;
  pad->clk = 0;
  pad->reset = 0;
  pad->eval();

  pad->clk = 1;
  pad->config_data = OUTPUT_PAD;
  pad->config_addr = 1;
  pad->leaving_chip = 1;

  pad->eval();

  pad->clk = 0;

  assert(pad->pad == pad->leaving_chip);

  pad->leaving_chip = 0;

  pad->eval();

  assert(pad->pad == pad->leaving_chip);

  pad->clk = 1;
  pad->config_addr = 1;
  pad->config_data = INPUT_PAD;

  pad->eval();

  pad->clk = 0;
  pad->pad = 1;
  pad->entering_chip = 0;

  pad->eval();

  assert(pad->entering_chip == 1);
  
}
