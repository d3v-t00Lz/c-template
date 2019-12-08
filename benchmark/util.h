#ifndef TEST_TIME_H
#define TEST_TIME_H

#include <stddef.h>


#ifndef ITERATIONS
    #define ITERATIONS 1000000
#endif

#ifndef BENCH_SIZE_MB
    #define BENCH_SIZE_MB 100
#endif

#define BENCH_SIZE (BENCH_SIZE_MB * 1024 * 1024)


size_t BenchObjCount(
    size_t objSize
);

void TimeFunc(
    void (*func)(),
    char* name,
    size_t iterations
);

#endif
