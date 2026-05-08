#[[
{
    "name": "clang",
    "inherits": "ninja",
    "cacheVariables": {
        "CMAKE_C_COMPILER": "$env{LLVM_MINGW_ROOT}/bin/clang.exe",
        "CMAKE_CXX_COMPILER": "$env{LLVM_MINGW_ROOT}/bin/clang++.exe"
    },
    "environment": {
        "PATH": "$penv{LLVM_MINGW_ROOT}/bin;$penv{PATH}"
    }
}
#]]

set(CMAKE_C_COMPILER   "$ENV{LLVM_MINGW_ROOT}/bin/clang.exe")
set(CMAKE_CXX_COMPILER "$ENV{LLVM_MINGW_ROOT}/bin/clang++.exe")
