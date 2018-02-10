#include "Vswitch_box_bottom.h"
#include "verilated.h"

#include <iostream>

using namespace std;

int main() {
  Vswitch_box_bottom* sb = new Vswitch_box_bottom();

  sb->clk = 0;
  sb->reset = 0;
  sb->eval();

  sb->clk = 1;
  // out_wire_1_0 = in_wire_0_3
  sb->config_data = 2 << 8;
  sb->config_en = 1;
  sb->eval();

  sb->clk = 0;
  sb->config_en = 0;
  sb->in_wire_0_3 = 1;
  sb->eval();

  assert(sb->out_wire_1_0 == 1);

  cout << "$$$ switch_box_bottom_tests passed" << endl;
}
