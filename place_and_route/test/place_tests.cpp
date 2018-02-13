#define CATCH_CONFIG_MAIN

#include "algorithm.h"
#include "catch.hpp"

using namespace std;

namespace TinyPnR {

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

  class CLB {
    std::string name;
    std::set<string> labels;

  public:

    CLB() : name(""), labels({}) {}

    CLB(const std::string& name_,
         const std::vector<string>& labels_) :
      name(name_), labels(begin(labels_), end(labels_)) {}

    std::set<string> getLabels() const { return labels; }

  };

  class TargetTopology {
    CLBId nCLBs;

    std::map<CLBId, CLB> tileMap;
    
  public:

    TargetTopology() : nCLBs(0) {}

    CLBId addCLB(const std::string& name,
                   const std::vector<string>& labels) {
      CLBId id = nCLBs;
      nCLBs++;
      tileMap[id] = CLB(name, labels);
      return id;
    }

    CLB getCLB(const CLBId& tileId) const {
      assert(contains_key(tileId, tileMap));

      return tileMap.find(tileId)->second;
    }

    std::set<CLBId> tileIds() const {
      std::set<CLBId> ids;
      for (auto id : tileMap) {
        ids.insert(id.first);
      }
      return ids;
    }
  };

  typedef DirectedGraph<std::string, int> ApplicationGraph;

  std::map<vdisc, CLBId>
  placeApplication(const ApplicationGraph& app,
                   const TargetTopology& topology) {
    set<CLBId> ids = topology.tileIds();

    map<vdisc, CLBId> placement;
    for (auto vert : app.getVerts()) {
      string val = app.getNode(vert);

      bool foundCLB = false;
      for (auto tileId : ids) {
        if (elem(val, topology.getCLB(tileId).getLabels())) {
          ids.erase(tileId);
          foundCLB = true;

          placement[tileId] = tileId;
          break;
        }
      }

      assert(foundCLB);
    }
    
    return placement;
  }

  TEST_CASE("Placing and routing a two node graph") {

    // Create target topology
    TargetTopology topology;
    auto inCLB = topology.addCLB("in0", {"input"});
    auto outCLB = topology.addCLB("out0", {"output"});

    // Create application graph
    ApplicationGraph app;
    auto inNode = app.addVertex("input");
    auto outNode = app.addVertex("output");
    auto ed = app.addEdge(inNode, outNode);

    // Place application graph
    map<vdisc, CLBId> placement = placeApplication(app, topology);
    
    REQUIRE(placement.size() == 2);

    
  }

}
