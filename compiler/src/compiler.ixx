module;

#if !USE_IMPORT_STD
#include <string>
#endif

export module compiler; // 注意這裡有export

#if USE_IMPORT_STD
import std;
#endif

#define COMPILER_USE_MODULE

#include "compiler.h"
