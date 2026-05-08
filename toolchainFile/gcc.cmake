#[[
{
    "name": "gcc",
    "inherits": "ninja",
    "cacheVariables": {
        "CMAKE_C_COMPILER": "$env{MINGW64_ROOT}/bin/gcc.exe",
        "CMAKE_CXX_COMPILER": "$env{MINGW64_ROOT}/bin/g++.exe",
        "USE_IMPORT_STD": "OFF"
    },
    "environment": {
        "PATH": "$penv{MINGW64_ROOT}/bin;$penv{PATH}"
    }
}
#]]

set(CMAKE_C_COMPILER   "$ENV{MINGW64_ROOT}/bin/gcc.exe")
set(CMAKE_CXX_COMPILER "$ENV{MINGW64_ROOT}/bin/g++.exe")
