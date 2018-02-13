#define CATCH_CONFIG_MAIN

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

  typedef DirectedGraph<std::string, int> ApplicationGraph;
  // typedef int NodeId;
  // class ApplicationGraph {

  //   int nNodes;

  // public:

  //   ApplicationGraph() : nNodes(0) {}

  //   NodeId addNode(const std::string& nodeLabel) {
  //     NodeId id = nNodes;
  //     nNodes++;
  //     return id;
  //   }
    
  // };

  std::map<vdisc, TileId>
  placeApplication(const ApplicationGraph& app,
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
    auto inNode = app.addVertex("input");
    auto outNode = app.addVertex("output");

    // Place application graph
    map<vdisc, TileId> placement = placeApplication(app, topology);
    
    REQUIRE(placement.size() == 2);
  }

}
