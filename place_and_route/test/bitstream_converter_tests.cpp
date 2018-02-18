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
    std::map<std::string, ConfigurableComponent*> components;
    std::map<ConfigurableComponent*, int> componentOffsets;

  public:

    ModuleConfig(const std::string& name_) : name(name_) {
    }

    ~ModuleConfig() {
      for (auto comp : components) {
        delete comp.second;
      }
    }

    int getConfigDataWidth() const {
      int width = 0;
      for (auto comp : components) {
        width += comp.second->numConfigBits();
      }

      return width;
    }

    void addComponent(const std::string& componentName,
                      const int componentOffset,
                      std::map<ConfigLabel, int>& configMap) {
      int oldWidth = getConfigDataWidth();
      auto comp = new ConfigurableComponent(configMap);
      components[componentName] = comp;
      componentOffsets[comp] = componentOffset;
    }

    BitVector
    configDataForConfiguration(const std::map<std::string, ConfigLabel>& configMap) const {
      BitVector configBits(getConfigDataWidth(), 0);

      for (auto config : configMap) {
        assert(contains_key(config.first, components));

        ConfigurableComponent* comp = components.find(config.first)->second;

        assert(contains_key(comp, componentOffsets));

        int offset = componentOffsets.find(comp)->second;

        BitVector compExtended(getConfigDataWidth(), 0);
        BitVector compOriginal = comp->configBitPattern(config.second);

        for (int i = 0; i < compOriginal.bitLength(); i++) {
          compExtended.set(i + offset, compOriginal.get(i));
        }

        configBits = configBits | compExtended;
      }

      return configBits;
    }
  };

  class TileConfig {
  public:
    std::string tileName;

    std::vector<ModuleConfig> components;

    std::map<ModuleConfig*, int> modsToAddrs;

    TileConfig(const std::string& tileName_) : tileName(tileName_) {}

    ~TileConfig() {
      for (auto mod : modsToAddrs) {
        delete mod.first;
      }
    }

    ModuleConfig* addModule(const std::string& modName,
                            const int addr) {
      ModuleConfig* mod = new ModuleConfig(modName);
      modsToAddrs[mod] = addr;
      return mod;
    }

  };

  // Full input to format conversion should be:
  // 1. Tile name
  // 2. Module name
  // 3. Map from module component names (switch and PE names) to component labels
  class BitStreamFormat {

    std::map<std::string, TileConfig*> tileMap;
    
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

    void addTile(const std::string& tileName, const int tileId) {
      TileConfig* tile = new TileConfig(tileName);
      tileMap[tileName] = tile;
    }

    TileConfig* getTile(const std::string& tileName) {
      assert(contains_key(tileName, tileMap));

      return tileMap.find(tileName)->second;
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
    twoSwitches.addComponent("out_0", 2, out0Conf);

    map<ConfigLabel, int> out1Conf{{"in_1_0", 0},
        {"in_1_1", 1}, {"in_1_2", 2}, {"in_1_3", 3}};
    twoSwitches.addComponent("out_1", 0, out1Conf);

    SECTION("Config width is 3") {
      REQUIRE(twoSwitches.getConfigDataWidth() == 3);
    }

    SECTION("Generating configuration data for a given config") {
      map<string, ConfigLabel> config{{"out_0", "in_0_0"},
          {"out_1", "in_1_3"}};

      BitVector correctConfigData(3, "011");

      REQUIRE(twoSwitches.configDataForConfiguration(config) == correctConfigData);
    }
  }

  TEST_CASE("Computing placement addresses") {
    BitStreamFormat format;
    format.setAddressWidth(32);
    format.setTileIdRange(31, 16);
    format.setComponentIdRange(15, 0);

    format.addTile("pe_tile_0", 16);

    TileConfig* switchTile = format.getTile("pe_tile_0");

    ModuleConfig* twoSwitches = switchTile->addModule("twoSwitches", 5);
    map<ConfigLabel, int> out0Conf{{"in_0_0", 0},
      {"in_0_1", 1}};
    twoSwitches->addComponent("out_0", 2, out0Conf);

    map<ConfigLabel, int> out1Conf{{"in_1_0", 0},
        {"in_1_1", 1}, {"in_1_2", 2}, {"in_1_3", 3}};
    twoSwitches->addComponent("out_1", 0, out1Conf);

    
    // map<std::string, int> tileNamesToIds;
    // tileNamesToIds.insert({"pe_tile_123", 123});

    // format.setTileNameMap(tileNamesToIds);

    // Q: How to deal with hierarchy? List of tiles where
    // each tile in tileNamesToIds may have a different layout?
  }
}
