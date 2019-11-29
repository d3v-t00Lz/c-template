#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "../time.h"
#include "models/mystruct.h"
#include "test_mystruct.h"

#ifndef ITERATIONS
    #define ITERATIONS 1000000
#endif

void TestMyStruct(){
    TimeFunc(
	TestMyStructFactory,
	"TestMyStructFactory",
        ITERATIONS
    );
    TimeFunc(
        TestMyStructRepr,
        "TestMyStructRepr",
        ITERATIONS
    );
}

void TestMyStructFactory(){
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

void TestMyStructRepr(){
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
