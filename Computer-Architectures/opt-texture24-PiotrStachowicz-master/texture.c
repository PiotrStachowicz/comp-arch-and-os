/*
 * row-major vs. tiled texture queries
 *
 * Intel® Core™ i5-6600 CPU @ 3.30GHz
 *
 * $ ./texture -S 0xdeadc0de -t 65536 -v 0
 * Time elapsed: 1.707234 seconds.
 * $ ./texture -S 0xdeadc0de -t 65536 -v 1
 * Time elapsed: 1.031514 seconds.
 * $ ./texture -S 0xdeadc0de -t 65536 -v 2
 * Time elapsed: 0.935953 seconds.
 */
#include "texture.h"

static inline long index_0(long x, long y) {
  return y * N + x;
}

#define VARIANT 0
#include "texture_impl.h"

static inline long index_1(long x, long y) {
  // Zaimplementowałem Morton Code, bo ciekawsze
  long z = 0;

  for (long k = 0; k < (long)sizeof(x) * 8; ++k)
  {
    z |= ((x & (1l << k)) << k) | 
          ((y & (1l << k)) << (k + 1));
  }

  return z;
}

#define VARIANT 1
#include "texture_impl.h"
