#include "Vtop.h"
#include "verilated.h"

#include <iostream>
#include <map>
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
  PE_COMPONENT_CLB,
  PE_COMPONENT_IO,
};

enum CLB_op {
  CLB_OP_AND,
  CLB_OP_OR,
  CLB_OP_XOR,
  CLB_OP_NOT,
  CLB_OP_IN,
  CLB_OP_OUT,
};

enum CB_dir {
  CB_INPUT,
  CB_OUTPUT
};

enum PnR_cmd_type {
  PNR_CMD_CB,
  PNR_CMD_SB,
  PNR_CMD_CLB,
  PNR_CMD_IO,
  PNR_CMD_DUMMY
};

struct SB_cmd {
  uint32_t in_side;
  uint32_t out_side;
  uint32_t track;
};

struct PnR_cmd {
  uint32_t tile_id;
  PE_component comp;

  PnR_cmd_type tp;

  // SB command
  vector<SB_cmd> sb_cmds;

  // CB command
  uint32_t cb_num;
  bool take_from_input;
  uint32_t track_num;

  // CLB command
  CLB_op op;

  // IO command
  uint32_t input_track;
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

  uint32_t config_data_for(const PnR_cmd cmd) {
    if (cmd.tp == PNR_CMD_CLB) {
      return clb_op(cmd.op);
    }

    if (cmd.tp == PNR_CMD_IO) {
      return cmd.input_track;
    }

    if (cmd.tp == PNR_CMD_SB) {
      uint32_t val = 0;

      for (auto sb_cmd : cmd.sb_cmds) {
        val |= route_sb(sb_cmd.in_side, sb_cmd.out_side, sb_cmd.track);
      }
      return val;
    }

    if (cmd.tp == PNR_CMD_CB) {
      return route_sb_to_cb(cmd.track_num, cmd.take_from_input);
    }
    
    assert(false);
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
    uint32_t offset = dest_side*8 + track*2;
    // If the source is the CLB then use dest side
    uint32_t res = (src_side == 4) ? dest_side : src_side;

    val |= (res << offset);

    return val;
  }

  uint32_t component_address(const PE_component component) {
    if (component == PE_COMPONENT_IO) {
      return 0;
    }

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
// 4     5     6
// 7     8     9
// 10    11    12
// Ot1  Ot2  Ot3
void handwritten_routing_test() {
  Vtop* top = new Vtop();

  RESET(top->reset, top);

  config_address_structure addr_gen = default_addr_gen();
  // (32, 16, 31, 0, 15);
  auto addr0 = addr_gen.config_address(4 + 3, PE_COMPONENT_SB);
  uint32_t data0 = addr_gen.route_sb(3, 1, 0);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  addr0 = addr_gen.config_address(7 + 3, PE_COMPONENT_SB);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  addr0 = addr_gen.config_address(10 + 3, PE_COMPONENT_SB);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);
  
  top->in_wire_0 = 1;
  POSEDGE(top->clk, top);

  assert(top->out_wire_0 == top->in_wire_0);

  delete top;
}

void route_neg_test() {
  Vtop* top = new Vtop();

  RESET(top->reset, top);

  // Route from IO to tile 10 at bottom of design
  config_address_structure addr_gen = default_addr_gen();
  auto addr0 = addr_gen.config_address(4 + 3, PE_COMPONENT_SB);
  uint32_t data0 = addr_gen.route_sb(3, 1, 0);

  top->config_addr = addr0;
  top->config_data = data0;
  
  POSEDGE(top->clk, top);

  top->config_addr = addr_gen.config_address(7 + 3, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(3, 1, 0);
  
  POSEDGE(top->clk, top);

  // This is the tile where the operation is done

  // -- Route PE tile output to side 1 track 1
  // -- Route PE tile input side 3, track 0 to output side 0 track 0
  top->config_addr = addr_gen.config_address(10 + 3, PE_COMPONENT_SB);
  top->config_data = addr_gen.route_sb(4, 1, 1) | addr_gen.route_sb(3, 0, 0);
  
  POSEDGE(top->clk, top);

  // Route output side 0, track 0 to CLB operand 0
  top->config_addr = addr_gen.config_address(10 + 3, PE_COMPONENT_CB0);
  top->config_data = addr_gen.route_sb_to_cb(0, false);
  POSEDGE(top->clk, top);

  // Set CLB op to negate operand0
  top->config_addr = addr_gen.config_address(10 + 3, PE_COMPONENT_CLB);
  top->config_data = addr_gen.clb_op(CLB_OP_NOT);
  
  POSEDGE(top->clk, top);

  // CLB does not matter, this is an io tile. TODO: Create IO tile component
  top->config_addr = addr_gen.config_address(1 + 3, PE_COMPONENT_IO);
  top->config_data = 1;
  
  POSEDGE(top->clk, top);

  top->config_addr = 0;
  top->config_data = 0;
  
  top->in_wire_0 = 1;
  POSEDGE(top->clk, top);

  POSEDGE(top->clk, top);

  cout << "top->out_wire_0 = " << (int) top->out_wire_0 << endl;
  assert(top->out_wire_0 == (~(top->in_wire_0) & 0x01));

  top->in_wire_0 = 0;
  POSEDGE(top->clk, top);

  cout << "Final neg cycle" << endl;
  POSEDGE(top->clk, top);

  cout << "top->out_wire_0 = " << (int) top->out_wire_0 << endl;
  assert(top->out_wire_0 == (~(top->in_wire_0) & 0x01));

  delete top;
}

void load_pnr_commands(const vector<PnR_cmd>& commands,
                       Vtop* top) {

  RESET(top->reset, top);

  auto addr_gen = default_addr_gen();
  for (auto cmd : commands) {
    top->config_addr = addr_gen.config_address(cmd.tile_id, cmd.comp);
    top->config_data = addr_gen.config_data_for(cmd);
    POSEDGE(top->clk, top);
  }
  
  top->config_addr = 0;
  top->config_data = 0;
  POSEDGE(top->clk, top);
}

PnR_cmd make_io_cmd(const uint32_t tile_no,
                    const uint32_t input_track) {
  PnR_cmd cmd;
  cmd.comp = PE_COMPONENT_IO;
  cmd.tp = PNR_CMD_IO;
  cmd.tile_id = tile_no;
  cmd.input_track = input_track;

  return cmd;
}

PnR_cmd make_cb_cmd(const uint32_t tile_no,
                    const uint32_t cb_num,
                    const uint32_t track_num,
                    const CB_dir dir) {
  assert((cb_num == 0) || (cb_num == 1));

  PnR_cmd cmd;
  cmd.comp = cb_num == 0 ? PE_COMPONENT_CB0 : PE_COMPONENT_CB1;
  cmd.tp = PNR_CMD_CB;
  cmd.tile_id = tile_no;
  cmd.take_from_input = dir == CB_INPUT;
  cmd.track_num = track_num;

  return cmd;
}

PnR_cmd make_clb_cmd(const uint32_t tile_no,
                    const CLB_op op) {
  PnR_cmd cmd;
  cmd.comp = PE_COMPONENT_CLB;
  cmd.tp = PNR_CMD_CLB;
  cmd.tile_id = tile_no;
  cmd.op = op;

  return cmd;
}

PnR_cmd make_sb_cmd(const uint32_t tile_no,
                    const vector<SB_cmd>& sb_cmds) {
  PnR_cmd cmd;
  cmd.comp = PE_COMPONENT_SB;
  cmd.tp = PNR_CMD_SB;
  cmd.tile_id = tile_no;
  cmd.sb_cmds = sb_cmds;

  return cmd;
}

void generated_and_test() {
  cout << "Starting and test" << endl;

  Vtop* top = new Vtop();

  vector<PnR_cmd> and_cmds;
  and_cmds.push_back(make_sb_cmd(5 + 3, {{3, 1, 0}}));

  and_cmds.push_back(make_sb_cmd(6 + 3, {{3, 1, 0}}));
  and_cmds.push_back(make_sb_cmd(9 + 3, {{3, 2, 0}}));

  and_cmds.push_back(make_sb_cmd(8 + 3, {{3, 1, 0}, {4, 1, 1}}));

  // side 0 track 0 out -> operand0
  // side 1 track 1 out -> operand1
  and_cmds.push_back(make_cb_cmd(8 + 3, 0, 0, CB_INPUT));
  and_cmds.push_back(make_cb_cmd(8 + 3, 1, 0, CB_OUTPUT));
  and_cmds.push_back(make_clb_cmd(8 + 3, CLB_OP_AND));

  // Route result down on track 1
  and_cmds.push_back(make_sb_cmd(11 + 3, {{3, 1, 1}}));
  and_cmds.push_back(make_io_cmd(2 + 3, 1));

  load_pnr_commands(and_cmds, top);

  top->in_wire_1 = 1;
  top->in_wire_2 = 1;

  POSEDGE(top->clk, top);

  assert(top->out_wire_1 == (top->in_wire_1 && top->in_wire_2));

  top->in_wire_1 = 0;
  top->in_wire_2 = 1;

  POSEDGE(top->clk, top);

  assert(top->out_wire_1 == (top->in_wire_1 && top->in_wire_2));
  
  delete top;
}

enum place_source_type {
  PLACE_SOURCE_IO,
  PLACE_SOURCE_CLB
};

struct place_source {
  int tile_id;
  place_source_type type;
};

enum place_dest_type {
  PLACE_DEST_IO,
  PLACE_DEST_CLB_OPERAND_0,
  PLACE_DEST_CLB_OPERAND_1,
};

struct place_dest {
  int tile_id;
  place_dest_type type;
};

struct tile_info {
  int tile_no;
  bool is_placed;
};

std::pair<int, int> tile_position(const int tile_position, int grid_len) {
  // Tile is an input IO
  if (tile_position <= grid_len) {
    return {0, tile_position - 1};
  }

  // Tile is an output IO
  if (tile_position <= 2*grid_len) {
    return {grid_len - 1, (tile_position / 2) - 1};
  }

  // PE tile
  int adjusted_position = tile_position - grid_len - 1;
  int row_num = (adjusted_position) / grid_len;
  int col_num = (adjusted_position) % grid_len;
  return {row_num, col_num};
}

int complement(int side) {
  assert(side < 4);

  return (side + 2) % 4;
}

// Assumes the grid is 3 x 3
std::vector<PnR_cmd>
route_path(pair<place_source, place_dest>& path,
           map<int, tile_info>& tiles) {
  place_source src = path.first;
  place_dest dest = path.second;

  assert(src.tile_id != dest.tile_id);

  // If the source is an IO we can start any track on side 3
  // If the source is a CLB I suppose we can start on any track
  // from side i, track i
  vector<int> viable_tracks;
  if (src.type == PLACE_SOURCE_IO) {
    viable_tracks = {0, 1, 2, 3};
  } else {
    cout << "Unsupported source type " << src.type << endl;
    assert(false);
  }

  int src_side = src.type == PLACE_SOURCE_IO ? 1 : 4;
  assert((src.type == PLACE_SOURCE_IO) ||
         (src.type == PLACE_SOURCE_CLB));

  int dst_side;
  if (dest.type == PLACE_DEST_CLB_OPERAND_0) {
    dst_side = 0;
  } else if (dest.type == PLACE_DEST_CLB_OPERAND_1) {
    dst_side = 1;
  } else {
    assert(dest.type == PLACE_DEST_IO);
    dst_side = 3;
  }

  // Stages:
  // 1. Convert to main tile grid routing
  // 2. For each track try to go from start (tile, side) to end (tile, side)
  // 3. If one succeeds try to route from destination global to PE tile

  // Im getting snagged on all the little details of place and route. Special
  // cases for each input / output.

  // Really the routing is:
  // source -> global position (input tile track)
  // dest -> global position
  // global -> global

  // Find a diagonal route
  cout << "Routing from tile " << src.tile_id << " to " << dest.tile_id << endl;
  // Note: Need a more intuitive labeling of tiles by x, y position
  pair<int, int> src_pos = tile_position(src.tile_id, 3);
  pair<int, int> dst_pos = tile_position(dest.tile_id, 3);

  int row_dist = dst_pos.first - src_pos.first;
  int last_output_side = src_side;
  pair<int, int> current_pos = {src_pos.first, src_pos.second};

  int input_side = 3;
  int output_side = 1;

  cout << "--- Vertical routing" << endl;

  // Maybe the thing to do is generate the tile sequence, then
  // generate the sides that you want, then pick a track

  int last_in_side = 3;
  int last_out_side = 1;
  vector<pair<int, int> > tiles_in_route;
  while ((current_pos.first - dst_pos.first) != -1) {
    // Route down
    assert(last_output_side == 1);

    current_pos.first = current_pos.first + 1;

    cout << "Route from t(" << current_pos.first << ", " << current_pos.second << ")s" << last_in_side << " -> s" << last_out_side << endl;
    tiles_in_route.push_back({current_pos.first, current_pos.second});

  }

  cout << "--- Horizontal routing" << endl;

  // Routing process:
  // 1. Find tile route diagonally (find the tile sequence that gets from source to destination)
  // 2. Within the destination pick the side you want to end on. Maybe that
  //    should be this route?
  // 3. Check if we can get to that side?

  last_in_side = 3;  
  last_out_side = 0;

  while ((current_pos.second - dst_pos.second) != 0) {
    // Route down
    current_pos.second = current_pos.second + 1;
    cout << "Route from t(" << current_pos.first << ", " << current_pos.second << ")s" << last_in_side << " -> s" << last_out_side << endl;
    tiles_in_route.push_back({current_pos.first, current_pos.second});
    //input_side = complement(output_side);
  }

  cout << "Tiles in the route" << endl;
  for (auto t : tiles_in_route) {
    cout << "\t(" << t.first << ", " << t.second << ")" << endl;
  }
  
  assert(false);
  int col_dist = dst_pos.second - src_pos.second;

  cout << "row_dist = " << row_dist << endl;
  cout << "col_dist = " << col_dist << endl;

  // If row distance is positive then route side 3 -> side 1
  // If col distance is positve then route from side 2 -> side 0
  assert(row_dist > 0);
  assert(col_dist > 0);

  // IDEA: Recursive routing: move horizontally, then vertically
  // Handle base cases (IO tile to main grid), (CLB to main grid),
  // (Final side to connect box) as one offs?

  pair<int, int> vert_sides{0, 0};
  if (row_dist > 0) {
    vert_sides = {3, 1};
  } else {
    assert(false);
  }
  
  vector<PnR_cmd> cmds;

  for (auto track : viable_tracks) {
    //assert(false);
  }

  cout << "Could not route from tile " << src.tile_id << ", side " << src_side
       << " to tile " << dest.tile_id << ", side " << dst_side << endl;
  assert(false);

  return cmds;
}

std::vector<PnR_cmd>
route_application(const std::vector<pair<place_source, place_dest>>& paths) {
  vector<PnR_cmd> route_commands;
  map<int, tile_info> tiles{};

  for (auto path : paths) {
    for (auto cmd : route_path(path, tiles)) {
      route_commands.push_back(cmd);
    }
  }
  return route_commands;
}

std::vector<PnR_cmd>
placement_commands(const std::map<CLB_op, int>& placement) {
  vector<PnR_cmd> cmds;
  for (auto pl : placement) {
    if (pl.first == CLB_OP_AND) {
      cmds.push_back(make_clb_cmd(pl.second, pl.first));
    } else if (pl.first == CLB_OP_IN) {
    } else if (pl.first == CLB_OP_OUT) {
    }
  }
  return cmds;
}

void placed_and_test() {
  // TODO: Create placement, then route the placed application
  // Q: What is a placement?
  // A: I guess it is a map from operations (ins, outs, ops) to tile numbers

  // NOTE: To program output pads we will need to build
  map<CLB_op, int> placement{{CLB_OP_IN, 1}, {CLB_OP_IN, 2}, {CLB_OP_OUT, 6}, {CLB_OP_AND, 11}};

  
  // Routing takes in:
  // 1. List of pairs of sources and destinations.
  //    Sources are: IO in pads, pe outputs,
  //    Destinations are: IO out pads, PE inputs
  // Each source and destination is associated with a tile number (inputs will need
  // tiles as well)

  vector<pair<place_source, place_dest> > paths;
  paths.push_back({{1, PLACE_SOURCE_IO}, {11, PLACE_DEST_CLB_OPERAND_0}});
  paths.push_back({{2, PLACE_SOURCE_IO}, {11, PLACE_DEST_CLB_OPERAND_1}});
  paths.push_back({{11, PLACE_SOURCE_CLB}, {6, PLACE_DEST_IO}});

  // TODO: Create primitive router that can run this application
  vector<PnR_cmd> routes =
    route_application(paths);

  for (auto cmd : placement_commands(placement)) {
    routes.push_back(cmd);
  }

  Vtop* top = new Vtop();
  load_pnr_commands(routes, top);

  top->in_wire_1 = 1;
  top->in_wire_2 = 1;

  POSEDGE(top->clk, top);

  assert(top->out_wire_2 == (top->in_wire_1 && top->in_wire_2));
  
  delete top;
}

void tile_positions_test() {
  auto p = tile_position(7, 3);
  // Row 1 column 0
  assert(p.first == 1);
  assert(p.second == 0);
}

vector<pair<int, int> > find_path(const std::pair<int, int>& start_tile,
                                  const std::pair<int, int>& end) {
  auto start = start_tile;
  vector<pair<int, int> > path{start};
  
  // Horizontal portion of the move
  assert(start.second <= end.second);

  int current_col_pos = start.second;
  while (current_col_pos < end.second) {
    current_col_pos++;
    path.push_back({start.first, current_col_pos});
  }

  assert(current_col_pos == end.second);

  start = {start.first, current_col_pos};
  
  // Vertical portion of the move
  assert(start.first <= end.first);
  int current_pos = start.first;

  while (current_pos < end.first) {
    current_pos++;
    path.push_back({current_pos, start.second});
  }

  assert(current_pos == end.first);

  return path;
}

// 1   2   3
// 7   8   9
// 10  11  12
// 4   5   6
void column_path_test() {
  // Q: Do I want paths to be inclusive or exclusive?
  vector<pair<int, int> > path = find_path({0, 0}, {1, 0});

  cout << "Path" << endl;
  for (auto p : path) {
    cout << "\t" << "(" << p.first << ", " << p.second << ")" << endl;
  }
  
  assert(path.size() == 2);

  path = find_path({0, 0}, {2, 0});

  cout << "Path" << endl;
  for (auto p : path) {
    cout << "\t" << "(" << p.first << ", " << p.second << ")" << endl;
  }

  assert(path.size() == 3);

  path = find_path({1, 0}, {1, 5});

  cout << "Path" << endl;
  for (auto p : path) {
    cout << "\t" << "(" << p.first << ", " << p.second << ")" << endl;
  }

  assert(path.size() == 6);

  path = find_path({1, 0}, {3, 5});

  cout << "Path" << endl;
  for (auto p : path) {
    cout << "\t" << "(" << p.first << ", " << p.second << ")" << endl;
  }

  assert(path.size() == 8);
  assert(path.back().second == 5);
}

vector<int> annotate_sides(const std::vector<pair<int, int> >& path,
                           const int in_side) {
  vector<int> sides{in_side};
  for (int i = 0; i < (int) path.size() - 1; i++) {
    int row_diff = path[i].first - path[i + 1].first;
    int col_diff = path[i].second - path[i + 1].second;

    assert(abs(row_diff) <= 1);
    assert(abs(col_diff) <= 1);

    if (abs(row_diff) > 0) {
      assert(col_diff == 0);
    }

    if (abs(col_diff) > 0) {
      assert(row_diff == 0);
    }

    if (col_diff == -1) {
      sides.push_back(2);
    } else {
      assert(false);
    }
  }
  return sides;
}

void side_annotations_test() {
  auto path = find_path({1, 0}, {1, 1});

  auto sides = annotate_sides(path, 3);

  assert(sides.size() == path.size());

  assert(sides.back() == 2);
}

int main() {
  tile_positions_test();
  column_path_test();
  side_annotations_test();
  generated_and_test();
  handwritten_routing_test();
  route_neg_test();
  placed_and_test();
  
  cout << "$$$ top tests passed" << endl;
}
