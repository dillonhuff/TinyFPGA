#include "Vswitch_box.h"
#include "verilated.h"

#include <iostream>
#include <vector>

using namespace std;

#define POSEDGE(signal, val) (signal) = 0; (val)->eval(); (signal) = 1; (val)->eval();
#define NEGEDGE(signal, val) (signal) = 1; (val)->eval(); (signal) = 0; (val)->eval();
#define RESET(signal, val) POSEDGE((signal), (val)); NEGEDGE((signal), (val)); POSEDGE((signal), (val));

void handwritten_passthrough_test() {
  Vswitch_box* top = new Vswitch_box();

  RESET(top->rst, top);

  uint32_t data0 = 3 << 8;
  top->config_en = 1;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  top->side_3_track_0_in = 1;
  POSEDGE(top->clk, top);

  assert(top->side_1_track_0_out == top->side_3_track_0_in);

  top->side_3_track_0_in = 0;
  POSEDGE(top->clk, top);

  assert(top->side_1_track_0_out == top->side_3_track_0_in);

  delete top;
}

int main() {
  handwritten_passthrough_test();
  cout << "$$$ Switch box tests passed" << endl;
}
