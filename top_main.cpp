#include "verilated.h"
#include "Vtop.h"

#define POSEDGE(signal) (signal) = 0; (signal) = 1;
#define NEGEDGE(signal) (signal) = 1; (signal) = 0;
#define RESET(signal) POSEDGE((signal)); NEGEDGE((signal));

void hand_written_test() {
  Vtop* top = new Vtop;

  RESET(top->reset);

  
}

int main() {
  void hand_written_test();
}
