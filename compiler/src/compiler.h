#ifndef COMPILER_USE_MODULE
#include <string>
#define COMPILER_EXPORT
#else
#define COMPILER_EXPORT export
#endif

COMPILER_EXPORT namespace compiler
{
    std::string id();
    std::string version();
} // namespace compiler
