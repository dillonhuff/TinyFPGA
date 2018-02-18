#include "catch.hpp"

#include <fstream>
#include <streambuf>

#include "algorithm.h"
#include "dynamic_bit_vector.h"
#include "picojson.h"

using namespace std;

namespace TinyPnR {

  typedef dynamic_bit_vector BitVector;

  typedef std::string ConfigLabel;

  class ConfigurableComponent {

    std::map<ConfigLabel, int> configMapping;

  public:

    int nConfigBits;

    ConfigurableComponent(const std::map<ConfigLabel, int>& configMapping_) :
      configMapping(configMapping_) {}

    int numConfigBits() {
      return ceil(log2(configMapping.size()));
    }

    BitVector configBitPattern(const ConfigLabel& label) {

      assert(contains_key(label, configMapping));
      
      return BitVector(numConfigBits(), configMapping[label]);
    }

  };

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

    std::map<std::string, ModuleConfig*> modMap;
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
      modMap[modName] = mod;
      return mod;
    }

    int getModuleAddr(const std::string& modName) {
      ModuleConfig* mod = modMap[modName];
      return modsToAddrs[mod];
    }

  };

  class BitStreamFormat {

    std::map<std::string, TileConfig*> tileMap;
    std::map<TileConfig*, int> tilesToIds;

    int tileIdStart;
    int tileIdEnd;

    int componentIdStart;
    int componentIdEnd;
    
  public:

    void setAddressWidth(const int i) {
    }

    void setDataWidth(const int i) {
    }
    
    void setTileIdRange(const int end, const int start) {
      tileIdStart = start;
      tileIdEnd = end;
    }

    void setComponentIdRange(const int end, const int start) {
      componentIdStart = start;
      componentIdEnd = end;
    }

    void setTileNameMap(const std::map<std::string, int>& tileNamesToIds) {
    }

    void addTile(const std::string& tileName, const int tileId) {
      TileConfig* tile = new TileConfig(tileName);
      tileMap[tileName] = tile;
      tilesToIds[tile] = tileId;
    }

    TileConfig* getTile(const std::string& tileName) {
      assert(contains_key(tileName, tileMap));

      return tileMap.find(tileName)->second;
    }

    BitVector getAddress(const std::string tileName,
                         const std::string modName) {
      auto tile = tileMap[tileName];
      BitVector tileAddr(tileIdEnd - tileIdStart + 1, tilesToIds[tile]);

      BitVector modAddr(componentIdEnd - componentIdStart + 1,
                        tile->getModuleAddr(modName));
      return concat(static_cast<BitVector>(modAddr),
                    static_cast<BitVector>(tileAddr));
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

    SECTION("Compute tile module address") {
      BitVector addr = format.getAddress("pe_tile_0", "twoSwitches");

      REQUIRE(addr == BitVector("32'h00100005"));
    }

  }

  TEST_CASE("Loading a module") {
    std::ifstream t("./test/switch_box.json");

    std::istream_iterator<char> input(t);
    picojson::value v;
    std::string err;
    input = picojson::parse(v, input, std::istream_iterator<char>(), &err);
    if (!err.empty()) {
      std::cerr << err << std::endl;
    }

    // check if the type of the value is "object"
    if (!v.is<picojson::object>()) {
      std::cerr << "JSON is not an object" << std::endl;
      exit(2);
    }


    // obtain a const reference to the map, and print the contents
    const picojson::value::object& obj = v.get<picojson::object>();

    string modName;
    for (picojson::value::object::const_iterator i = obj.begin(); i != obj.end(); ++i) {
      std::cout << i->first << ": " << i->second.to_str() << std::endl;
      if (i->first == "mod_name") {
        auto nm = i->second;
        modName = nm.get<string>();
      }
    }

    ModuleConfig mod(modName);

    for (picojson::value::object::const_iterator i = obj.begin(); i != obj.end(); ++i) {
      std::cout << i->first << ": " << i->second.to_str() << std::endl;
      if (i->first == "components") {
        auto nm = i->second;

        REQUIRE(nm.is<picojson::array>());

        for (auto comp : nm.get<picojson::array>()) {
          REQUIRE(comp.is<picojson::object>());

          auto compObj = comp.get<picojson::object>();

          string compName;
          int componentOffset = 0;
          map<ConfigLabel, int> configMap;

          for (auto val : compObj) {
            if (val.first == "name") {
              compName = val.second.get<string>();
            } else if (val.first == "offset") {
              componentOffset = static_cast<int>(val.second.get<double>());
            } else if (val.first == "config_map") {
              auto compMap = val.second.get<picojson::object>();
              for (auto comp : compMap) {
                configMap.insert({comp.first, static_cast<double>(comp.second.get<double>())});
              }
            }
          }

          mod.addComponent(compName, componentOffset, configMap);
        }
      }
    }

    SECTION("32 bit configuration") {
      REQUIRE(mod.getConfigDataWidth() == 32);
    }

  }
}
