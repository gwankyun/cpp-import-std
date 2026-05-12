#ifndef COMPILER_USE_MODULE
#include "compiler.h"
#include "compiler_info.h"
#include <string>
#endif // !COMPILER_USE_MODULE

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
