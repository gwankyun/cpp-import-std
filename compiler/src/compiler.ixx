module;

#if !USE_IMPORT_STD
#include <string>
#endif

export module compiler; // 注意這裡有export

#if USE_IMPORT_STD
import std;
#endif

#if (defined(_MSC_VER) && !defined(__clang__)) || USE_EXPORT_IMPORT_HEADER
export import "compiler.h";
#else
#define COMPILER_USE_MODULE
#include "compiler.h"
#undef COMPILER_USE_MODULE
#endif
