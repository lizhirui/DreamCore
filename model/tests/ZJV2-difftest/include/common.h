#ifndef COMMON_H
#define COMMON_H

#include "debug.h"

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <string.h>


#define glue_prim(a, b) a##b
#define glue(a, b) glue_prim(a, b)

#define BIT(nr) (1 << (nr))
#define GENMASK(h, l) \
  (((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))

#define GENMASK_ULL(h, l) \
  (((~0ULL) << (l)) &     \
      (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))

/* VT 102 colored text */
#define ANSI_WIDTHOR_RED "\e[31m"
#define ANSI_WIDTHOR_GREEN "\e[32m"
#define ANSI_WIDTHOR_YELLOW "\e[33m"
#define ANSI_WIDTHOR_BLUE "\e[34m"
#define ANSI_WIDTHOR_MAGENTA "\e[35m"
#define ANSI_WIDTHOR_CYAN "\e[36m"
#define ANSI_WIDTHOR_RESET "\e[0m"

/* #define CONFIG_X 0
 * #define CONFIG_Y 1
 * #undef  CONFIG_O
 * HAS_CONFIG(X) ==> 0
 * HAS_CONFIG(Y) ==> 1
 * HAS_CONFIG(O) ==> 0
 * */
#define MA_LIST_2nd_impl(a, b, ...) b
#define MA_LIST_2nd(...) MA_LIST_2nd_impl(__VA_ARGS__, 0)
#define HAS_CONFIG_EXPAND(a) \
  glue_prim(HAS_CONFIG_EXPAND_, a)
#define HAS_CONFIG_EXPAND_0 _, 0
#define HAS_CONFIG_EXPAND_1 _, 1
#define HAS_CONFIG(v) \
  MA_LIST_2nd(HAS_CONFIG_EXPAND(glue(CONFIG_, v)), 0)

#define ON_CONFIG_IGNORE(...)
#define ON_CONFIG_KEEP(...) __VA_ARGS__
#define ON_CONFIG_0 _, ON_CONFIG_IGNORE
#define ON_CONFIG_1 _, ON_CONFIG_KEEP
#define ON_CONFIG_EXPAND(a) glue_prim(ON_CONFIG_, a)
#define ON_CONFIG(v, ...)                             \
  ON_CONFIG_KEEP(                                     \
      MA_LIST_2nd(ON_CONFIG_EXPAND(glue(CONFIG_, v)), \
          ON_CONFIG_IGNORE)(__VA_ARGS__))

#define ALWAYS_INLINE inline __attribute__((always_inline))
#define UNLIKELY(cond) __builtin_expect(!!(cond), 0)
#define LIKELY(cond) __builtin_expect(!!(cond), 1)

#endif
