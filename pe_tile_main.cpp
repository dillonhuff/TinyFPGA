#include <iostream>
#include <ctime>
#include <cstdlib>
#include <bitset>

#include "Vpe_tile.h"
#include "verilated.h"

using namespace std;

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

uint32_t set_clb(const uint8_t func_no, const uint32_t config) {
  uint32_t new_config = config;
  new_config = new_config | ((((1 << 2) - 1) & func_no) << 4);

  return new_config;
}

int main(int argc, char** argv) {

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
  config = set_cb0(0, config);
  cout << "config = " << bitset<32>(config) << endl;
  config = set_cb1(1, config);
  cout << "config = " << bitset<32>(config) << endl;

  top->config_data = config;

  cout << "$$$$ PE tile tests pass" << endl;
}
