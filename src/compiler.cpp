module compiler;
import std;

namespace compiler
{
    std::string name()
    {
#ifdef _MSC_VER
        return "MSVC";
#elif defined(__clang__)
        return "Clang";
#elif defined(__GNUC__)
        return "GCC";
#else
        return "Other";
#endif
    }
} // namespace compiler
