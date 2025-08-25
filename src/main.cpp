module;
#include <spdlog/spdlog.h>

module main;
import std;

int main(int _argc, char* _argv[])
{
    spdlog::set_pattern("[%C-%m-%d %T.%e] [%-8!!:%4#] %v");
    std::println("use std mdoule");
    SPDLOG_INFO("use spdlog");
    return 0;
}
