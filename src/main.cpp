#if !USE_IMPORT_STD
#include <iostream>
#endif

#if USE_IMPORT_STD
import std;
#endif

import compiler;

int test()
{
#if defined(_MSC_VER)
    if (compiler::id() != "MSVC")
    {
        return 1;
    }
#elif defined(__clang__)
    if (compiler::id() != "Clang")
    {
        return 1;
    }
#elif defined(__clang__)
    if (compiler::id() != "Clang")
    {
        return 1;
    }
#elif defined(__GNUC__)
    if (compiler::id() != "GNU")
    {
        return 1;
    }
#else
    return 1;
#endif

    return 0;
}

int main(int _argc, char* _argv[])
{
    std::cout << "compiler id     : " << compiler::id() << std::endl;
    std::cout << "compiler version: " << compiler::version() << std::endl;
    std::cout << "USE_IMPORT_STD  : " << USE_IMPORT_STD << std::endl;

    return test();
}
