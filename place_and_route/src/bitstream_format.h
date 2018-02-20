#pragma once

#include "algorithm.h"
#include "dynamic_bit_vector.h"
#include "picojson.h"

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
      auto comp = new ConfigurableComponent(configMap);
      components[componentName] = comp;
      componentOffsets[comp] = componentOffset;
    }

    BitVector
    configDataForConfiguration(const std::map<std::string, ConfigLabel>& configMap) const {

      std::cout << "before conf" << std::endl;
      BitVector configBits(getConfigDataWidth(), 0);
      std::cout << "after conf" << std::endl;

      for (auto config : configMap) {
        assert(contains_key(config.first, components));

        std::cout << "Config = " << config.first << std::endl;

        ConfigurableComponent* comp = components.find(config.first)->second;

        assert(contains_key(comp, componentOffsets));

        int offset = componentOffsets.find(comp)->second;

        BitVector compExtended(getConfigDataWidth(), 0);
        BitVector compOriginal = comp->configBitPattern(config.second);

        std::cout << "Built config" << std::endl;

        for (int i = 0; i < compOriginal.bitLength(); i++) {
          compExtended.set(i + offset, compOriginal.get(i));
        }

        configBits = configBits | compExtended;
      }

      std::cout << "Configbits = " << configBits << std::endl;

      return configBits;
    }
  };

  class TileConfig {
  public:
    std::string tileName;

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

    ModuleConfig* getModule(const std::string& modName) const {
      assert(contains_key(modName, modMap));
      return modMap.find(modName)->second;
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

    int numTiles() const {
      return tileMap.size();
    }

    int getTileIdStart() const {
      return tileIdStart;
    }
      
    int getTileIdEnd() const {
      return tileIdEnd;
    }

    int getComponentIdStart() const {
      return componentIdStart;
    }
      
    int getComponentIdEnd() const {
      return componentIdEnd;
    }
    
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

    BitVector getConfigData(const std::string tileName,
                            const std::string modName,
                            const std::map<std::string, ConfigLabel>& configLabels) const {
      assert(contains_key(tileName, tileMap));

      auto tile = tileMap.find(tileName)->second;

      std::cout << "Tile = " << tile << std::endl;

      ModuleConfig* modConfig = tile->getModule(modName);

      std::cout << "modConfig = " << modConfig << std::endl;

      return modConfig->configDataForConfiguration(configLabels);
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

  BitStreamFormat loadBitStreamFormat(const std::string& jsonFile);

}
