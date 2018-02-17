#include "catch.hpp"

#include "algorithm.h"
#include "dynamic_bit_vector.h"

using namespace std;

namespace TinyPnR {

  typedef dynamic_bit_vector BitVector;

  typedef std::string ConfigLabel;

  // Q: How to modify this to support labels where a string for each
  // labeling is not practical? E. G. constant values to load into registers?

  // Maybe configurable component should have two functions:
  // virtual int numConfigBits
  // virtual BitVector getConfigurationBits(ConfigurationLable*) void

  class ConfigurableComponent {
  public:

    int nConfigBits;
    std::map<ConfigLabel, int> configMapping;

    // Maybe change to configDataWidth? Is there a hidden class here?
    int numConfigBits() {
      return 0;
    }

    BitVector configBitPattern(const ConfigLabel& label) {
      return BitVector(numConfigBits(), 0);
    }

  };

  // ModuleConfig will build up the whole configuration bit vector

  // Tile config will select the appropriate config addr and the
  // appropriate module configuration

  // What needs to be in the moduleconfig?
  // The total width of configuration data for this element
  // All of the configurable components in the module and maps from
  // their configuration labels to the bit patterns that map to each
  // configuration
  class ModuleConfig {
    
  public:

    std::map<ConfigurableComponent*, int> componentOffsets;

    int configDataWidth() const {
      return 0;
    }

  };

  class TileConfig {
  public:
    std::string tileName;
    int tileNumber;

    std::vector<ModuleConfig> components;

  };

  class BitStreamFormat {
  public:

    void setAddressWidth(const int i) {
    }

    void setDataWidth(const int i) {
    }
    
    void setTileIdRange(const int end, const int start) {
    }

    void setComponentIdRange(const int end, const int start) {
    }

    void setTileNameMap(const std::map<std::string, int>& tileNamesToIds) {
    }

  };

  TEST_CASE("Computing placement addresses") {
    BitStreamFormat format;
    format.setAddressWidth(32);
    format.setDataWidth(32);
    format.setTileIdRange(31, 16);
    format.setComponentIdRange(15, 0);

    map<std::string, int> tileNamesToIds;
    tileNamesToIds.insert({"pe_tile_123", 123});

    format.setTileNameMap(tileNamesToIds);

    // Q: How to deal with hierarchy? List of tiles where
    // each tile in tileNamesToIds may have a different layout?
  }
}
