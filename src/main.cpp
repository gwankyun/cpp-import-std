#if USE_IMPORT_STD
import std;
#else
#include <iostream>
#endif

#if USE_MODULE
import compiler;
#else
#include "compiler.h"
#endif

#define CHECK(_cond) \
    if (!(_cond)) \
    { \
        std::cout << "error on: " << __LINE__ << std::endl; \
        return 1; \
    }

int test()
{
#if defined(__clang__) && defined(_MSC_VER)
    CHECK(compiler::id() == "Clang");
    CHECK(USE_MODULE);
    CHECK(!USE_IMPORT_STD);
#elif defined(_MSC_VER)
    CHECK(compiler::id() == "MSVC");
#elif defined(__clang__)
    CHECK(compiler::id() == "Clang");
#elif defined(__GNUC__)
    CHECK(compiler::id() == "GNU");
    CHECK(USE_MODULE);
    CHECK(!USE_IMPORT_STD);
#else
    return 1;
#endif

    return 0;
}

int main(int _argc, char* _argv[])
{
    std::cout << "compiler id     : " << compiler::id() << std::endl;
    std::cout << "compiler version: " << compiler::version() << std::endl;
    std::cout << "USE_MODULE      : " << USE_MODULE << std::endl;
    std::cout << "USE_IMPORT_STD  : " << USE_IMPORT_STD << std::endl;

    return test();
}
