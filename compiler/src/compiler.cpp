module;
#include "compiler_info.h"

#if !USE_IMPORT_STD
#include <string>
#endif

module compiler; // 注意這裡無export

#if USE_IMPORT_STD
import std;
#endif

namespace compiler
{
    std::string id()
    {
        return CXX_COMPILER_ID;
    }

    std::string version()
    {
        return CXX_COMPILER_VERSION;
    }
} // namespace compiler
