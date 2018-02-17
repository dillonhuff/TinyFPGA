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

    std::map<ConfigLabel, int> configMapping;

  public:

    int nConfigBits;

    ConfigurableComponent(const std::map<ConfigLabel, int>& configMapping_) :
      configMapping(configMapping_) {}

    // Maybe change to configDataWidth? Is there a hidden class here?
    int numConfigBits() {
      return ceil(log2(configMapping.size()));
    }

    BitVector configBitPattern(const ConfigLabel& label) {

      assert(contains_key(label, configMapping));
      
      return BitVector(numConfigBits(), configMapping[label]);
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

  TEST_CASE("Building component bit vector") {

    SECTION("2 option switch") {
      map<ConfigLabel, int> confMap;
      confMap["in_0_0"] = 0;
      confMap["in_0_1"] = 1;
      ConfigurableComponent* sw = new ConfigurableComponent(confMap);

      SECTION("Pattern for in_0_0") {
        REQUIRE(sw->configBitPattern("in_0_0") == BitVector(1, 0));
      }

      SECTION("Pattern for in_0_1") {
        REQUIRE(sw->configBitPattern("in_0_1") == BitVector(1, 1));
      }

      delete sw;
    }

    SECTION("3 option switch") {
      map<ConfigLabel, int> confMap;
      confMap["in_0_0"] = 0;
      confMap["in_0_1"] = 1;
      confMap["in_2_1"] = 2;
      ConfigurableComponent* sw = new ConfigurableComponent(confMap);

      SECTION("Pattern for in_2_1") {
        REQUIRE(sw->configBitPattern("in_2_1") == BitVector(2, 2));
      }

      delete sw;
    }
    
  }

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
