#include "verilated.h"
#include "Vtop.h"

#include <vector>

using namespace std;

#define POSEDGE(signal) (signal) = 0; (signal) = 1;
#define NEGEDGE(signal) (signal) = 1; (signal) = 0;
#define RESET(signal) POSEDGE((signal)); NEGEDGE((signal));

// In0 In1 In2
// 1   2   3
// 4   5   6
// 7   8   9
// Ot0 Ot1 Ot2

// Tile input 1
void hand_written_test() {
  Vtop* top = new Vtop;

  RESET(top->reset);

  vector<unsigned long> config_addrs{1, 2, 4, 5, 8};
  vector<unsigned long> config_datas{};
  // IO in 0 -> 1 -> 4 -> 5,
  // IO in 1 -> 2 -> 5
  // 5 computes XOR
  // 5 output -> 8 -> IO out 1

  top->in_wire_0 = 1;
  top->in_wire_1 = 0;

  POSEDGE(top->clk);

  assert(top->out_wire_1 == 1);

  top->in_wire_0 = 0;
  top->in_wire_1 = 0;

  POSEDGE(top->clk);

  assert(top->out_wire_1 == 0);

  top->in_wire_0 = 1;
  top->in_wire_1 = 1;

  POSEDGE(top->clk);

  assert(top->out_wire_1 == 0);

}

int main() {
  hand_written_test();
}
