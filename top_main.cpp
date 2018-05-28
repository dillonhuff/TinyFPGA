#include "verilated.h"
#include "Vtop.h"

#include <vector>

using namespace std;

// Maybe an intermediate step is to generate an intermediate
// placed application format and a bitstream converter for that
// format

#define POSEDGE(signal) (signal) = 0; (signal) = 1;
#define NEGEDGE(signal) (signal) = 1; (signal) = 0;
#define RESET(signal) POSEDGE((signal)); NEGEDGE((signal));

// In0 In1 In2
// 1   2   3
// 4   5   6
// 7   8   9
// Ot0 Ot1 Ot2

// What should this format be?
// Map from tile components to configurations?

// tile_id_end = 15
// tile_id_begin = 0
// mod_id_end = 31
// mod_id_begin = 16

// clb_addr = 4
// cb1_addr = 5
// cb0_addr = 6
// sb_addr = 7

enum PE_component {
  PE_COMPONENT_CB0,
  PE_COMPONENT_CB1,
  PE_COMPONENT_SB,
  PE_COMPONENT_CLB
};

struct config_address_structure {
  const int width;
  const int mod_id_begin;
  const int mod_id_end;
  const int tile_id_begin;
  const int tile_id_end;
};

uint32_t config_address(const uint32_t tile_id,
                        const PE_component component) {
  
}

void hand_written_test() {
  Vtop* top = new Vtop;

  RESET(top->reset);

  vector<unsigned long> config_addrs{1, 2, 4, 5, 8};
  // IO in 0 -> 1 -> 4 -> 5,
  // IO in 1 -> 2 -> 5
  // 5 computes XOR
  // 5 output -> 8 -> IO out 1
  vector<unsigned long> config_datas{};

  top->in_wire_0 = 1;
  top->in_wire_1 = 0;

  POSEDGE(top->clk);

  //assert(top->out_wire_1 == 1);

  top->in_wire_0 = 0;
  top->in_wire_1 = 0;

  POSEDGE(top->clk);

  //assert(top->out_wire_1 == 0);

  top->in_wire_0 = 1;
  top->in_wire_1 = 1;

  POSEDGE(top->clk);

  //assert(top->out_wire_1 == 0);

}

int main() {
  hand_written_test();
}
