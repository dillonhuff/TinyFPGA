#include <cassert>

#include "bitstream_format.h"
#include "place.h"

using namespace std;
using namespace TinyPnR;

int main(const int argc, const char** argv) {
  assert(argc == 5);

  string appFile = argv[1];
  string bitstreamFormatFile = argv[2];
  string topologyFile = argv[3];
  string bitstreamFile = argv[4];

  ApplicationGraph app = loadApplicationFromJSON(appFile);
  
}
