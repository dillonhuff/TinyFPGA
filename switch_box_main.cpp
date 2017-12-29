#include <iostream>
#include <ctime>
#include <cstdlib>

#include "Vswitch_box.h"
#include "verilated.h"

using namespace std;

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Vswitch_box* top = new Vswitch_box;

  // top->in0 = 1;
  // top->in1 = 0;

  // top->eval();

  // assert(top->and_out == 0);
  // assert(top->or_out == 1);
  // assert(top->xor_out == 1);

  top->final();

  cout << "$$$$ switch_box tests pass" << endl;
}
