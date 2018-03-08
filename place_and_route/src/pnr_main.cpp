#include <cassert>

#include "bitstream_format.h"
#include "place.h"

using namespace std;
using namespace TinyPnR;

void writeBitStream(const BitStreamFormat& format,
                    const std::map<vdisc, CLBId>& placement,
                    const std::map<vdisc, vdisc>& routes,
                    const TargetTopology& topology,
                    const std::string& bitstreamFile) {
}

int main(const int argc, const char** argv) {
  assert(argc == 5);

  string appFile = argv[1];
  string bitstreamFormatFile = argv[2];
  string topologyFile = argv[3];
  string bitstreamFile = argv[4];

  ApplicationGraph app = loadApplicationFromJSON(appFile);
  TargetTopology topology = loadTargetTopologyFromJSON(topologyFile);

  map<vdisc, CLBId> placement = placeApplication(app, topology);

  assert(placement.size() == app.getVerts().size());

  map<vdisc, vdisc> routes =
    routeApplication(app, topology, placement);

  BitStreamFormat format = loadBitStreamFormat(bitstreamFormatFile);

  writeBitStream(format, placement, routes, topology, bitstreamFile);
}
