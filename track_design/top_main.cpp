#include "Vtop.h"
#include "verilated.h"

#include <iostream>
#include <vector>

using namespace std;

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

  config_address_structure(const int width_,
                           const int mod_id_begin_,
                           const int mod_id_end_,
                           const int tile_id_begin_,
                           const int tile_id_end_) :
    width(width_),
    mod_id_begin(mod_id_begin_),
    mod_id_end(mod_id_end_),
    tile_id_begin(tile_id_begin_),
    tile_id_end(tile_id_end_) {

    // Only support width 32 addresses for now
    assert(width == 32);
    assert((mod_id_end - mod_id_begin) == (tile_id_end - tile_id_begin));
  }

  uint32_t component_address(const PE_component component) {
    if (component == PE_COMPONENT_CB0) {
      return 4;
    }

    if (component == PE_COMPONENT_CB1) {
      return 5;
    }

    if (component == PE_COMPONENT_SB) {
      return 6;
    }

    if (component == PE_COMPONENT_CLB) {
      return 7;
    }
    
    assert(false);
  }

  uint32_t config_address(const uint32_t tile_id,
                          const PE_component component) {
    uint32_t addr = 0;
    addr |= (tile_id << tile_id_begin);
    addr |= (component_address(component) << mod_id_begin);
    return addr;
  }
};

// First test: passthrough routing In0 -> 1 -> 4 -> 7 -> Ot0 on track 0
// In0 In1 In2
// 1   2   3
// 4   5   6
// 7   8   9
// Ot0 Ot1 Ot2


int main() {
  Vtop* top = new Vtop();

  RESET(top->reset);

  config_address_structure addr_gen(32, 16, 31, 0, 15);
  auto addr0 = addr_gen.config_address(1, PE_COMPONENT_SB);
  uint32_t data0 = 3 << 8;

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk);

  auto addr1 = addr_gen.config_address(4, PE_COMPONENT_SB);

  top->config_addr = addr1;
  top->config_data = data0;
  
  POSEDGE(top->clk);

  auto addr2 = addr_gen.config_address(7, PE_COMPONENT_SB);

  top->config_addr = addr2;
  top->config_data = data0;
  
  POSEDGE(top->clk);
  
  top->config_addr = 0;
  top->config_data = 0;

  POSEDGE(top->clk);

  top->in_wire_0 = 1;
  POSEDGE(top->clk);

  assert(top->out_wire_0 == top->in_wire_0);
  
  // auto addr2 = addr_gen.config_address(7, PE_COMPONENT_SB);
  
  // // IO in 0 -> 1 -> 4 -> 5,
  // // IO in 1 -> 2 -> 5
  // // 5 computes XOR
  // // 5 output -> 8 -> IO out 1
  // vector<unsigned long> config_datas{};

  // top->in_wire_0 = 1;
  // top->in_wire_1 = 0;

  // POSEDGE(top->clk);

  // assert(top->out_wire_1 == 1);

  // top->in_wire_0 = 0;
  // top->in_wire_1 = 0;

  // POSEDGE(top->clk);

  // assert(top->out_wire_1 == 0);

  // top->in_wire_0 = 1;
  // top->in_wire_1 = 1;

  // POSEDGE(top->clk);

  // assert(top->out_wire_1 == 0);

  cout << "$$$ Top tests passed" << endl;
}
