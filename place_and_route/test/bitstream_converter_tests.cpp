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

  // Query function is:
  // Tile name, module name (convert to address)
  // Map from component names, all of which are in the module, to the
  // labels that they are going to use
  class ModuleConfig {

    std::string name;
    int configDataWidth;
    
  public:

    ModuleConfig(const std::string& name_) : name(name_) {
      configDataWidth = 0;
    }

    std::map<ConfigurableComponent*, int> componentOffsets;

    int getConfigDataWidth() const {
      return configDataWidth;
    }
    BitVector getConfigData() const {
      return BitVector(getConfigDataWidth(), 0);
    }

    void addComponent(const std::string& componentName,
                      std::map<ConfigLabel, int>& configMap) {
      
    }

    void setComponentConfig(const std::string& componentName,
                            const ConfigLabel& componentConfig) {
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

  TEST_CASE("Building programmable module config data") {

    ModuleConfig twoSwitches("twoSwitches");

    map<ConfigLabel, int> out0Conf{{"in_0_0", 0},
      {"in_0_1", 1}};
    twoSwitches.addComponent("out_0", out0Conf);

    map<ConfigLabel, int> out1Conf{{"in_1_0", 0},
        {"in_1_1", 1}, {"in_1_2", 2}, {"in_1_3", 3}};
    twoSwitches.addComponent("out_1", out0Conf);
    
    twoSwitches.setComponentConfig("out_0", "in_0_0");
    twoSwitches.setComponentConfig("out_1", "in_1_3");

    BitVector correctConfigData(3, "011");

    REQUIRE(twoSwitches.getConfigData() == correctConfigData);
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
