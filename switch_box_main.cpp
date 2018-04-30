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
  top->reset = 0;
  top->eval();

  // Set configuration
  top->clk = 1;
  top->config_en = 1;
  // Identity function
  top->config_data = 3;

  top->eval();

  top->clk = 0;
  top->eval();

  top->clk = 1;
  top->config_en = 0;
  top->pe_output_0 = 5;
  
  top->eval();

  assert(top->out_wire_0_0 == top->pe_output_0);

  top->clk = 0;
  top->config_data = 0;
  top->eval();

  top->clk = 1;
  top->config_data = 0;
  top->pe_output_0 = 7;

  top->eval();


  assert(top->out_wire_0_0 == top->pe_output_0);
  
  cout << "$$$$ switch_box tests pass" << endl;
}
