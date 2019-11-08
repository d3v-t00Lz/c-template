#include <assert.h>
#include <malloc.h>
#include <stdio.h>

#include "models/mystruct.h"

struct MyStruct *MyStructFactory(
    struct MyStruct *m
){
    struct MyStruct *mystruct = (struct MyStruct*)malloc(
        sizeof(struct MyStruct)
    );
    *mystruct = *m;
    return mystruct;
}

char* MyStructRepr(
    struct MyStruct *self
){
    int size = 40;
    char *repr = (char*)malloc(size);
    int written = snprintf(
        repr,
        40,
        "%s%i",
        self->b,
        self->a
    );
    assert(written < size);
    return repr;
}
