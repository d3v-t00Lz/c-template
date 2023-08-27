#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "models/mystruct.h"
#include "test_mystruct.h"


void TestMyStruct(){
    TestMyStructFactory();
    TestMyStructRepr();
}

void TestMyStructFactory(){
    struct MyStruct mystruct;
    MyStructFactory(&mystruct);
    assert(mystruct.a == 5);
    assert(!strcmp(mystruct.b, "lol"));
}

void TestMyStructRepr(){
    struct MyStruct mystruct = (struct MyStruct){
        .a = 5,
        .b = "lol",
    };
    char str[40] = "";
    MyStructRepr(&mystruct, str, 40);
    assert(!strcmp(str, "lol5"));
}
