#define CATCH_CONFIG_MAIN

#include "place.h"
#include "catch.hpp"

using namespace std;

namespace TinyPnR {

  TEST_CASE("Placing and routing a two node graph") {

    // Create target topology
    TargetTopology topology;
    auto inCLB = topology.addCLB("in0", {"input"}, {"port_0"});
    auto outCLB = topology.addCLB("out0", {"output"}, {"iport"});
    auto sw = topology.addSwitch("vertical_channel_0", 1, {"in_0", "vertical_channel_0"});

    auto ed0 = topology.addEdge(inCLB, sw);
    topology.addEdgeLabel(ed0, {"port_0", "in_0"});
    
    auto ed1 = topology.addEdge(sw, outCLB);
    topology.addEdgeLabel(ed1, {"vertical_channel_0", "iport"});

    // Whats the way to express the connections? They need to be directed

    // Create application graph. Note that nodes in the application graph
    // need to have ports with connections
    ApplicationGraph app;
    auto inNode = app.addVertex("input");
    auto outNode = app.addVertex("output");
    auto ed = app.addEdge(inNode, outNode);
    app.addEdgeLabel(ed, {"port_0", "iport"});

    // Place application graph
    map<vdisc, CLBId> placement = placeApplication(app, topology);
    
    REQUIRE(placement.size() == 2);

    // How to describe the routing?
    // Routing is a map from switches to the input that they receive?
    map<vdisc, vdisc> routes =
      routeApplication(app, topology, placement);

    REQUIRE(routes.size() == 1);

    REQUIRE(contains_key(sw, routes));
  }

}
