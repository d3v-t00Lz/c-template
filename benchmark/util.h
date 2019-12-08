#ifndef TEST_TIME_H
#define TEST_TIME_H

#include <stddef.h>


#ifndef ITERATIONS
    #define ITERATIONS 1000000
#endif

#ifndef BENCH_SIZE_MB
    #define BENCH_SIZE_MB 100UL
#endif

#define BENCH_SIZE (BENCH_SIZE_MB * 1024UL * 1024UL)


/* Used for estimating how much memory a collection of objects will consume
 * in order to comply with BENCH_SIZE
 *
 * @objSize: The sizeof() the object to allocate in memory.  Note that you may
 *           need to add additional values to this to account for all memory
 *           to be consumed, ie: sizeof(myObject) + sizeof(myObject*)
 */
size_t BenchObjCount(
    size_t objSize
);

void TimeFunc(
    size_t (*func)(),
    char* name
);

#endif
