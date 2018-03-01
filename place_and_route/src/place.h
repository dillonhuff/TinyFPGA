#pragma once

#include "algorithm.h"
#include "directed_graph.h"

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
    std::set<std::string> ports;

  public:

    Switch(const std::string& name_,
           const int width_,
           const std::set<std::string>& ports_) :
      name(name_), width(width_), ports(ports_) {}

    virtual std::string toString() const {
      return name + " : " + std::to_string(width);
    }

    TopologyBoxType getType() const { return BOX_TYPE_SWITCH; }

    int getWidth() const { return width; }
    std::string getName() { return name; }
  };

  class CLB : public TopologyBox {
    std::string name;
    std::set<std::string> labels;
    std::set<std::string> ports;

  public:

    CLB() : name(""), labels({}), ports({}) {}

    CLB(const std::string& name_,
        const std::vector<std::string>& labels_,
        const std::set<std::string>& ports_) :
      name(name_), labels(begin(labels_), end(labels_)), ports(ports_) {}

    virtual std::string toString() const {
      return name;
    }
    
    std::set<std::string> getLabels() const { return labels; }

    TopologyBoxType getType() const { return BOX_TYPE_CLB; }
    
  };

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

    void addEdgeLabel(const edisc ed,
                      const std::pair<std::string, std::string>& conn) {
      topology.addEdgeLabel(ed, conn);
    }

    std::pair<std::string, std::string> getConn(const edisc ed) const {
      return topology.getConn(ed);
    }

    vdisc source(const edisc ed)  const {
      return topology.source(ed);
    }

    edisc addEdge(const vdisc s, const vdisc e) {
      return topology.addEdge(s, e);
    }

    SwitchId addSwitch(const std::string& name,
                       const int width,
                       const std::set<std::string>& ports) {
      Switch* sw = new Switch(name, width, ports);
      boxes.insert(sw);
      auto id = topology.addVertex(sw);

      return id;
    }

    CLBId addCLB(const std::string& name,
                 const std::vector<std::string>& labels,
                 const std::set<std::string>& ports) {

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
                   const TargetTopology& topology);

  std::map<vdisc, vdisc>
  routeApplication(const ApplicationGraph& app,
                   const TargetTopology& topology,
                   std::map<vdisc, CLBId>& placement);

  ApplicationGraph loadApplicationFromJSON(const std::string& applicationFile);
  TargetTopology loadTargetTopologyFromJSON(const std::string& topoFile);
  
}
