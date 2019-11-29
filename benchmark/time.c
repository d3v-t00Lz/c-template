#include <stdio.h>
#include <time.h>


void TimeFunc(
    void (*func)(),
    char* name,
    size_t iterations
){
    int i;
    clock_t start, end;
    double time_used, units_per_iteration;
    char* time_unit = NULL;
    char time_units[5][20] = {
        "seconds",
        "milliseconds",
        "microseconds",
        "nanoseconds",
        "picoseconds"
    };

    start = clock();
    func();
    end = clock();
    time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    units_per_iteration = (time_used / (double)(iterations));

    for(i = 0; i < 5; ++i){
        if(units_per_iteration >= 1.){
            time_unit = time_units[i];
            break;
        }
        units_per_iteration *= 1000.;
    }

    printf(
	"Ran %s:\n"
        "  %lu iterations\n"
        "  %f seconds\n"
        "  %f %s average per iteration\n",
	name,
        iterations,
	time_used,
        units_per_iteration,
        time_unit
    );
}
