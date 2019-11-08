#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "models/mystruct.h"
#include "models/test_mystruct.h"


void TestMyStruct(){
    TestMyStructFactory();
    TestMyStructRepr();
}

void TestMyStructFactory(){
    struct MyStruct mystruct = (struct MyStruct){
        .a = 5,
        .b = "lol",
    };

    struct MyStruct *m = MyStructFactory(&mystruct);
    assert(m->a == mystruct.a);
    assert(strcmp(m->b, mystruct.b) == 0);
    free(m);
}

void TestMyStructRepr(){
    struct MyStruct mystruct = (struct MyStruct){
        .a = 5,
        .b = "lol",
    };
    char *str = MyStructRepr(&mystruct);
    assert(str);
    free(str);
}
