#define CATCH_CONFIG_MAIN

#include "catch.hpp"

using namespace std;

namespace TinyPnR {

  typedef int TileId;

  class Tile {
    std::string name;
    std::vector<string> labels;

  public:

    Tile() : name(""), labels({}) {}

    Tile(const std::string& name_,
         const std::vector<string>& labels_) : name(name_), labels(labels_) {}
  };

  class TargetTopology {
    TileId nTiles;

    std::map<TileId, Tile> tileMap;
    
  public:

    TargetTopology() : nTiles(0) {}

    TileId addTile(const std::string& name,
                   const std::vector<string>& labels) {
      TileId id = nTiles;
      nTiles++;
      return id;
    }
  };

  typedef int NodeId;
  class ApplicationGraph {

  public:

    NodeId addNode(const std::string& nodeLabel) {
      return 0;
    }
    
  };

  std::map<NodeId, TileId> placeApplication(const ApplicationGraph& app,
                                            const TargetTopology& topology) {
    return {};
  }

  TEST_CASE("Placing a single node on a graph") {

    // Create target topology
    TargetTopology topology;
    auto inTile = topology.addTile("in0", {"input"});
    auto outTile = topology.addTile("out0", {"output"});

    // Create application graph
    ApplicationGraph app;
    auto inNode = app.addNode("input");
    auto outNode = app.addNode("output");

    // Place application graph
    map<NodeId, TileId> placement = placeApplication(app, topology);
    
    REQUIRE(placement.size() == 2);
  }

}
