import std;
import compiler;

int test()
{
#ifdef _MSC_VER
    if (compiler::id() != "MSVC")
    {
        return 1;
    }
#elif defined(__clang__)
    if (compiler::id() != "Clang")
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
    std::println("compiler id     : {}", compiler::id());
    std::println("compiler version: {}", compiler::version());

    return test();
}
