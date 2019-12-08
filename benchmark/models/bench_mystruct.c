#include <assert.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "../util.h"
#include "models/mystruct.h"
#include "bench_mystruct.h"


void BenchMyStruct(){
    TimeFunc(
	BenchMyStructFactory,
	"BenchMyStructFactory"
    );
    TimeFunc(
        BenchMyStructRepr,
        "BenchMyStructRepr"
    );
}

size_t BenchMyStructFactory(){
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
    return ITERATIONS;
}

size_t BenchMyStructRepr(){
    size_t i;
    struct MyStruct mystruct = (struct MyStruct){
        .a = 5,
        .b = "lol",
    };
    for(i = 0; i < ITERATIONS; ++i){
        char *str = MyStructRepr(&mystruct);
        free(str);
    }
    return ITERATIONS;
}
