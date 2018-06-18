#include "Vtop.h"
#include "verilated.h"

#include <iostream>
#include <vector>

using namespace std;

#define POSEDGE(signal, val) (signal) = 0; (val)->eval(); (signal) = 1; (val)->eval();
#define NEGEDGE(signal, val) (signal) = 1; (val)->eval(); (signal) = 0; (val)->eval();
#define RESET(signal, val) POSEDGE((signal), (val)); NEGEDGE((signal), (val)); POSEDGE((signal), (val));

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

enum CLB_op {
  CLB_OP_AND,
  CLB_OP_OR,
  CLB_OP_XOR,
  CLB_OP_NOT
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

  uint32_t clb_op(const CLB_op op) {
    switch (op) {
    case CLB_OP_AND:
      return 0;
    case CLB_OP_OR:
      return 1;
    case CLB_OP_XOR:
      return 2;
    case CLB_OP_NOT:
      return 3;
    default:
      assert(false);
    }
    
  }

  uint32_t route_sb_to_cb(const uint32_t track, bool is_input) {
    assert(track < 4);
    uint32_t val = track;

    if (!is_input) {
      val = val + 4;
    }

    return val;
  }
  
  uint32_t route_sb(const uint32_t src_side,
                    const uint32_t dest_side,
                    const uint32_t track) {
    // TODO: Handle CLB output!
    assert(src_side < 5);
    assert(dest_side < 4);

    assert(src_side != dest_side);

    uint32_t val = 0;
    uint32_t offset = dest_side*8;
    // If the source is the CLB then use dest side
    uint32_t res = (src_side == 4) ? dest_side : src_side;

    val |= (res << offset);

    return val;
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

config_address_structure default_addr_gen() {
  return config_address_structure(32, 16, 31, 0, 15);
}
// First test: passthrough routing In0 -> 1 -> 4 -> 7 -> Ot0 on track 0
// In0 In1 In2
// 1   2   3
// 4   5   6
// 7   8   9
// Ot0 Ot1 Ot2
void handwritten_routing_test() {
  Vtop* top = new Vtop();

  RESET(top->reset, top);

  config_address_structure addr_gen = default_addr_gen();
  // (32, 16, 31, 0, 15);
  auto addr0 = addr_gen.config_address(1, PE_COMPONENT_SB);
  uint32_t data0 = addr_gen.route_sb(3, 1, 0);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  addr0 = addr_gen.config_address(4, PE_COMPONENT_SB);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  addr0 = addr_gen.config_address(7, PE_COMPONENT_SB);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);
  
  top->in_wire_0 = 1;
  POSEDGE(top->clk, top);

  assert(top->out_wire_0 == top->in_wire_0);
}

void route_neg_test() {
  Vtop* top = new Vtop();

  RESET(top->reset, top);

  config_address_structure addr_gen = default_addr_gen();
  auto addr0 = addr_gen.config_address(1, PE_COMPONENT_SB);
  uint32_t data0 = addr_gen.route_sb(3, 1, 0);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  addr0 = addr_gen.config_address(4, PE_COMPONENT_SB);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  addr0 = addr_gen.config_address(7, PE_COMPONENT_SB);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);
  
  top->in_wire_0 = 1;
  POSEDGE(top->clk, top);

  assert(top->out_wire_0 == top->in_wire_0);
}

void generated_and_test() {
  auto addr_gen = default_addr_gen();

  Vtop* top = new Vtop();
  RESET(top->reset, top);

  top->config_addr = addr_gen.config_address(2, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(3, 1, 0);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(5, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(3, 1, 0);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(5, PE_COMPONENT_CB1);
  top->config_data = addr_gen.route_sb_to_cb(0, false);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(3, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(3, 1, 0);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(6, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(3, 2, 0);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(5, PE_COMPONENT_CB0);
  top->config_data = addr_gen.route_sb_to_cb(0, true);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(5, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(4, 1, 1);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(8, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(3, 1, 1);
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(5, PE_COMPONENT_CLB);
  top->config_data = addr_gen.clb_op(CLB_OP_AND);
  POSEDGE(top->clk, top);
  
  top->in_wire_0 = 1;
  top->in_wire_1 = 1;
  top->in_wire_2 = 1;
  POSEDGE(top->clk, top);
  POSEDGE(top->clk, top);

  assert(top->out_wire_1 == (top->in_wire_1 && top->in_wire_2));
}

int main() {
  handwritten_routing_test();
  route_neg_test();
  generated_and_test();
  cout << "$$$ top tests passed" << endl;
}
