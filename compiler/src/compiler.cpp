module;
#include "compiler_info.h"

module compiler; // 注意這裡無export
import std;

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
