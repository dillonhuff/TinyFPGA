#include "place.h"

#include "json_utils.h"

#include <fstream>
#include <streambuf>

using namespace picojson;
using namespace std;

namespace TinyPnR {

  std::map<vdisc, CLBId>
  placeApplication(const ApplicationGraph& app,
                   const TargetTopology& topology) {
    set<CLBId> ids = topology.boxIds();

    map<vdisc, CLBId> placement;
    for (auto vert : app.getVerts()) {
      string val = app.getNode(vert);

      bool foundCLB = false;
      for (auto tileId : ids) {
        TopologyBox* box = topology.getBox(tileId);

        if (box->getType() == BOX_TYPE_CLB) {
          CLB* clb = static_cast<CLB*>(box);
          if (elem(val, clb->getLabels())) {
            ids.erase(tileId);
            foundCLB = true;

            placement[tileId] = tileId;
            break;
          }
        }
      }

      assert(foundCLB);
    }
    
    return placement;
  }

  std::map<vdisc, vdisc>
  routesToSwitchConfig(const TargetTopology& topology,
                       const std::vector<std::vector<vdisc> >& routes) {
    map<vdisc, vdisc> routeConfig;
    // TODO: Write test to break this
    for (auto route : routes) {

      assert(route.size() >= 3);

      for (int i = 0; i < route.size() - 2; i++) {
        vdisc from = route[i];
        vdisc to = route[i + 1];

        TopologyBox* box = topology.getBox(to);
        assert(box->getType() == BOX_TYPE_SWITCH);

        routeConfig.insert({to, from});
      }
    }

    return routeConfig;
  }
  
  std::map<vdisc, vdisc>
  routeApplication(const ApplicationGraph& app,
                   const TargetTopology& topology,
                   std::map<vdisc, CLBId>& placement) {

    vector<vector<vdisc> > routes;
    for (edisc ed : app.getEdges()) {
      cout << "ed = " << ed << endl;
      vdisc start = app.source(ed);
      vdisc end = app.target(ed);
      pair<string, string> ports = app.getConn(ed);
      string startPort = ports.first;
      string endPort = ports.second;

      CLBId startId = placement[start];
      CLBId endId = placement[end];

      cout << "StartId = " << startId << endl;
      cout << "EndId   = " << endId << endl;

      vector<vdisc> route{startId};

      // Search for connections
      set<vdisc> switchesLeft;
      for (auto id : topology.boxIds()) {
        auto tile = topology.getBox(id);
        if (tile->getType() == BOX_TYPE_SWITCH) {
          switchesLeft.insert(id);
        }
      }

      vdisc currentLoc = startId;
      bool foundRoute = false;
      while (!foundRoute && (switchesLeft.size() > 0)) {

        for (auto ed : topology.outEdges(currentLoc)) {

          cout << "Out edge " << ed << endl;
          auto id = topology.target(ed);
          auto tile = topology.getBox(id);

          if ((tile->getType() == BOX_TYPE_SWITCH) &&
              (elem(id, switchesLeft))) {

            cout << "Found switch" << endl;

            currentLoc = id;
            route.push_back(id);

            switchesLeft.erase(id);

            for (auto se : topology.outEdges(id)) {
              auto lastTile = topology.target(se);
              string lastPort = topology.getConn(se).second;

              if ((lastTile == endId) && (lastPort == endPort)) {
                foundRoute = true;
              }

              route.push_back(lastTile);
            }

            break;
          }
        }
      }

      assert(foundRoute);
      assert(route.back() == endId);
      assert(route.size() >= 3);

      routes.push_back(route);
    }

    cout << "# of routes = " << routes.size() << endl;

    map<vdisc, vdisc> routeConfig =
      routesToSwitchConfig(topology, routes);

    return routeConfig;
  }

  ApplicationGraph loadApplicationFromJSON(const std::string& applicationFile) {
    std::ifstream t(applicationFile);

    cout << "Application file = " << applicationFile << endl;
    std::istream_iterator<char> input(t);
    picojson::value v;
    std::string err;
    input = picojson::parse(v, input, std::istream_iterator<char>(), &err);
    if (!err.empty()) {
      std::cerr << err << std::endl;
      assert(false);
    }

    ApplicationGraph g;
    map<vdisc, int> graphIndsToInternalInds;
    auto node_labels = getValue("node_labels", v);
    
    assert(false);
    
    return g;
  }

  TargetTopology loadTargetTopologyFromJSON(const std::string& topoFile) {
    TargetTopology tp;
    return tp;
  }
  
}
