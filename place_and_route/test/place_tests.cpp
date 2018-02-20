#define CATCH_CONFIG_MAIN

#include "algorithm.h"
#include "catch.hpp"

using namespace std;

namespace TinyPnR {

  // NOTE: Need to add port names to the targetTopology
  enum TopologyBoxType {
    BOX_TYPE_CLB,
    BOX_TYPE_SWITCH,
  };

  class TopologyBox {
  public:
    virtual std::string toString() const = 0;
    virtual TopologyBoxType getType() const = 0;
    virtual ~TopologyBox() {}
  };

  class Switch : public TopologyBox {
    std::string name;
    int width;
  public:

    Switch(const std::string& name_, const int width_) :
      name(name_), width(width_) {}

    virtual std::string toString() const {
      return name + " : " + to_string(width);
    }

    TopologyBoxType getType() const { return BOX_TYPE_SWITCH; }

    int getWidth() const { return width; }
    std::string getName() { return name; }
  };

  class CLB : public TopologyBox {
    std::string name;
    std::set<string> labels;
    std::set<string> ports;

  public:

    CLB() : name(""), labels({}), ports({}) {}

    CLB(const std::string& name_,
        const std::vector<string>& labels_,
        const std::set<string>& ports_) :
      name(name_), labels(begin(labels_), end(labels_)), ports(ports_) {}

    virtual std::string toString() const {
      return name;
    }
    
    std::set<string> getLabels() const { return labels; }

    TopologyBoxType getType() const { return BOX_TYPE_CLB; }
    
  };

  typedef int vdisc;
  typedef int edisc;

  template<typename Node, typename Edge>
  class DirectedGraph {

    std::vector<edisc> edges;
    std::vector<vdisc> verts;

    std::map<vdisc, std::vector<edisc> > adjacent_incoming;
    std::map<vdisc, std::vector<edisc> > adjacent_outgoing;

    std::map<edisc, std::pair<vdisc, vdisc> > edgeVals;
    std::map<edisc, Edge> edgeNames;
    std::map<vdisc, Node> vertNames;

  public:

    int numVertices() const { return verts.size(); }

    std::map<vdisc, Node> getVertNames() const { return vertNames; }

    Node getNode(const vdisc vd) const {
      auto vit = vertNames.find(vd);

      assert(vit != std::end(vertNames));

      return (*vit).second;
    }

    Edge getConn(const edisc ed) const {

      auto eit = edgeNames.find(ed);

      assert(eit != std::end(edgeNames));

      return (*eit).second;
    }

    bool hasLabel(const edisc ed) const {
      return edgeNames.find(ed) != std::end(edgeNames);
    }

    vdisc target(const edisc ed)  const {
      auto eit = edgeVals.find(ed);

      assert(eit != std::end(edgeVals));

      return (*eit).second.second;
    }

    vdisc source(const edisc ed)  const {
      auto eit = edgeVals.find(ed);

      assert(eit != std::end(edgeVals));

      return (*eit).second.first;
    }

    std::vector<edisc> getEdges() const {
      return edges;
    }

    std::vector<vdisc> getVerts() const {
      return verts;
    }
    
    edisc addEdge(const vdisc s, const vdisc e) {
      edisc ed = nextEdgeDisc();

      edges.push_back(ed);
      edgeVals.insert({ed, {s, e}});

      map_insert(adjacent_outgoing, s, ed);
      map_insert(adjacent_incoming, e, ed);

      return ed;
    }

    vdisc addVertex(const Node& w) {
      vdisc v = nextVertexDisc();
      verts.push_back(v);
      vertNames[v] = w;
      return v;
    }

    void addVertex(const vdisc v) {
      assert(!elem(v, verts));

      verts.push_back(v);
    }

    vdisc addVertex() {
      vdisc v = nextVertexDisc();
      verts.push_back(v);
      return v;
    }

    void addVertLabel(const vdisc vd, const Node& wd) {
      vertNames.erase(vd);

      vertNames.insert({vd, wd});

    }

    void addEdgeLabel(const edisc ed, const Edge& conn) {

      edgeNames[ed] = conn;

    }

    edisc nextEdgeDisc() const {
      return edges.size();
    }

    vdisc nextVertexDisc() const {
      return verts.size();
    }

    std::vector<edisc> outEdges(const vdisc vd) const {
      if (adjacent_outgoing.find(vd) == std::end(adjacent_outgoing)) {
        return {};
      }

      return map_find(vd, adjacent_outgoing);

    }

    std::vector<edisc> inEdges(const vdisc vd) const {
      if (adjacent_incoming.find(vd) == std::end(adjacent_incoming)) {
        return {};
      }

      return map_find(vd, adjacent_incoming);

    }

    bool connected(const vdisc source, const vdisc dest) const {

      for (auto& ed : outEdges(source)) {
        if (target(ed) == dest) {
          return true;
        }
      }

      return false;
    }

    std::vector<vdisc> vertsWithNoIncomingEdge() const {
      std::vector<vdisc> vs;
      for (auto v : getVerts()) {

        //if (getInputConnections(v).size() == 0) {
        if (inEdges(v).size() == 0) {
          vs.push_back(v);
        }
      }

      return vs;
    
    }
    
  };

  template<typename Node, typename Edge>
  std::vector<vdisc>
  vertsWithNoIncomingEdge(const DirectedGraph<Node, Edge>& g) {
    return g.vertsWithNoIncomingEdge();
  }
  
  typedef int CLBId;

  typedef int SwitchId;

  class TargetTopology {

    DirectedGraph<TopologyBox*, std::pair<std::string, std::string> > topology;
    std::set<TopologyBox*> boxes;

  public:

    TargetTopology() {}

    ~TargetTopology() {
      for (auto box : boxes) {
        delete box;
      }
    }

    std::vector<edisc> outEdges(const vdisc vd) const {
      return topology.outEdges(vd);
    }

    std::vector<edisc> inEdges(const vdisc vd) const {
      return topology.inEdges(vd);
    }

    vdisc target(const edisc ed)  const {
      return topology.target(ed);
    }

    vdisc source(const edisc ed)  const {
      return topology.source(ed);
    }

    edisc addEdge(const vdisc s, const vdisc e) {
      return topology.addEdge(s, e);
    }

    SwitchId addSwitch(const std::string& name,
                       const int width) {
      Switch* sw = new Switch(name, width);
      boxes.insert(sw);
      auto id = topology.addVertex(sw);

      return id;
    }

    CLBId addCLB(const std::string& name,
                 const std::vector<string>& labels,
                 const std::set<string>& ports) {

      CLB* clb = new CLB(name, labels, ports);
      boxes.insert(clb);
      auto id = topology.addVertex(clb);
      return id;
    }

    CLB* getCLB(const CLBId& tileId) const {
      TopologyBox* clb = topology.getNode(tileId);
      assert(clb->getType() == BOX_TYPE_CLB);

      return static_cast<CLB*>(clb);
    }

    TopologyBox* getBox(const CLBId& tileId) const {
      TopologyBox* box = topology.getNode(tileId);
      return box;
    }
    
    std::set<vdisc> boxIds() const {
      auto verts = topology.getVerts();
      return std::set<vdisc>(begin(verts), end(verts));
    }
  };

  typedef DirectedGraph<std::string, std::pair<std::string, std::string> > ApplicationGraph;

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

              if (lastTile == endId) {
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
  
  TEST_CASE("Placing and routing a two node graph") {

    // Create target topology
    TargetTopology topology;
    auto inCLB = topology.addCLB("in0", {"input"}, {"port_0"});
    auto outCLB = topology.addCLB("out0", {"output"}, {"iport"});
    auto sw = topology.addSwitch("vertical_channel_0", 1);

    auto ed0 = topology.addEdge(inCLB, sw);
    auto ed1 = topology.addEdge(sw, outCLB);

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
