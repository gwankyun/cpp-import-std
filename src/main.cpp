module;
// 此處引入頭文件

module main;
import std;

std::string compiler_name()
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

int main(int _argc, char* _argv[])
{
    std::println("Use std module on {}", compiler_name());
    return 0;
}
