module;
#include "compiler_info.h"

#if !USE_IMPORT_STD
#include <string>
#endif

module compiler; // 注意這裡無export

#if USE_IMPORT_STD
import std;
#endif

#define COMPILER_USE_MODULE

#include "compiler_impl.hpp"
