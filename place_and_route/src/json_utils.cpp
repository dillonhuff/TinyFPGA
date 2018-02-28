#include "json_utils.h"

#include <cassert>

using namespace picojson;

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

}
