#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "../time.h"
#include "models/mystruct.h"
#include "bench_mystruct.h"

#ifndef ITERATIONS
    #define ITERATIONS 1000000
#endif

void BenchMyStruct(){
    TimeFunc(
	BenchMyStructFactory,
	"BenchMyStructFactory",
        ITERATIONS
    );
    TimeFunc(
        BenchMyStructRepr,
        "BenchMyStructRepr",
        ITERATIONS
    );
}

void BenchMyStructFactory(){
    size_t i;
    struct MyStruct mystruct = (struct MyStruct){
        .a = 5,
        .b = "lol",
    };
    struct MyStruct *m;

    for(i = 0; i < ITERATIONS; ++i){
        m = MyStructFactory(&mystruct);
        free(m);
    };
}

void BenchMyStructRepr(){
    size_t i;
    struct MyStruct mystruct = (struct MyStruct){
        .a = 5,
        .b = "lol",
    };
    for(i = 0; i < ITERATIONS; ++i){
        char *str = MyStructRepr(&mystruct);
        free(str);
    }
}
