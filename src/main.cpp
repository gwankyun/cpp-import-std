import std;
import compiler;

int main(int _argc, char* _argv[])
{
    std::println("compiler id     : {}", compiler::id());
    std::println("compiler version: {}", compiler::version());
    return 0;
}
