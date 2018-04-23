#include <iostream>
#include <ctime>
#include <cstdlib>
#include <bitset>

#include "Vpe_tile.h"
#include "verilated.h"

using namespace std;

#define CONFIG_SB 7
#define CONFIG_CB0 6
#define CONFIG_CB1 5
#define CONFIG_CLB 4

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

  top->in_wire_2_1 = 0;
  top->eval();

  assert(top->out_wire_1_0 == 0);

  // Low clock edge
  top->clk = 0;
  top->eval();

  // Configure CB0
  top->clk = 1;
  top->config_addr = 1 | (CONFIG_CB0 << 16);
  // op_0 <- in_wire_0_2
  top->config_data = 0 | 2;
  top->eval();

  // cout << "top->v__DOT__cb0__DOT__config_data_reg = " << (int) top->v__DOT__cb0__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__cb1__DOT__config_data_reg = " << (int) top->v__DOT__cb1__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__sb__DOT__config_data_reg = " << (int) top->v__DOT__sb__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__compute_block__DOT__config_data_reg = " << (int) top->v__DOT__compute_block__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__compute_block__DOT__reg_out = " << (int) top->v__DOT__compute_block__DOT__reg_out << endl << endl;
  
  top->clk = 0;
  top->eval();

  top->clk = 1;
  top->config_addr = 1 | (CONFIG_CLB << 16);
  top->config_data = 3;
  top->eval();

  // cout << "top->v__DOT__cb0__DOT__config_data_reg = " << (int) top->v__DOT__cb0__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__cb1__DOT__config_data_reg = " << (int) top->v__DOT__cb1__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__sb__DOT__config_data_reg = " << (int) top->v__DOT__sb__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__compute_block__DOT__config_data_reg = " << (int) top->v__DOT__compute_block__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__compute_block__DOT__reg_out = " << (int) top->v__DOT__compute_block__DOT__reg_out << endl << endl;
  
  top->clk = 0;
  top->eval();
  
  top->config_addr = 0;
  top->clk = 1;
  top->in_wire_0_2 = 1;
  top->eval();

  top->clk = 0;
  top->eval();

  top->clk = 1;
  top->eval();

  // cout << "top->v__DOT__cb0__DOT__config_data_reg = " << (int) top->v__DOT__cb0__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__cb1__DOT__config_data_reg = " << (int) top->v__DOT__cb1__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__sb__DOT__config_data_reg = " << (int) top->v__DOT__sb__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__compute_block__DOT__config_data_reg = " << (int) top->v__DOT__compute_block__DOT__config_data_reg << endl;
  // cout << "top->v__DOT__compute_block__DOT__reg_out = " << (int) top->v__DOT__compute_block__DOT__reg_out << endl << endl;;
  
  //assert(false);

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

  top->config_data = 0;

  top->in_wire_1_1 = 0;
  top->in_wire_0_2 = 1;
  top->eval();

  cout << "top->out_wire_0_0 = " << (int) top->out_wire_0_0 << endl;
  cout << "top->out_wire_0_1 = " << (int) top->out_wire_0_1 << endl;
  cout << "top->out_wire_0_2 = " << (int) top->out_wire_0_2 << endl;
  cout << "top->out_wire_0_3 = " << (int) top->out_wire_0_3 << endl;

  cout << "top->out_wire_1_0 = " << (int) top->out_wire_1_0 << endl;
  cout << "top->out_wire_1_1 = " << (int) top->out_wire_1_1 << endl;
  cout << "top->out_wire_1_2 = " << (int) top->out_wire_1_2 << endl;
  cout << "top->out_wire_1_3 = " << (int) top->out_wire_1_3 << endl;

  cout << "top->out_wire_2_0 = " << (int) top->out_wire_2_0 << endl;
  cout << "top->out_wire_2_1 = " << (int) top->out_wire_2_1 << endl;
  cout << "top->out_wire_2_2 = " << (int) top->out_wire_2_2 << endl;
  cout << "top->out_wire_2_3 = " << (int) top->out_wire_2_3 << endl;

  cout << "top->out_wire_3_0 = " << (int) top->out_wire_3_0 << endl;
  cout << "top->out_wire_3_1 = " << (int) top->out_wire_3_1 << endl;
  cout << "top->out_wire_3_2 = " << (int) top->out_wire_3_2 << endl;
  cout << "top->out_wire_3_3 = " << (int) top->out_wire_3_3 << endl;
  
  assert(top->out_wire_0_0 == 1);

  cout << "$$$$ PE tile tests pass" << endl;
}

int main(int argc, char** argv) {
  test_xor(argc, argv);
}
