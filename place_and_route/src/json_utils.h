#pragma once

#include "picojson.h"

namespace TinyPnR {

  picojson::value getValue(const std::string& name,
                           const picojson::value& v);

}
