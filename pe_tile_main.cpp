#include <iostream>
#include <ctime>
#include <cstdlib>
#include <bitset>

#include "Vpe_tile.h"
#include "verilated.h"

using namespace std;

enum clb_func {
  CLB_FUNC_AND,
  CLB_FUNC_OR,
  CLB_FUNC_XOR,
};

enum switch_side {
  SWITCH_SIDE_TOP,
  SWITCH_SIDE_BOTTOM,
  SWITCH_SIDE_LEFT,
  SWITCH_SIDE_RIGHT
};

uint32_t set_switch_clb_out(const switch_side side,
                            const uint32_t track_no,
                            const uint32_t config) {

  assert(track_no <= 3);

  uint32_t new_config = config;

  //uint32_t track_no = ;
  
  return new_config;
}

uint32_t set_cb0(const uint8_t track_no, const uint32_t config) {
  uint32_t new_config = config;
  new_config = new_config | ((((1 << 2) - 1) & track_no));

  return new_config;
}

uint32_t set_cb1(const uint8_t track_no, const uint32_t config) {
  uint32_t new_config = config;
  uint32_t mask = ((((1 << 2) - 1) & track_no) << 2);

  cout << "mask   = " << bitset<32>(mask) << endl;

  new_config = new_config | mask;

  return new_config;
}

uint32_t set_clb(const clb_func func, const uint32_t config) {
  uint32_t func_no = 0;
  switch (func) {
  case CLB_FUNC_AND:
    func_no = 0;
    break;
  case CLB_FUNC_OR:
    func_no = 1;
    break;
  case CLB_FUNC_XOR:
    func_no = 2;
    break;
  default:
    assert(false);
  }

  uint32_t new_config = config;
  new_config = new_config | ((((1 << 2) - 1) & func_no) << 4);

  return new_config;
}

void test_xor(int argc, char** argv) {

  Verilated::commandArgs(argc, argv);
  Vpe_tile* top = new Vpe_tile;

  top->clk = 0;
  top->eval();

  top->clk = 1;
  top->config_en = 1;

  // 1:0 -> cb0_config
  // 3:2 -> cb1_config
  // 5:4 -> clb config
  // 21:6 -> sb_config
  uint32_t config = 0;
  config = config;

  cout << "config = " << bitset<32>(config) << endl;
  config = set_cb0(3, config);
  cout << "config = " << bitset<32>(config) << endl;
  config = set_cb1(1, config);
  cout << "config = " << bitset<32>(config) << endl;
  config = set_clb(CLB_FUNC_XOR, config);
  cout << "config = " << bitset<32>(config) << endl;
  config = set_switch_clb_out(SWITCH_SIDE_TOP, 1, config);

  top->config_data = config;

  top->eval();

  // Set args
  top->right_0 = 1;
  top->bottom_1 = 1;

  top->eval();

  assert(top->top_1 == 0);

  top->right_0 = 0;
  top->bottom_1 = 1;

  assert(top->top_1 == 1);

  cout << "$$$$ PE tile tests pass" << endl;
}

int main(int argc, char** argv) {
  //test_xor(argc, argv);
}
