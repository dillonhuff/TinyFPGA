#include <iostream>
#include <ctime>
#include <cstdlib>

#include "Vswitch_box.h"
#include "verilated.h"

using namespace std;

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Vswitch_box* top = new Vswitch_box;

  // Initialize
  top->clk = 0;
  top->eval();

  // Set configuration
  top->clk = 1;
  top->config_enable = 1;
  // Identity function
  top->config_data = 0;

  top->eval();

  top->clk = 0;

  top->config_enable = 0;

  top->left_1 = 1;
  top->left_3 = 1;

  top->eval();

  assert(top->right_1 == top->left_1);
  assert(top->right_3 == top->left_3);

  top->config_enable = 1;
  top->config_data = 1;
  top->clk = 1;

  top->top_0 = 1;

  top->eval();

  assert(top->left_0 == top->top_0);

  top->final();

  cout << "$$$$ switch_box tests pass" << endl;
}
