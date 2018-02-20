#include "bitstream_format.h"

#include <fstream>
#include <streambuf>

using namespace picojson;
using namespace std;

namespace TinyPnR {

  picojson::value getValue(const std::string& name,
                           const picojson::value& v) {
    assert(v.is<object>());
    auto obj = v.get<object>();

    
    for (auto elem : obj) {
      if (elem.first == name) {
        return elem.second;
      }
    }

    assert(false);
  }

  BitStreamFormat loadBitStreamFormat(const std::string& jsonFile) {
    std::ifstream t(jsonFile);

    std::istream_iterator<char> input(t);
    picojson::value v;
    std::string err;
    input = picojson::parse(v, input, std::istream_iterator<char>(), &err);
    if (!err.empty()) {
      std::cerr << err << std::endl;
      assert(false);
    }

    BitStreamFormat format;
    value obj = getValue("top", v);

    value tstart = getValue("tile_id_start", obj);
    assert(tstart.is<double>());
    value tend = getValue("tile_id_end", obj);
    assert(tend.is<double>());

    format.setTileIdRange(static_cast<int>(tend.get<double>()),
                          static_cast<int>(tstart.get<double>()));

    value cstart = getValue("mod_id_start", obj);
    assert(cstart.is<double>());
    value cend = getValue("mod_id_end", obj);
    assert(cstart.is<double>());

    format.setComponentIdRange(static_cast<int>(cend.get<double>()),
                               static_cast<int>(cstart.get<double>()));
    
    value compMap = getValue("tiles_to_ids", obj);

    assert(compMap.is<object>());

    object compMapObj = compMap.get<object>();

    // Add mapping from tiles to ids
    for (auto entry : compMapObj) {
      string tileName = entry.first;

      value tileNum = entry.second;
      assert(tileNum.is<double>());

      format.addTile(tileName, static_cast<int>(tileNum.get<double>()));
    }

    // Build the actual tiles

    value tileMapVal = getValue("tile_map", obj);
    assert(tileMapVal.is<object>());

    for (auto entry : tileMapVal.get<object>()) {
      assert(entry.second.is<string>());

      string tileName = entry.first;

      // pe_tile_top_left, etc.
      string tileType = entry.second.get<string>();

      value modDef = getValue(tileType, v);
      assert(modDef.is<object>());

      TileConfig* tileConf = format.getTile(tileName);

      value compIds = getValue("mods_to_addrs", modDef);
      assert(compIds.is<object>());
      object compIdMap = compIds.get<object>();

      for (auto comp : compIdMap) {
        string compName = comp.first;
        value compId = comp.second;
        assert(compId.is<double>());

        ModuleConfig* moduleConf = tileConf->addModule(compName, static_cast<int>(compId.get<double>()));
        assert(moduleConf != nullptr);

        // Look up tile type and add components to it
        value modTp = getValue(tileType, v);
        assert(modTp.is<object>());

        // Look up the component of the mod map of this tile type
        value tileToModMapVal = getValue("mod_map", modTp);
        assert(tileToModMapVal.is<object>());

        cout << "Trying to find component name = " << compName << endl;

        value modTypeName = getValue(compName, tileToModMapVal);
        assert(modTypeName.is<string>());
        cout << "mod type = " << modTypeName.get<string>() << endl;
        // Add each module 
      
        //cout << "modTp = " << modTp.get<string>() << endl;
        

      }

    }

    
    return format;
  }
}
