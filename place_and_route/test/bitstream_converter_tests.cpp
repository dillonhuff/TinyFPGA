#include "catch.hpp"

#include <fstream>
#include <streambuf>

#include "bitstream_format.h"

using namespace std;

namespace TinyPnR {

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

  TEST_CASE("Load an entire bitstream format for 3 x 3 tile FPGA") {
    BitStreamFormat format = loadBitStreamFormat("./test/top.json");

    SECTION("tileMap has 9 entries") {
      REQUIRE(format.numTiles() == 9);
    }

    SECTION("Config address layout is correct") {
      REQUIRE(format.getTileIdStart() == 0);
      REQUIRE(format.getTileIdEnd() == 15);
      REQUIRE(format.getComponentIdStart() == 16);
      REQUIRE(format.getComponentIdEnd() == 31);
    }

    SECTION("Compute switch box address and data") {

      SECTION("Config address computation") {

        REQUIRE(format.getAddress("pe_tile_1_2", "cb0").hex_string() == "32'h00060006");

        REQUIRE(format.getAddress("pe_tile_1_1", "cb1").hex_string() == "32'h00050005");

        REQUIRE(format.getAddress("pe_tile_1_1", "sb").hex_string() == "32'h00050007");

        REQUIRE(format.getAddress("pe_tile_0_0", "clb").hex_string() == "32'h00010004");
      }

      SECTION("Config data computation") {
        map<string, ConfigLabel> configMap{{"block_out", "track4_in"}};

        REQUIRE(format.getConfigData("pe_tile_2_2", "cb0", configMap).hex_string() == "32'h00000004");
      }

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
