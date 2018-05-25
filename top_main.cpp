#include "verilated.h"
#include "Vtop.h"

#include <vector>

using namespace std;

#define POSEDGE(signal) (signal) = 0; (signal) = 1;
#define NEGEDGE(signal) (signal) = 1; (signal) = 0;
#define RESET(signal) POSEDGE((signal)); NEGEDGE((signal));

void hand_written_test() {
  Vtop* top = new Vtop;

  RESET(top->reset);

  vector<unsigned long> config_addrs{1, 2, 4, 5, 8};
  // IO in 0 -> 1 -> 4 -> 5,
  // IO in 1 -> 2 -> 5
  // 5 computes XOR
  // 5 output -> 8 -> IO out 1
}

int main() {
  void hand_written_test();
}
