#include "Vpe_tile_bottom.h"
#include "verilated.h"

#include <iostream>

using namespace std;

#define CONFIG_SB 7
#define CONFIG_CB0 6
#define CONFIG_CB1 5
#define CONFIG_CLB 4

int main() {
  Vpe_tile_bottom* pe = new Vpe_tile_bottom();
  pe->clk = 0;
  pe->reset = 0;
  pe->tile_id = 5;
  pe->eval();

  pe->clk = 1;
  // out_wire_1_0 = in_wire_0_3
  pe->config_data = 2 << 8;
  pe->config_addr = 5 | (CONFIG_SB << 16);
  pe->eval();

  pe->clk = 0;
  pe->config_addr = 8;
  pe->in_wire_0_3 = 1;
  pe->eval();

  assert(pe->out_wire_1_0 == 1);

  cout << "$$$ pe_tile_bottom_tests passed" << endl;

}
