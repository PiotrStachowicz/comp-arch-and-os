/*
 * Matrix multiplication with and without blocking.
 *
 * Intel® Core™ i5-6600 CPU @ 3.30GHz
 *
 * $ ./matmult -n 1024 -v 0
 * Time elapsed: 3.052755 seconds.
 * $ ./matmult -n 1024 -v 1
 * Time elapsed: 0.746337 seconds.
 * $ ./matmult -n 1024 -v 2
 * Time elapsed: 9.882309 seconds.
 * $ ./matmult -n 1024 -v 3
 * Time elapsed: 0.698795 seconds.
 */
#include "matmult.h"

/* Useful macro for accessing row-major 2D arrays of size n×n. */
#define M(a, i, j) a[(i) * n + (j)]

/* ijk (& jik) */
void matmult0(int n, T_p a, T_p b, T_p c)
{
  for (int i = 0; i < n; ++i)
    for (int j = 0; j < n; ++j)
      for (int k = 0; k < n; ++k)
        M(c, i, j) += M(a, i, k) * M(b, k, j);
}

/* kij (& ikj) */
void matmult1(int n, T_p a, T_p b, T_p c) 
{
  for (int k = 0; k < n; ++k)
    for (int i = 0; i < n; ++i)
      for (int j = 0; j < n; ++j)
        M(c, i, j) += M(a, i, k) * M(b, k, j);
}

/* jki (& kji) */
void matmult2(int n, T_p a, T_p b, T_p c) 
{
  for (int j = 0; j < n; ++j)
    for (int k = 0; k < n; ++k)
      for (int i = 0; i < n; ++i)
        M(c, i, j) += M(a, i, k) * M(b, k, j);
}

/* BLOCK*BLOCK tiled version */
void matmult3(int n, T_p a, T_p b, T_p c) 
{
  for (int i = 0; i < n; i += BLOCK)
    for (int j = 0; j < n; j += BLOCK)
      for (int k = 0; k < n; k += BLOCK)
        for (int inner_i = i; inner_i < i + BLOCK; ++inner_i)
          for (int inner_j = j; inner_j < j + BLOCK; ++inner_j)
            for (int inner_k = k; inner_k < k + BLOCK; ++inner_k)
              M(c, inner_i, inner_j) += M(a, inner_i, inner_k) * M(b, inner_k, inner_j);
}
