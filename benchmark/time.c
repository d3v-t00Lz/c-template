#include <stdio.h>
#include <time.h>


void TimeFunc(
    void (*func)(),
    char* name,
    size_t iterations
){
    clock_t start, end;
    double time_used, seconds_per_iteration;

    start = clock();
    func();
    end = clock();
    time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    seconds_per_iteration = time_used / (double)(iterations);
    printf(
	"Ran %s:\n"
        "  %lu iterations\n"
        "  %f seconds\n"
        "  %f seconds per iteration\n",
	name,
        iterations,
	time_used,
        seconds_per_iteration
    );
}
