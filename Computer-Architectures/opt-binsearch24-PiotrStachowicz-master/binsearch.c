/*
 * Binary search with linearly placed tree levels.
 *
 * Intel® Core™ i5-6600 CPU @ 3.30GHz
 *
 * $ ./binsearch -S 0x5bab3de5da7882ff -n 23 -t 24 -v 0
 * Time elapsed: 7.616777 seconds.
 * $ ./binsearch -S 0x5bab3de5da7882ff -n 23 -t 24 -v 1
 * Time elapsed: 2.884369 seconds.
 */
#include "binsearch.h"

bool binsearch0(T *arr, long size, T x)
{
  do
  {
    size >>= 1;
    
    T y = arr[size];
    
    if (y == x) return true;
    
    if (y < x) arr += size + 1;
  
  } while (size > 0);
  
  return false;
}

void linearize(T *dst, T *src, long size)
{
    int dst_idx = 0;
    
    for (int jump = size + 1, i = size >> 1; dst_idx < size; jump >>= 1, i >>= 1) // size = 2^n - 1 więc jump = size + 1
    {
        for (int idx = i; idx < size; idx += jump, ++dst_idx)
        {
            dst[dst_idx] = src[idx];
        }
    }
}

bool binsearch1(T *arr, long size, T x)
{
    // arr to drzewo bst kolejnych "pivotów", zapisane w tablicy jak kopiec binarny, więc żeby dostać się do syna
    // i-tego wierzchołka, robimy 2i (lewy) lub 2i + 1 (prawy)
    for (int i = 1; i <= size;)
    {
        T val = arr[i - 1];

        if (x == val) return true;

        if (x > val) i <<= 1, ++i;

        else i <<= 1;
    }
    return false;
}
