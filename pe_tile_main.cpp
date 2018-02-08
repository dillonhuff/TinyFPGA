#include <iostream>
#include <ctime>
#include <cstdlib>
#include <bitset>

#include "Vpe_tile.h"
#include "verilated.h"

using namespace std;

#define CONFIG_SB 7
#define CONFIG_CLB 6
#define CONFIG_CB0 5
#define CONFIG_CB1 4

void test_xor(int argc, char** argv) {

  Verilated::commandArgs(argc, argv);
  Vpe_tile* top = new Vpe_tile;

  // Initialize the circuit
  top->clk = 0;
  top->tile_id = 1;
  top->reset = 0;
  top->eval();

  // Configure the switch box
  top->clk = 1;
  top->config_addr = 1 | (CONFIG_SB << 16);
  // out_wire_0_0 <- pe_output_0
  top->config_data = 0 | (3);

  top->eval();

  top->config_addr = 0;

  top->in_wire_2_1 = 1;
  top->in_wire_3_2 = 0;
  top->in_wire_0_3 = 0;

  top->eval();

  assert(top->out_wire_1_0 == 1);

  // Low clock edge
  top->clk = 0;
  top->eval();

  // Configure CB0
  top->clk = 1;
  top->config_addr = 1 | (CONFIG_CB0 << 16);
  // op_0 <- in_wire_0_2
  top->config_data = 0 | 2;
  top->eval();

  // Low clock edge
  top->clk = 0;
  top->eval();

  // Configure CB1
  top->clk = 1;
  top->config_addr = 1 | (CONFIG_CB1 << 16);
  // op_1 <- in_wire_1_1
  top->config_data = 0 | 1;
  top->eval();

  // Low clock edge
  top->clk = 0;
  top->eval();

  // Configure CLB
  top->clk = 1;
  top->config_addr = 1 | (CONFIG_CLB << 16);
  // clb function = xor
  top->config_data = 2;
  top->eval();

  top->clk = 0;
  top->eval();

  top->in_wire_1_1 = 0;
  top->in_wire_0_2 = 1;
  top->eval();

  assert(top->out_wire_0_0 == 1);

  cout << "$$$$ PE tile tests pass" << endl;
}

int main(int argc, char** argv) {
  test_xor(argc, argv);
}
